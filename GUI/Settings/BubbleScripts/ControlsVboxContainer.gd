extends ControlAligner

signal changed_key

func changed_key():
	emit_signal("changed_key")

func childs_size_changed(new_value):
	_childs_size_changed(new_value)
