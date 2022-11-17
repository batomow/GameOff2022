extends Spatial


var player_infront = false
var door_state = false
onready var animation_player: AnimationPlayer = $AnimationPlayer

func _input(event):
	if Input.is_action_just_pressed("interact"):
		if player_infront  and !animation_player.is_playing():
			
			door_state = !door_state
			if door_state:
				animation_player.play("OpenDoor")
			else:
				animation_player.play("CloseDoor")
				



func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		player_infront = true
		$Label.show()


func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		player_infront = false
		$Label.hide()
