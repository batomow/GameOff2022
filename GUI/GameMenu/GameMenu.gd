extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PopupMenu/CenterContainer/ButtonContainer/SaveGameButton.grab_focus()


func open_setting() -> void:
	print("open settings")

func load_game() -> void:
	print("load game")
	
func save_game() -> void:
	print("save game")

func close_game() -> void:
	print("close game")
	get_tree().change_scene("res://GUI/MainMenu/MainMenu.tscn")
	
func quite_game() -> void:
	print("quite game")
	get_tree().quit()
	
func hide_menu() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game") :
		$PopupMenu.visible = !$PopupMenu.visible
	
