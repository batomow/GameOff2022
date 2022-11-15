extends Control

onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var _default_settings: Dictionary
var _settings : Dictionary
var _cached_settings: Dictionary

var SettingsConfig

var _has_changes: bool = false

func _ready() -> void:
	var config = load("res://Resources/SettingsConfig.gd")
	SettingsConfig = config.new()

	_settings = SettingsConfig.get_current_active_settings()
	_cached_settings = _settings.duplicate()

	#TODO: if savesmanger does not have a ref to a _default_settings save
	#			-> save _settings as _default_settings
	init_settings()

func init_settings() -> void:
	#TODO: Load _default_settings from save manager
	#TODO: Load _settings from save manager
	$VBoxContainer/SettingsTabContainer/ControlsSettings.set_up(_settings)
	$VBoxContainer/SettingsTabContainer/GraphicsSettings.set_up(_settings)
	$VBoxContainer/SettingsTabContainer/VolumeSettings.set_up(_settings)

func _on_value_changed(value) -> void:
	if not audio_stream_player:
		return;
	audio_stream_player.play()
	yield(audio_stream_player, "finished")
	
	cache_new_value(value)

func _option_pressed(option: String) -> void:
	#dont play noise when leaving popup focus
	if option == "popup_focus_left":
			hide_popup()
			return
	
	audio_stream_player.play()
	yield(audio_stream_player, "finished")

	match option:
		"back":
			if _has_changes:
				$PopupPanel.popup_centered()
				$VBoxContainer.hide()
			else:
				close_settings()
		"apply":
			save_settings()
		"apply_and_leave":
			save_settings()
			hide_popup() #temp
			close_settings()
		"reset_defaults":
			revert_settings()
		"discard_changes":
			hide_popup() #temp
			close_settings()
		"cancel":
			hide_popup()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		_option_pressed("back")

func save_settings() -> void:
	show_apply_button(false)
	_has_changes = false
	_settings = _cached_settings
	#TODO: Save _settings with save manager

func close_settings() -> void:
	apply_settings(_settings)
	#TODO: SceneManager transition to previous scene
	
func cache_new_value(value) -> void:
	_cached_settings.merge(value, true)
	apply_settings(_cached_settings)
	show_apply_button(true)
	_has_changes = true

func revert_settings() -> void:
	show_apply_button(false)
	_settings = _default_settings
	apply_settings(_settings)

func show_apply_button(is_visible: bool) -> void:
	$VBoxContainer/Apply.visible = is_visible
	$VBoxContainer/Spacer.visible = !is_visible

func hide_popup() -> void:
	$PopupPanel.hide()
	$VBoxContainer.show()

func apply_settings(settings_to_apply: Dictionary) -> void:
	#Graphics
	OS.set_window_size(settings_to_apply.resolution)
	get_tree().set_screen_stretch(
		SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, settings_to_apply.resolution
	)
	OS.window_fullscreen = settings_to_apply.fullscreen
	OS.vsync_enabled = settings_to_apply.vsync
	#TODO brightness, modify the public enviorment
	#	note: brightness will be 0-100 in settings, need to convert to enviorments 0-1
	
	#Controls
	SettingsConfig.set_keymap(settings_to_apply.keymap)
	
	#Volume
	SettingsConfig.set_audio_bus_volume("Master", settings_to_apply.master_volume)
	SettingsConfig.set_audio_bus_volume("Music", settings_to_apply.music_volume)
	SettingsConfig.set_audio_bus_volume("Sound Effects", settings_to_apply.sound_effects_volume)
	SettingsConfig.set_audio_bus_volume("Voice Over", settings_to_apply.voice_over_volume)
