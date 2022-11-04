extends GutTest

const FILE_PATH = "res://GlobalSystems/SavesManager.gd"
const DUMMY_FILE_NAME = "dummy_save"



func before_all(): 
	assert_file_exists(FILE_PATH)
	assert_file_not_empty(FILE_PATH)

func test_correct_type():
	var file = load(FILE_PATH)
	var script = autofree(file.new())
	assert_is(script, Node)

func test_save_game(): 
	var file = load(FILE_PATH)
	var script = autofree(file.new())
	var test_data = {
		"my_array_of_ints": [1, 2, 3, 4, 5], 
		"my_float": 10.0, 
		"my_object": {
			"key": "some_key", 
			"value": 20
		}
	}
	assert_has_method(script, "save_game")
	if is_passing(): 
		script.save_game(test_data, DUMMY_FILE_NAME)
	assert_file_exists("res://Saves"+DUMMY_FILE_NAME)
	assert_file_not_empty("res://Saves"+DUMMY_FILE_NAME)

func test_load_game(): 
	var file = load(FILE_PATH)
	var script = autofree(file.new())
	assert_has_method(script, "load_game")
	if is_failing(): 
		return
	var res = script.load_game(DUMMY_FILE_NAME)
	assert_typeof(res, TYPE_DICTIONARY)
	if is_failing(): 
		return
	assert_has(res, "updated_at")
	assert_has(res, "created_at")
	assert_has(res, "file_name")

func test_get_all_save_file_names(): 
	var file = load(FILE_PATH) 
	var script = autofree(file.new())
	assert_has_method(script, "get_all_save_file_names")
	if is_failing(): 
		return
	var res = script.get_all_save_file_names()
	assert_typeof(res, TYPE_STRING_ARRAY)
	if is_failing(): 
		return 
	assert_gt(res.size(), 0)

func test_get_last_save(): 
	var file = load(FILE_PATH) 
	var partial_script = partial_double(file).new()
	
	stub(partial_script, 'load_game').to_return({
		"file_name": DUMMY_FILE_NAME, 
		"created_at": 0000000000, 
		"updated_at": 0000000001
	}).when_passed(DUMMY_FILE_NAME)
	
	stub(partial_script, 'load_game').to_return({
		'file_name': DUMMY_FILE_NAME + "2", 
		"created_at": 00000000002, 
		"updated_at": 00000000003
	}).when_passed(DUMMY_FILE_NAME+"2")
	
	assert_has_method(partial_script, "get_last_save")
	if is_failing(): 
		return
	var res = partial_script.get_last_save()
	assert_called(partial_script, "load_game")
	assert_typeof(res, TYPE_DICTIONARY)
	if is_failing(): 
		return
	assert_has(res, "file_name")
	assert_eq(res["file_name"], DUMMY_FILE_NAME+"2")

func test_create_new_save(): 
	var file = load(FILE_PATH)
	var partial_script = partial_double(file).new()
	assert_has_method(partial_script, "create_new_save")
	if is_failing(): 
		return 
	partial_script.create_new_save()
	assert_called(partial_script, "save_game", "untitled")
	assert_file_exists("res://untitled")
