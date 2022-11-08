extends Reference

class_name Testable

var error:bool = false
var message:String = ""
var value = null
var extras = {}

func _init(e, m, v).(): 
	error = e
	message = m
	value = v

func add_extra_info(key, value):
	extras[key] = value

func _to_string(): 
	return ("{\n\terror: {0},\n\tmessage: {1},\n\tvalue: {2},\n\textras: {3}\n}").format([error, message, value, extras])
