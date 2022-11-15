extends Node

signal value_changed(value)

onready var button_container = preload("res://GUI/Settings/CustomGUINodes/RebindButtonContainer.tscn")
var SettingsConfig

func _ready() -> void:
	var config = load("res://Resources/SettingsConfig.gd")
	SettingsConfig = config.new()

func set_up(settings: Dictionary):
	for action in settings.keymap:
			var temp = button_container.instance()
			temp.connect("size_changed", $ControlsVBoxContainer, "childs_size_changed")
			temp.connect("changed_key",  $ControlsVBoxContainer, "changed_key")
			temp.add_to_group("alignable")
			$ControlsVBoxContainer.add_child(temp)
			temp.setup(action)

func changed_key():
	var keymap: Dictionary = SettingsConfig.get_keymap()
	emit_signal("value_changed", keymap)
	print("KEY CHANGED")
