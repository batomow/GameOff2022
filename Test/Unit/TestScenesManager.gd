extends GutTest

var SCENE_PATH = "res://GlobalSystems/ScenesManager/ScenesManager.tscn"
var SCRIPT_PATH = "res://GlobalSystems/ScenesManager/ScenesManager.gd"
const DUMMY_STATE = {
	"file_name": "dummy", 
	"created_at": 0000000000, 
	"updated_at": 0000000001, 
	"my_variables": [1, 2, 3, 4]
}

func before_all(): 
	assert_file_exists(SCRIPT_PATH)
	assert_file_not_empty(SCRIPT_PATH)

func test_is_right_type(): 
	var file = load(SCENE_PATH)
	var double_scene = partial_double(file).instance()
	assert_is(double_scene, Node)

func test_can_transition_scene(): 
	var file = load(SCENE_PATH)
	var double_scene = partial_double(file).instance() 
	assert_not_null(double_scene)
	watch_signals(double_scene)
	if is_failing(): 
		return
	assert_has_method(double_scene, "_transition_to_scene")
	if is_failing(): 
		return
	stub(double_scene, "_transition_to_scene")
	add_child_autoqfree(double_scene)
	assert_has_method(double_scene, "transition_scene")
	assert_has_signal(double_scene, "loading_scene")
	assert_has_signal(double_scene, "loaded_scene")
	if is_failing(): 
		return
	double_scene.transition_scene("Main Menu", DUMMY_STATE)
	yield(yield_to(double_scene, "completed", 5), YIELD)
	assert_called(double_scene, "_transition_to_scene")
	assert_signal_emitted_with_parameters(double_scene, "loaded_scene", ["Main Menu"])
	assert_signal_emitted_with_parameters(double_scene, "loading_scene", ["Main Menu"])

func test_invalid_scene_input(): 
	var file = load(SCENE_PATH)
	var double_scene = partial_double(file).instance() 
	assert_not_null(double_scene)
	watch_signals(double_scene)
	if is_failing(): return
	assert_has_method(double_scene, "_transition_to_scene")
	stub(double_scene, "_transition_to_scene")
	add_child_autoqfree(double_scene)
	assert_has_method(double_scene, "transition_scene")
	if is_failing(): return 
	double_scene.transition_scene("Invalid Scene", DUMMY_STATE)
	yield(yield_to(double_scene, "completed", 5), YIELD)
	assert_not_called(double_scene, "_transition_to_scene")
	assert_signal_emitted_with_parameters(double_scene, "loading_scene", ["Invalid Scene"])
	assert_signal_emitted_with_parameters(double_scene, "failed_to_load_scene", ["Invalid Scene"])
