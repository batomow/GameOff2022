extends VBoxContainer

signal option_pressed(option)


func _option_pressed(option: String):
	print(option)
	emit_signal("option_pressed", option)
