extends Button

signal changed_key()

export var action: String

func _ready():
	set_process_unhandled_key_input(false)

func _toggled(button_pressed) -> void:
	set_process_unhandled_key_input(button_pressed)
	if button_pressed:
		self.modulate.b = 100
		text = "Press a key"
		release_focus()
	else:
		self.modulate.b = 1
		display_current_key()

func _unhandled_key_input(event) -> void:
	remap_action_to(event)
	pressed = false
	emit_signal("changed_key")

func remap_action_to(event) -> void:
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)

	text = "%s Key" % event.as_text()

func display_current_key() -> void:
	var current_key = InputMap.get_action_list(action)[0].as_text()
	text = current_key
