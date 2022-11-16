extends VBoxContainer

signal value_changed(value)
signal option_pressed(option)

func _ready():
	$Spacer.rect_min_size.y = $Apply.rect_size.y

func _on_value_changed(value) -> void:
	emit_signal("value_changed", value)

func _option_pressed(option: String):
	emit_signal("option_pressed", option)
