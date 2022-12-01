extends Control

export (Array, AudioStream) var audio_streams
onready var sfx_player = $SFXPlayer

func _on_option_pressed(option: String) -> void:
	match option:
		"Start":
			start_game()
		"Load":
			load_game()
		"Continue":
			open_last_save()
		"Settings":
			open_settings()
		"Quit":
			quit_game()
	pass

func start_game() -> void:
	#SavesManager.create_new_save()
	sfx_player.stream = audio_streams[0]
	sfx_player.play()
	print("STARTING GAME")
	ScenesManager.transition_scene("Room 1", {})

func load_game() -> void:
	#SavesManager.load_game(file_name: String)
	print("LOADING GAME(s)")

func open_last_save() -> void:
	#var last_save = SavesManager.get_last_save()
	#SavesManager.load_game(last_save)
	print("OPENING LAST SAVE")

func open_settings() -> void:
	ScenesManager.transition_scene("Settings", {})

func quit_game() -> void:
	get_tree().quit()

func _on_ButtonsContainer_option_focused():
	if sfx_player.playing: 
		return
	sfx_player.stream = audio_streams[1]
	sfx_player.play()
