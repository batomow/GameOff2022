extends Node

onready var player = $"%Player"
onready var return_position = $ReturnPosition
onready var start_position = $StartPosition
onready var boxes = $NavigationMeshInstance/Boxes.get_children()
onready var load_screen = $LoadScreen

func _ready(): 
	EventsManager.subscribe('player_died', self, "_on_player_died")
	if not ScenesManager.is_connected("loaded_scene", self, "_on_loaded_scene"): 
		ScenesManager.connect("loaded_scene", self, "_on_loaded_scene")
	player.pause()
	load_screen.fade()

func _on_loaded_scene(scene_name, state): 
	if state.has("%s player position"%name):
		player.transform.origin = state["%s player position"%name]
	for box in boxes: 
		if state.has( "%{0} box-{1}".format([name, box.name]) ):
			box.apply_state(state["%{0} box-{1}".format([name, box.name]) ])
	yield(get_tree().create_timer(1), "timeout")
	player.unpause()
	load_screen.fade()

func _on_EnterPortal_player_entered(scene_name):
	var current_state = ScenesManager.get_state()
	current_state["%s player position"%name] = start_position.transform.origin
	for box in boxes: 
		current_state["%{0} box-{1}".format([name, box.name]) ] = {
			"opened": box.opened
		}
	player.pause()
	ScenesManager.transition_scene(scene_name, current_state)


func _on_ExitPortal_player_entered(scene_name):
	var current_state = ScenesManager.get_state()
	current_state["%s player position"%name] = return_position.transform.origin
	for box in boxes: 
		current_state["%{0} box-{1}".format([name, box.name]) ] = {
			"opened": box.opened
		}
	player.pause()
	ScenesManager.transition_scene(scene_name, current_state)

func _on_player_died(scene_name)->void: 
	ScenesManager.transition_scene(scene_name, {})
