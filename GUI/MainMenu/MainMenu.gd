extends Control

export var audio_streams: AudioStream

func _on_button_pressed(option: String):
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

func start_game():
	#SavesManager.create_new_save()
	print("STARTING GAME")

func load_game():
	#SavesManager.load_game(file_name: String)
	print("LOADING GAME(s)")

func open_last_save():
	#var last_save = SavesManager.get_last_save()
	#SavesManager.load_game(last_save)
	print("OPENING LAST SAVE")

func open_settings():
	#SceneManager.transition_scene(PackedScene Settings, state)
	print("OPENING SETTINGS")

func quit_game():
	get_tree().quit()
