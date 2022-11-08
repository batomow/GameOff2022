extends Node

const SAVE_DIR = "user://saves/"

#TODO add extra security by using bytes in the middle of this.
func save_game(state:Dictionary, file_name:String)->Testable: 
	#check if directory exists, if not, create a new directory. 
	var dir = Directory.new() 
	if not dir.dir_exists(SAVE_DIR): 
		dir.make_dir(SAVE_DIR)
	var path = SAVE_DIR + file_name + ".dat"
	var file = File.new()
	#prepare data
	var data = state.duplicate()
	data["updated_at"] = OS.get_system_time_msecs()
	data["file_name"] = file_name
	var res = null
	if not file.file_exists(path):
		data["created_at"] = OS.get_system_time_msecs()
		res = file.open(path, File.WRITE_READ)
	else: 
		res = file.open(path, File.READ_WRITE)
	if res != OK: 
		var message = "Cant open file %s "%file_name
		printerr(message)
		file.close()
		return Exception.new(message)
	#make sure that only parsable variables are passed. 
	for value in state: 
		if (
			not value is int && 
			not value is float && 
			not value is String && 
			not value is Array && 
			not value is Dictionary
		): 
			var message = "Can only save int, float, String, Array or Dictionary, not custom or buildint types."
			printerr(message)
			file.close()
			var new_exception = Exception.new(message, value)
			new_exception.add_extra_info({
				"encountered": value, 
				"typeof": typeof(value)
			})
			return new_exception

	var json = JSON.print(data, "\t")
	if validate_json(json): #returns empty string if valid, weird, I know. 
		var message = "Invalid json for file: %s"%file_name
		printerr(message)
		file.close()
		return Exception.new(message)
	file.store_string(json)
	file.close()
	return Success.new()

func load_game(file_name:String)->Testable: 
	var path = SAVE_DIR + file_name+".dat"
	var file = File.new() 
	if not file.file_exists(path): 
		var message = "No file called: %s"%file_name
		printerr(message)
		return Exception.new(message)
	var res = file.open(path, File.READ)
	if res != OK: 
		var message = "Error opening file: %s" %file_name
		printerr(message)
		return Exception.new(message)
	var text = file.get_as_text()
	var json_result = JSON.parse(text)
	if json_result.error != OK:
		var message = "Can't parse file: %s"%file_name
		printerr(message)
		return Exception.new(message)
	return Success.new(json_result.result)

func get_all_save_file_names()->Testable: 
	return Success.new(PoolStringArray())

func get_last_save()->Testable: 
	return Success.new({})

func create_new_save()->Testable: 
	return Success.new({})

