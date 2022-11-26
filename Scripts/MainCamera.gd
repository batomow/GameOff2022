extends Camera

onready var player:KinematicBody = $"%Player"
onready var debug_mesh:MeshInstance = $"%DebugMesh"

onready var original_offset = global_transform.origin

onready var raycasts := get_children()

const max_offset = 1.0

func _physics_process(delta):
	#where the center of the screen would fall on the floor. 
	var projected_position = transform.origin - original_offset
	#left/right and front/back relative to camera
	var xbasis:Vector3 = global_transform.basis.x
	var zbasis:Vector3 = global_transform.basis.z
	xbasis = xbasis.normalized()
	zbasis.y = 0 #remove the Y since camera is rotated downwards
	zbasis = zbasis.normalized() 
	
	#get how far along the relative left/right and front/back the center of the camera is. 
	var projected_position_xoffset = xbasis.dot(projected_position)
	var projected_position_zoffset = zbasis.dot(projected_position)
	
	#get how much the player is alogn these relative axis. 
	var horizontal_distance = xbasis.dot(player.transform.origin) - projected_position_xoffset
	var vertical_distance = zbasis.dot(player.transform.origin) - projected_position_zoffset
	
	#calculate the distance the camera needs to move to correct its position. 
	var displacement := Vector3.ZERO
	
	if abs(horizontal_distance) > max_offset: 
		displacement += xbasis * horizontal_distance
	if abs(vertical_distance) > max_offset: 
		displacement += zbasis * vertical_distance
	
	#check for collisions for the camera by getting an average direction to avoid
	var collided = false
	var agregate_direction = Vector3.ZERO
	for raycast in raycasts: 
		if raycast.is_colliding(): 
			collided = true
			agregate_direction -= raycast.cast_to
	
	#turn it into a concrete direction to avoid in relative space
	var projected_cast_dir = agregate_direction.normalized()
	projected_cast_dir.y = 0 
	var cast_dir_xoffset = xbasis.dot(projected_cast_dir)
	var cast_dir_zoffset = zbasis.dot(projected_cast_dir)
	#cancel out the displacement in that particular direction
	var correction_vector = Vector3(
		cast_dir_xoffset * displacement.x, 
		0, 
		cast_dir_zoffset * displacement.z
	)
	
	#move the camera. 
	if collided: 
		self.global_translate(correction_vector*delta)
	else:
		self.global_translate(displacement*delta)
