extends Node

signal value_changed(value)
signal option_pressed(option)

func _on_value_changed(value) -> void:
	emit_signal("value_changed", value)

func _on_SettingsTabContainer_tab_changed(_tab: int) -> void:
	emit_signal("option_pressed", "tab_changed")
