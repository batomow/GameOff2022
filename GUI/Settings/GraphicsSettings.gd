extends ControlAligner

signal value_changed(value)
	
func set_up(settings: Dictionary):
	$Resolution/CheckButton.select(-1)
	$Fullscreen/CheckBox.pressed = settings.fullscreen
	$Vsync/CheckBox.pressed = settings.vsync
	$Brightness/HScrollBar.value = settings.brightness

func _on_graphics_value_changed(value, option: String) -> void:
	var temp = {}
	temp[option] = value
	emit_signal("value_changed", temp)

func childs_size_changed(new_value):
	_childs_size_changed(new_value)
