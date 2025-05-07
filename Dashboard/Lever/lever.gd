extends Node2D

const _min_height = -50
const _max_height = 50

const _rising_acceleration = -200
const _initial_velocity = -0
const _max_pressure = 100
const _reset_threshold = 0.05

var _value = 0
var _selected = false
var _velocity = 0
var _combined_y_position = _min_height
var _pressure_per_cooldown = -5
var _pressure_per_unit = 5
var _pressure = 0
var _jammed = false

@onready var _bicolour = $LeverMask/Bicolour
@onready var _lever_handle = $LeverHandle
@onready var _pump_audio = $PumpAudio
@onready var _jam_audio = $JamAudio

const _max_pump_volume = 10.0
const _quiet = -80.0
var _desired_pump_volume = _quiet

signal lever_grabbed
signal lever_released

func _process(delta):
	if _selected:
		_pump_audio.volume_db = max(_pump_audio.volume_db, -10)
		_desired_pump_volume = _max_pump_volume
	else:
		_desired_pump_volume = _quiet
	
	_pump_audio.volume_db = lerp(_pump_audio.volume_db, _desired_pump_volume, 1 - pow(0.7, delta))
	_pump_audio.volume_db = min(_pump_audio.volume_db, _max_pump_volume)
	
	if Input.is_action_just_released("left_click"):
		if _selected:
			lever_released.emit()
		_selected = false
		_velocity = _initial_velocity
	
	if _value < _reset_threshold:
		_jammed = false
	
	if _selected:
		_velocity = 0
		if not _jammed:
			var new_position = clamp(to_local(get_viewport().get_mouse_position()).y, _combined_y_position, _max_height)
			_pressure += min(abs(new_position - _combined_y_position) * _pressure_per_unit, _max_pressure)
			_combined_y_position = new_position
			if _pressure >= _max_pressure:
				if !_jammed:
					_jam_audio.play()
				_jammed = true
	else:
		_velocity += _rising_acceleration * delta
		_combined_y_position = clamp(_combined_y_position + _velocity * delta, _min_height, _max_height)
	
	_bicolour.position.y = _combined_y_position
	_lever_handle.position.y = _combined_y_position
	
	_value = abs(_min_height - _combined_y_position) / abs(_min_height - _max_height)

func _on_pressure_cooldown_timeout():
	_pressure = max(0, _pressure + _pressure_per_cooldown)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		_selected = true
		lever_grabbed.emit()

func get_value():
	return _value

func get_pressure():
	return _pressure / _max_pressure
