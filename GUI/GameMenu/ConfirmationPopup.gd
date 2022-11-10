extends Popup

signal option_pressed(option)

func _ready() -> void:
	$InGameMenu/SaveGameButton.grab_focus()


func _on_InGameMenu_option_pressed(option) -> void:
	emit_signal("option_pressed", option)

