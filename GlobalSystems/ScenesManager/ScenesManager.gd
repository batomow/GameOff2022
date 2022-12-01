extends Node

onready var _color_rect:ColorRect = $ColorRect
onready var _animation_player:AnimationPlayer = $AnimationPlayer

export (Array, PackedScene) var _available_scenes = []
signal loading_scene(scene_name)
signal loaded_scene(scene_name)
signal failed_to_load_scene(scene_name)

var _current_state = {} setget set_state, get_state

func get_state(): 
	return _current_state

func set_state(new_state:Dictionary):
	_current_state = new_state

onready var _scenes_map = {
	"Main Menu": _available_scenes[0], 
	"Room 1": _available_scenes[1],
	"Room 2": _available_scenes[2],
	"Room 3": _available_scenes[3],
	"Settings": _available_scenes[4], 
	"Cinematic": _available_scenes[5], 
	"Credits": _available_scenes[6], 
	"Cinematic2": _available_scenes[7]
}

func _ready(): 
	_animation_player.play("RESET")

func transition_scene(scene_name:String, state:Dictionary)->void:
	set_state(state)
	emit_signal("loading_scene", scene_name, state)
	if scene_name in _scenes_map: 
		_animation_player.play("Fade")
		yield(_animation_player, "animation_finished")
		_transition_to_scene(_scenes_map[scene_name])
		_animation_player.play_backwards("Fade")
		yield(_animation_player, "animation_finished")
		emit_signal("loaded_scene", scene_name, state)
	else:
		emit_signal("failed_to_load_scene", scene_name, state)

func _transition_to_scene(scene:PackedScene):
	get_tree().change_scene_to(scene)
