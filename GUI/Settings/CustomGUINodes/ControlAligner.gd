extends Node
class_name ControlAligner

var _biggest_childs_size = Vector2.ZERO

#Aligns control elements to all have the minimum size of the
#largest in their group. Makes next GUI elements left/right align cleanly.
func childs_size_changed(new_value):
	if new_value.x > _biggest_childs_size.x:
		_biggest_childs_size = new_value
		for i in get_children():
			if i.is_in_group("alignable"):
				i.set_label_rect_min_x(_biggest_childs_size.x )
