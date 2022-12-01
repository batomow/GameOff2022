extends Node

export (String, "Normal", "Ending") var type = "Normal"

func _on_Dialog_dialogic_signal(value):
	if value == "Cinematic Ended": 
		if type == "Normal": 
			ScenesManager.transition_scene("Room 1", {})
		elif type == "Ending": 
			ScenesManager.transition_scene("Credits", {})


func _on_Button_pressed():
	if type == "Normal": 
		ScenesManager.transition_scene("Room 1", {})
	elif type == "Ending": 
		ScenesManager.transition_scene("Credits", {})
