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
			close_game()
		"Settings":
			open_setting()
		"Quit":
			quite_game()

func open_setting() -> void:
	audio_stream_player.play()
	yield(audio_stream_player, "finished")
	print("open settings")

func save_game() -> void:
	audio_stream_player.play()
	yield(audio_stream_player, "finished")
	print("save game")

func close_game():
	audio_stream_player.play()
	yield(audio_stream_player, "finished")
	print("close game")
	get_tree().change_scene("res://GUI/MainMenu/MainMenu.tscn")
	
func quite_game() -> void:
	audio_stream_player.play()
	yield(audio_stream_player, "finished")
	print("quite game")
	get_tree().quit()


