extends Node2D

signal key_inserted
signal key_removed

var _key_item = null
const _rotational_lerp = 0.1
const _max_rotation = 90.0

@onready var _spinning_key = $Key
@onready var _remove_key_timer = $RemoveKeyTimer

var _desired_rotation = 0.0

func is_key_inserted():
	if _key_item == null:
		return false
	return true

func catch(key_item):
	if _key_item == null:
		_desired_rotation = _max_rotation
		_spinning_key.show()
		
		_key_item = key_item
		_key_item.hide()
		_key_item.set_process(false)
		
		key_inserted.emit()

func _process(delta):
	_spinning_key.rotation_degrees = lerp(_spinning_key.rotation_degrees, clamp(_desired_rotation, 0.0, _max_rotation), _rotational_lerp)
	
	if Input.is_action_just_released("left_click") and _key_item != null:
		_remove_key_timer.stop()
		_desired_rotation = _max_rotation

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click") and _key_item != null:
		_remove_key_timer.start()
		_desired_rotation = 0.0

func _on_remove_key_timer_timeout():
	key_removed.emit()
	
	_key_item.set_process(true)
	_key_item.show()
	_spinning_key.hide()
	_key_item._grabbed = true
	_key_item = null
