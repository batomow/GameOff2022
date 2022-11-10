extends Node

onready var _color_rect:ColorRect = $ColorRect
onready var _animation_player:AnimationPlayer = $AnimationPlayer

export (Array, PackedScene) var _available_scenes = []
signal loading_scene(scene_name)
signal loaded_scene(scene_name)
signal failed_to_load_scene(scene_name)

onready var _scenes_map = {
	"Main Menu": _available_scenes[0], 
	"Floor1": _available_scenes[1]
}

func _ready(): 
	_animation_player.play("RESET")

func transition_scene(scene_name:String, state:Dictionary)->void:
	emit_signal("loading_scene", scene_name)
	if scene_name in _scenes_map: 
		_animation_player.play("Fade")
		yield(_animation_player, "animation_finished")
		_transition_to_scene(_scenes_map[scene_name])
		_animation_player.play_backwards("Fade")
		yield(_animation_player, "animation_finished")
		emit_signal("loaded_scene", scene_name)
	else:
		emit_signal("failed_to_load_scene", scene_name)

func _transition_to_scene(scene:PackedScene):
	get_tree().change_scene_to(scene)
