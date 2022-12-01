extends Node

signal option_pressed(option)
signal option_focused

func _option_pressed(option: String):
	emit_signal("option_pressed", option)

func _on_StartButton_mouse_entered():
	emit_signal("option_focused")

func _on_LoadButton_mouse_entered():
	emit_signal("option_focused")

func _on_ContinueButton_mouse_entered():
	emit_signal("option_focused")

func _on_SettingsButton_mouse_entered():
	emit_signal("option_focused")

func _on_QuitButton_mouse_entered():
	emit_signal("option_focused")
