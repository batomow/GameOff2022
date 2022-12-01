extends KinematicBody

export (Array, AudioStream) var audio_streams
export (NodePath) var _current_camera_path
onready var audio_player = $AudioStreamPlayer3D
var current_camera:Camera setget set_camera, get_camera
var move_speed: float = 4 setget set_move_speed, get_move_speed
var velocity:Vector3 
var foot_step_counter = 0
onready var animated_sprite = $AnimatedSprite3D

func set_camera(camera:Camera): 
	current_camera = camera
	if camera != null:
		set_physics_process(true)

func get_camera(): 
	return current_camera

func set_move_speed(speed:float): 
	move_speed = speed

func get_move_speed(): 
	return move_speed

func _ready(): 
	current_camera = get_node_or_null(_current_camera_path)
	if current_camera == null: 
		printerr("Missing camera for player")
		set_physics_process(false)

func _physics_process(delta):
	var input_z:int = int(Input.is_action_pressed("back")) - int(Input.is_action_pressed("forward"))
	var input_x:int = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	var xbasis:Vector3 = current_camera.global_transform.basis.x * input_x
	var zbasis:Vector3 = current_camera.global_transform.basis.z * input_z
	#remove the Y since camera is rotated downwards
	xbasis = xbasis.normalized()
	zbasis.y = 0
	zbasis = zbasis.normalized() 
	var direction = xbasis + zbasis
	direction = direction.normalized() 
	var velocity = direction * move_speed * delta
	if (input_z != 0 or input_x != 0) and not audio_player.playing:
		audio_player.stream = audio_streams[foot_step_counter]
		audio_player.play()
	if input_z > 0: 
		if input_x > 0: 
			animated_sprite.flip_h = false
		else: 
			animated_sprite.flip_h = true
		animated_sprite.play("moving_forward")
	elif input_z < 0: 
		if input_x > 0: 
			animated_sprite.flip_h = false
		else: 
			animated_sprite.flip_h = true
		animated_sprite.play("moving_back")
	if input_z == 0 and input_x == 0: 
		animated_sprite.stop()
	move_and_collide(velocity)

func pause(): 
	set_process(false) 
	set_physics_process(false)
 
func unpause(): 
	set_process(true) 
	set_physics_process(true)
