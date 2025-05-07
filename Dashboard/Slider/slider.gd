extends Node2D

const _min_height = -30
const _max_height = 30

const _min_shake = -2
const _max_shake = 3

var _selected = false
var _combined_y_position = _max_height

@onready var _bicolour = $SliderMask/Bicolour
@onready var _lever_handle = $SliderHandle
@onready var _rumble_timer = $RumbleTimer

func _process(delta):
	if Input.is_action_just_released("left_click"):
		_selected = false
	
	if _selected:
		var new_position = clamp(to_local(get_viewport().get_mouse_position()).y, _min_height, _max_height)
		_combined_y_position = new_position
	
	_bicolour.position.y = _combined_y_position
	_lever_handle.position.y = _combined_y_position

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		_selected = true

func get_value():
	return 1 - abs(_min_height - _combined_y_position) / abs(_min_height - _max_height)

func start_rumbling():
	_rumble_timer.start()

func stop_rumbling():
	_rumble_timer.stop()

func _on_rumble_timer_timeout():
	_combined_y_position += randf_range(_min_shake, _max_shake)
	_combined_y_position = clamp(_combined_y_position, _min_height, _max_height)
	_bicolour.position.y = _combined_y_position
	_lever_handle.position.y = _combined_y_position
