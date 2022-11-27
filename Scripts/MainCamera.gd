extends Camera

onready var player:KinematicBody = $"%Player"

onready var original_offset = global_transform.origin
onready var max_distance_from_player:float = original_offset.length() * 1.5

onready var raycasts := $Raycasts.get_children()

const max_offset:float = 0.5

var bounce_count = 0
const max_bounce_count = 50
var slerp_back = false

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
	var collision_normal = Vector3.ZERO
	for raycast in raycasts: 
		if raycast.is_colliding(): 
			collided = true
			collision_normal = -raycast.cast_to.normalized()
			break
	
	#turn it into a concrete direction to avoid in relative space
	var cast_dir_xoffset = xbasis.dot(collision_normal)
	var cast_dir_zoffset = zbasis.dot(collision_normal)
	#cancel out the displacement in that particular direction
	var correction_vector = Vector3.ZERO
	correction_vector += xbasis * cast_dir_xoffset
	correction_vector += zbasis * cast_dir_zoffset
	var correction_normal = correction_vector.normalized()
	if collided and transform.origin.distance_to(player.transform.origin) < max_distance_from_player: 
		displacement = displacement.slide(correction_normal)
	#look into occluders, instead of trying to avoid teh camera hitting walls, just make the walls transparent. 
	
	self.global_translate(displacement*delta)
