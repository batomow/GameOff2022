extends HBoxContainer

signal changed_key()
signal size_changed(size)

onready var label = $Label
onready var button = $RebindButton

func setup(action_descriptor:String) -> void:
	button.action = action_descriptor
	button.display_current_key()
	label.text = action_descriptor

func _changed_key() -> void:
	emit_signal("changed_key")

func _on_Label_resized() -> void:
	emit_signal("size_changed", label.rect_size)

func set_label_rect_min_x(value: float) -> void:
	var size = Vector2(value, label.get_minimum_size().y)
	label.set_custom_minimum_size(size)
