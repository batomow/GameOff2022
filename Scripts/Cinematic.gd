extends Node



func _on_Dialog_dialogic_signal(value):
	if value == "Cinematic Ended": 
		ScenesManager.transition_scene("Room 1", {})


func _on_Button_pressed():
	ScenesManager.transition_scene("Room 1", {})
