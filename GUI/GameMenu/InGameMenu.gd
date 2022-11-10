extends VBoxContainer

signal option_pressed(option)


func _option_pressed(option: String):
	emit_signal("option_pressed", option)
