extends CanvasLayer

onready var animation_player = $AnimationPlayer
var faded = false

func fade(): 
	if animation_player.is_playing(): 
		return
	if not faded: 
		animation_player.play("Fade")
	else: 
		animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	faded = !faded
