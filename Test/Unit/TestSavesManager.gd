extends GutTest

const DIR_PATH = "user://saves/"
const FILE_PATH = "res://GlobalSystems/SavesManager.gd"
const DUMMY_FILE_NAME = "dummy_save"
const MOCK_SAVE_FILE = "mock_save_file"

func before_all(): 
	assert_file_exists(FILE_PATH)
	assert_file_not_empty(FILE_PATH)

func before_each():
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
	if is_failing(): return
	var res = script.save_game(test_data, DUMMY_FILE_NAME)
	assert_is(res, Testable) 
	if is_failing(): return
	assert_eq(res.error, false)
	if is_failing():
		gut.p("------------")
		gut.p(res)
		return
	assert_file_exists(DIR_PATH+DUMMY_FILE_NAME+".dat")
	assert_file_not_empty(DIR_PATH+DUMMY_FILE_NAME+".dat")

func test_load_game(): 
	var file = load(FILE_PATH)
	var script = autofree(file.new())
	assert_has_method(script, "load_game")
	if is_failing(): return
	var res = script.load_game(MOCK_SAVE_FILE)
	assert_is(res, Testable)
	if is_failing(): return
	assert_eq(res.error, false)
	if is_failing(): 
		gut.p("------------")
		gut.p(res)
		return
	assert_has(res.value, "updated_at")
	assert_has(res.value, "created_at")
	assert_has(res.value, "file_name")

func test_get_all_save_file_names(): 
	var file = load(FILE_PATH) 
	var script = partial_double(file).new()
	assert_has_method(script, "get_all_save_file_names")
	assert_has_method(script, "load_game")
	if is_failing(): return
	var res = script.get_all_save_file_names()
	assert_is(res, Testable)
	if is_failing(): return
	assert_eq(res.error, false)
	if is_failing(): 
		gut.p("------------")
		gut.p(res)
		return
	assert_gt(res.value.size(), 0)

func test_get_last_save(): 
	var file = load(FILE_PATH) 
	var partial_script = partial_double(file).new()
	
	stub(partial_script, "get_all_save_file_names").to_return(Success.new([
		DUMMY_FILE_NAME, 
		DUMMY_FILE_NAME+"2"
	]))
	
	stub(partial_script, 'load_game').to_return(Success.new({
		"file_name": DUMMY_FILE_NAME, 
		"created_at": 0000000000, 
		"updated_at": 0000000001
	})).when_passed(DUMMY_FILE_NAME)
	
	stub(partial_script, 'load_game').to_return(Success.new({
		'file_name': DUMMY_FILE_NAME + "2", 
		"created_at": 00000000002, 
		"updated_at": 00000000003
	})).when_passed(DUMMY_FILE_NAME+"2")
	
	assert_has_method(partial_script, "get_last_save")
	if is_failing(): return
	var res = partial_script.get_last_save()
	assert_called(partial_script, "load_game", [DUMMY_FILE_NAME])
	assert_called(partial_script, "load_game", [DUMMY_FILE_NAME+"2"])
	assert_is(res, Testable)
	if is_failing(): return
	assert_eq(res.error, false)
	if is_failing(): 
		gut.p("------------")
		gut.p(res)
		return
	assert_eq(res.value.file_name, DUMMY_FILE_NAME+"2")
