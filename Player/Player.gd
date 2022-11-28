extends KinematicBody


export (NodePath) var _current_camera_path
var current_camera:Camera setget set_camera, get_camera
var move_speed: float = 4 setget set_move_speed, get_move_speed
var velocity:Vector3 

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
	move_and_collide(direction * move_speed * delta)

func pause(): 
	set_process(false) 
	set_physics_process(false)
 
func unpause(): 
	set_process(true) 
	set_physics_process(true)
