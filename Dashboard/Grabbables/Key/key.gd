extends "res://Dashboard/Grabbables/grabbable_base.gd"

const _spin_speed = 0.1

var _keyholes = []

func _process(delta):
	
	_keyholes.sort_custom(_dist_sort)

	var _desired_angle = 0
	
	if _grabbed and !_keyholes.is_empty():
		rotation = lerp_angle(rotation, rotation + get_angle_to(_keyholes[0].global_position) + deg_to_rad(-90), _spin_speed)
		if Input.is_action_just_released("left_click"):
			_keyholes[0].catch(self)
	
	super._process(delta)
	
func _dist_sort(a, b):
	var d1 = global_position.distance_to(a.global_position)
	var d2 = global_position.distance_to(b.global_position)
	return d1 <= d2

func _on_area_2d_area_entered(area):
	_keyholes.append(area)
	
func _on_area_2d_area_exited(area):
	_keyholes.erase(area)
