extends Control

export var audio_streams: AudioStream

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
	print("STARTING GAME")
	ScenesManager.transition_scene("Floor1", {})

func load_game() -> void:
	#SavesManager.load_game(file_name: String)
	print("LOADING GAME(s)")

func open_last_save() -> void:
	#var last_save = SavesManager.get_last_save()
	#SavesManager.load_game(last_save)
	print("OPENING LAST SAVE")

func open_settings() -> void:
	#SceneManager.transition_scene(PackedScene Settings, state)
	print("OPENING SETTINGS")

func quit_game() -> void:
	get_tree().quit()
