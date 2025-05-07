extends Node2D

var _velocity = Vector2.ZERO
const _gravity = 5000

const _border_left = 140
const _border_right = 1020

const _min_height = 600
const _table_height = 500
var _drop_stop = _min_height

var _grabbed = false
var _offset = Vector2.ZERO

var _drop_id = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("left_click"):
		if _grabbed:
			if _min_height >= global_position.y and global_position.y >= _table_height:
				_drop_stop = global_position.y 
		_grabbed = false
	
	if _grabbed:
		_velocity = Vector2.ZERO
		global_position = get_viewport().get_mouse_position() + _offset
	else:
		_offset = Vector2.ZERO
		_velocity.y += _gravity * delta
		global_position += _velocity * delta
		global_position.y = min(position.y, _drop_stop)
		
	global_position.x = clamp(position.x, _border_left, _border_right)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		_grabbed = true
		_offset = global_position - get_viewport().get_mouse_position()
		_velocity = Vector2.ZERO
		
