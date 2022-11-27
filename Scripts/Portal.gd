extends Spatial

enum PORTALTYPES {EXIT, RETURN, UNASIGNED}
export (PORTALTYPES) var type = PORTALTYPES.UNASIGNED
export (String) var return_scene 
export (String) var exit_scene

signal player_entered (scene_name)


func _on_Area_body_entered(body):
	if body.is_in_group("player"): 
		match type: 
			PORTALTYPES.EXIT: 
				emit_signal("player_entered", exit_scene)
			PORTALTYPES.RETURN: 
				emit_signal("player_entered", return_scene)
			_ : 
				printerr("Un assigned portal!")
