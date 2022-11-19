extends GutTest

var FILE_PATH = "res://GlobalSystems/EventsManager.gd"


func test_can_instance(): 
	assert_file_exists(FILE_PATH)
	assert_file_not_empty(FILE_PATH)

func _test_01(): 
	pass

func test_invalid_event_subscription(): 
	var file = load(FILE_PATH)
	var script = partial_double(file).new()
	assert_not_null(script)
	if is_failing():
		return 
	assert_has_method(script, "subscribe")
	if is_failing(): 
		return 
	var res = script.subscribe("invalid_event", self, "_test_01")
	assert_is(res, Testable)
	if is_failing(): 
		return
	assert_eq(res.error, true)

func _test_02(arg): 
	assert_eq(arg, true)

func test_can_subscribe_emit_and_unsubscribe(): 
	var file = load(FILE_PATH) 
	var script = partial_double(file).new()
	assert_not_null(script)
	if is_failing(): 
		return 
	assert_has_method(script, "subscribe")
	assert_has_method(script, "unsubscribe")
	assert_has_signal(script, "player_died")
	if is_failing(): 
		return 
	var res = script.subscribe("player_died", self, "_test_02")
	assert_is(res, Testable)
	if is_failing(): 
		return 
	assert_eq(res.error, false)
	if is_failing(): 
		return 
	assert_connected(script, self, "player_died", "_test_02")
	if is_failing(): 
		return 
	var res3 = script.emit_global_event("player_died", true)
	assert_is(res3, Testable)
	if is_failing(): 
		return 
	assert_eq(res3.error, false)
	if is_failing(): #this also works because there is an assertion inside the _test_02 that gets called before this line of code. 
		return
	var res2 = script.unsubscribe("player_died", self, "_test_02")
	assert_is(res2, Testable)
	if is_failing(): 
		return 
	assert_eq(res2.error, false)
	if is_failing(): 
		return 

func _test_03(arg): 
	pass

func test_invalid_unsubscribe(): 
	var file = load(FILE_PATH)
	var script = partial_double(file).new() 
	assert_not_null(script) 
	if is_failing(): 
		return 
	assert_has_method(script, "unsubscribe")
	if is_failing():
		return 
	var res = script.unsubscribe("invalid_event", self, "_test_03")
	assert_is(res, Testable)
	if is_failing(): 
		return 
	assert_eq(res.error, true)

func test_invalid_emit_global_event(): 
	var file = load(FILE_PATH)
	var script = partial_double(file).new() 
	assert_not_null(script)
	if is_failing(): 
		return 
	assert_has_method(script, "emit_global_event")
	if is_failing(): 
		return 
	var res = script.emit_global_event("invalid_event")
	assert_is(res, Testable)
	if is_failing(): 
		return 
	assert_eq(res.error, true)
	if is_failing(): 
		return 

func _test_04(arg): 
	assert_eq(arg, true)
