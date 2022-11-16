extends Resource

export var min_volume = 80
export var volume_modifier = 0.8

export var resolution_list: Array = ["640x480", "1280x720", "1920x1080", "2048x1080", 
									"2560x1440", "3840x2160", "7680x4320"]

#Settings will NOT display or allow you to reconfigure these keys
export var input_map_ignored_actions: Array = [ "ui_select", "ui_accept", "ui_cancel", 
										"ui_focus_next", "ui_focus_prev", "ui_left",
										"ui_right", "ui_up", "ui_down", "ui_page_up", 
										"ui_page_down", "ui_home", "ui_end" ]

export var settings : Dictionary = {resolution = OS.get_window_size(), 
					fullscreen = OS.window_fullscreen, 
					vsync = OS.vsync_enabled,
					brightness = 1, #TODO
					master_volume = get_audio_bus_volume("Master"), 
					music_volume = get_audio_bus_volume("Music"),
					sound_effects_volume = get_audio_bus_volume("Sound Effects"),
					voice_over_volume = get_audio_bus_volume("Voice Over"),
					keymap = get_keymap()
					}

func get_audio_bus_volume(bus: String) -> int:
	return (AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus)) + min_volume) / volume_modifier

func set_audio_bus_volume(bus: String, volume: int) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), (volume * volume_modifier) - min_volume)

func get_keymap() -> Dictionary:
	var _keymap: Dictionary
	for action in InputMap.get_actions():
		if !input_map_ignored_actions.has(action):
			_keymap[action] = InputMap.get_action_list(action)[0]
	return _keymap

func set_keymap(keymap: Dictionary) -> void:
	for action in keymap:
		InputMap.get_action_list(action)[0] = action[0]

func get_current_active_settings() -> Dictionary:
	return {resolution = OS.get_window_size(), 
			fullscreen = OS.window_fullscreen, 
			vsync = OS.vsync_enabled,
			brightness = 1, #TODO
			master_volume = get_audio_bus_volume("Master"), 
			music_volume = get_audio_bus_volume("Music"),
			sound_effects_volume = get_audio_bus_volume("Sound Effects"),
			voice_over_volume = get_audio_bus_volume("Voice Over"),
			keymap = get_keymap()
			}
