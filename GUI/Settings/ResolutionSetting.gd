extends Control

signal value_changed(value)

onready var check_button = $CheckButton

var resolution_list

func _ready() -> void:
	_setup_resolution_list()
	
func _setup_resolution_list():
	var config = load("res://Resources/SettingsConfig.gd")
	var SettingsConfig = config.new()
	resolution_list = SettingsConfig.resolution_list
	
	for i in resolution_list:
		check_button.add_item(i)

func _on_resolution_value_changed(value: int) -> void:
	emit_signal("value_changed", _parse_string(value))

func _parse_string(index: int) -> Vector2:
	var values = resolution_list[index].split_floats("x")
	return Vector2(values[0], values[1]);
