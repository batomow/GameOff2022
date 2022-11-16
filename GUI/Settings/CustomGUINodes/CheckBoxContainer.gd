tool
extends ControlAligner

signal value_changed(value)
signal size_changed(size)

onready var label = $Label

export var title: String = "" setget _set_title

func _set_title(input: String) -> void:
	title = input
	if not label:
		yield(self, "ready")
	label.text = title

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	emit_signal("value_changed", button_pressed)

func _on_Label_resized() -> void:
	emit_signal("size_changed", label.rect_size)

func set_label_rect_min_x(value: float) -> void:
	var size = Vector2(value, label.get_minimum_size().y)
	label.set_custom_minimum_size(size)
