extends GutTest

const PATH = "res://Player/Player.tscn"
var test_camera:Camera
var sender = InputSender.new(Input)

func after_each(): 
	sender.release_all()
	sender.clear()

func get_new_camera(): 
	var new_camera = Camera.new()
	new_camera.transform.basis = Basis(
		Vector3(5.4, 0, 0), 
		Vector3(0, 5.4, 0),
		Vector3(0, 0, 5.4)
	)
	new_camera.transform.basis = new_camera.transform.basis.rotated(Vector3(0, 1, 0), rad2deg(45))
	new_camera.transform.basis = new_camera.transform.basis.rotated(Vector3(1, 0, 0), rad2deg(-45))
	return new_camera

func test_can_instance(): 
	assert_file_exists(PATH)
	if is_failing(): return
	var file = load(PATH)
	var player = partial_double(file).instance()
	assert_not_null(player)

func test_accesors(): 
	test_camera = add_child_autoqfree(get_new_camera())
	var file = load(PATH)
	var player = partial_double(file).instance()
	assert_not_null(player)
	if is_failing(): return
	assert_accessors(player, "camera", null, test_camera)
	assert_accessors(player, "move_speed", 4, 10)

func test_player_moves_forward(): 
	test_camera = add_child_autoqfree(get_new_camera())
	#get a normalized vertor that points to "forward" relative to the camera. 
	var zbasis = -test_camera.transform.basis.z
	zbasis.y = 0
	var forward = zbasis.normalized()
	#isntance the rest of the scene. 
	var file = load(PATH)
	var player = partial_double(file).instance() 
	add_child_autofree(player)
	player.set_camera(test_camera)
	assert_call_count(player, "set_camera", 1)
	assert_not_null(player.current_camera)
	if is_failing(): return
	#simulation
	var FRAMES = 10
	var delta = get_physics_process_delta_time()
	var low_value = player.move_speed * forward * delta * FRAMES * 2
	var high_value = player.move_speed * forward * delta * FRAMES * 0.25
	sender.action_down("forward").wait_frames(FRAMES)
	yield(sender, 'idle')
	gut.p(player.transform.origin)
	assert_between(player.transform.origin.z, low_value.z, high_value.z)
	assert_between(player.transform.origin.x, low_value.x, high_value.x)

func test_player_moves_backwards(): 
	test_camera = add_child_autoqfree(get_new_camera())
	#get a normalized vertor that points to "forward" relative to the camera. 
	var zbasis = test_camera.transform.basis.z
	zbasis.y = 0
	var forward = zbasis.normalized()
	#isntance the rest of the scene. 
	var file = load(PATH)
	var player = partial_double(file).instance() 
	add_child_autofree(player)
	player.set_camera(test_camera)
	assert_call_count(player, "set_camera", 1)
	assert_not_null(player.current_camera)
	if is_failing(): return
	#simulation
	var FRAMES = 10
	var delta = get_physics_process_delta_time()
	var high_value = player.move_speed * forward * delta * FRAMES * 2
	var low_value = player.move_speed * forward * delta * FRAMES * 0.25
	sender.action_down("back").wait_frames(FRAMES)
	yield(sender, 'idle')
	gut.p(player.transform.origin)
	assert_between(player.transform.origin.z, low_value.z, high_value.z)
	assert_between(player.transform.origin.x, low_value.x, high_value.x)

func test_player_moves_right(): 
	test_camera = add_child_autoqfree(get_new_camera())
	#get a normalized vertor that points to "forward" relative to the camera. 
	var zbasis = test_camera.transform.basis.x
	zbasis.y = 0
	var forward = zbasis.normalized()
	#isntance the rest of the scene. 
	var file = load(PATH)
	var player = partial_double(file).instance() 
	add_child_autofree(player)
	player.set_camera(test_camera)
	assert_call_count(player, "set_camera", 1)
	assert_not_null(player.current_camera)
	if is_failing(): return
	#simulation
	var FRAMES = 10
	var delta = get_physics_process_delta_time()
	var high_value = player.move_speed * forward * delta * FRAMES * 2
	var low_value = player.move_speed * forward * delta * FRAMES * 0.25
	sender.action_down("right").wait_frames(FRAMES)
	yield(sender, 'idle')
	gut.p(player.transform.origin)
	assert_between(player.transform.origin.z, low_value.z, high_value.z)
	assert_between(player.transform.origin.x, high_value.x, low_value.x)

func test_player_moves_left(): 
	test_camera = add_child_autoqfree(get_new_camera())
	#get a normalized vertor that points to "forward" relative to the camera. 
	var zbasis = -test_camera.transform.basis.x
	zbasis.y = 0
	var forward = zbasis.normalized()
	#isntance the rest of the scene. 
	var file = load(PATH)
	var player = partial_double(file).instance() 
	add_child_autofree(player)
	player.set_camera(test_camera)
	assert_call_count(player, "set_camera", 1)
	assert_not_null(player.current_camera)
	if is_failing(): return
	#simulation
	var FRAMES = 10
	var delta = get_physics_process_delta_time()
	var low_value = player.move_speed * forward * delta * FRAMES * 2
	var high_value = player.move_speed * forward * delta * FRAMES * 0.25
	sender.action_down("left").wait_frames(FRAMES)
	yield(sender, 'idle')
	gut.p(player.transform.origin)
	assert_between(player.transform.origin.z, low_value.z, high_value.z)
	assert_between(player.transform.origin.x, high_value.x, low_value.x)

