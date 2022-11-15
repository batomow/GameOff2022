extends ControlAligner

signal changed_key

func changed_key():
	emit_signal("changed_key")
