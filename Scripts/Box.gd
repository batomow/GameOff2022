extends StaticBody

var player_in := false
onready var box_mesh = $BoxMesh
onready var collision_shape = $CollisionShape
var opened = false
var state = {} 

func _process(delta):
	if Input.is_action_pressed("interact") and player_in and not opened: 
		_open()

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		player_in = true

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		player_in = false

func apply_state(new_state): 
	if new_state.has("opened"): 
		if new_state["opened"]:
			_open()

func _open(): 
	box_mesh.visible = false
	collision_shape.disabled = true
	opened = true
	start_dialog()

func start_dialog():
	var dialog = Dialogic.start("scissors0")
	dialog.pause_mode = PAUSE_MODE_PROCESS
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_parent().add_child(dialog)
	dialog.connect("time_line_end", self, "end_dialog")
	
	
func end_dialog(data):
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
