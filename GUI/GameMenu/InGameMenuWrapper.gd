extends Control

export var audio_stream: AudioStream

onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

onready var confirmation_popup: Popup = get_node("ConfirmationPopup")

func open_popup() -> void:
	audio_stream_player.play()
	yield(audio_stream_player, "finished")
	confirmation_popup.popup()

func _on_ConfirmationPopup_option_pressed(option) -> void:
	match option:
		"Save":
			save_game()
		"Close":
			close_popup()
		"Settings":
			open_setting()
		"Return": 
			return_to_main_menu()
		"Quit":
			quite_game()

func open_setting() -> void:
	audio_stream_player.play()
	yield(audio_stream_player, "finished")
	ScenesManager.transition_scene("Settings", {})

func save_game() -> void:
	audio_stream_player.play()
	yield(audio_stream_player, "finished")
	print("save game")

func close_popup()->void: 
	audio_stream_player.play()
	yield(audio_stream_player, "finished")
	confirmation_popup.visible = false

func return_to_main_menu():
	audio_stream_player.play()
	yield(audio_stream_player, "finished")
	print("close game")
	ScenesManager.transition_scene("Main Menu", {})
	
func quite_game() -> void:
	audio_stream_player.play()
	yield(audio_stream_player, "finished")
	print("quite game")
	get_tree().quit()


