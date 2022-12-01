extends StaticBody

var player_in := false
onready var box_mesh = $BoxMesh
onready var collision_shape = $CollisionShape
var opened = false
var state = {}
export (String, "Food", "Explosive") var type
signal opened
onready var animation_player = $AnimationPlayer
export (Array, AudioStream) var audio_streams
onready var audio_player = $AudioStreamPlayer

func _process(delta):
	if Input.is_action_pressed("interact") and player_in and not opened: 
		_open()

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		player_in = true

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		player_in = false

func apply_state(new_state): 
	if new_state.has("opened"): 
		if new_state["opened"]:
			_open()

func _open(): 
	if type == "Food": 
		animation_player.play("open_food")
		audio_player.stream = audio_streams[0]
		audio_player.volume_db = 0
	elif type == "Explosive": 
		animation_player.play("open_explosive")
		audio_player.stream = audio_streams[1]
		audio_player.volume_db = -10
	audio_player.play() 
	box_mesh.visible = false
	collision_shape.disabled = true
	opened = true
	emit_signal("opened")
