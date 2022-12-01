extends KinematicBody

export (NodePath) var assigned_box_path
export (NodePath) var navigation_mesh_instance_path
export (NodePath) var cover_position_path
onready var cover_position = get_node_or_null(cover_position_path)
onready var navigation_mesh_instance = get_node_or_null(navigation_mesh_instance_path)
onready var assigned_box = get_node_or_null(assigned_box_path)
export (String) var scene_name
var busy = false
onready var navigation_agent = $NavigationAgent
enum STATES {IDLE, MOVING, DYING}
var current_state = STATES.IDLE
var speed = 2
onready var sprite_3d = $Sprite3D

func _ready():
	if assigned_box != null: 
		if not assigned_box.is_connected("opened", self, "_on_box_opened"):
			assigned_box.connect("opened", self, "_on_box_opened")
	EventsManager.subscribe("rebaking_scene", self, "_on_scene_rebake")
	if navigation_mesh_instance != null: 
		if not navigation_mesh_instance.is_connected("bake_finished", self, "_on_finished_scene_rebake"):
			navigation_mesh_instance.connect("bake_finished", self, "_on_finished_scene_rebake")

func _physics_process(delta):
	match current_state: 
		STATES.IDLE: idle(delta)
		STATES.MOVING: moving(delta)
		STATES.DYING: dying(delta)
		_ : pass

func _on_Area_body_entered(body):
	if body.name == "Player": 
		EventsManager.emit_global_event("player_died", scene_name)

func _on_box_opened(): 
	if navigation_mesh_instance != null and not busy: 
		EventsManager.emit_global_event("rebaking_scene", {})
		navigation_mesh_instance.bake_navigation_mesh(false)

func _on_scene_rebake(args): 
	busy = true

func _on_finished_scene_rebake():
	busy = false
	if assigned_box.opened: 
		current_state = STATES.MOVING
func idle(delta): 
	sprite_3d.stop()

func moving(delta): 
	if assigned_box.type == "Food": 
		navigation_agent.set_target_location(assigned_box.transform.origin)
	elif assigned_box.type == "Explosive": 
		navigation_agent.set_target_location(cover_position.transform.origin)
	var next_location = navigation_agent.get_next_location()
	var velocity = (next_location - transform.origin).normalized() * speed
	if next_location.distance_to(transform.origin) > 1:
		move_and_collide(velocity * delta)
		if not sprite_3d.is_playing():
			sprite_3d.play("moving")
	else: 
		current_state = STATES.IDLE

func dying(delta): 
	pass
