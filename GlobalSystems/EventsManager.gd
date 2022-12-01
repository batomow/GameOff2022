extends Node 

var _event_bus = []
signal player_died
signal floor_completed(floor_number)
signal room_completed(room_number)
signal rebaking_scene
signal finished_scene_rebake

func subscribe(global_event:String, object_reference:Object, callback:String)->Testable: 
	if not self.has_signal(global_event): 
		var message = "The event manager doesn't have signal %s " % global_event
		printerr(message)
		return Exception.new(message)
	if not self.is_connected(global_event, object_reference, callback): 
		var status = self.connect(global_event, object_reference, callback)
		if status != OK: 
			var message = "Something went wrong connecting signal: %s with %s ".format([global_event, status])
			return Exception.new(message)
	return Success.new()

func emit_global_event(global_event:String, args)->Testable: 
	if not self.has_signal(global_event): 
		var message = "Attempted to emit signal that the event manager doesn't have %s " % global_event
		printerr(message)
		return Exception.new(message)
	emit_signal(global_event, args)
	return Success.new()

func unsubscribe(global_event:String, object_reference:Object, callback:String)->Testable: 
	if not self.has_signal(global_event): 
		var message = "Couldn't unsubscribe since object {0} there is no such event %s ".format([global_event, object_reference.name])
		printerr(message)
		return Exception.new(message)
	if not self.is_connected(global_event, object_reference, callback): 
		var message = "Couldn't unsubscribe since object {0} is not connected to event {0}".format([global_event, object_reference.name])
		printerr(message)
		return Exception.new(message)
	self.disconnect(global_event, object_reference, callback)
	return Success.new()
