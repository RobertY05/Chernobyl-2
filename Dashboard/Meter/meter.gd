extends Node2D

const _min_degree = -130
const _max_degree = 130
const _true_max_degree = 150
const _shake = 20
const _lerp_speed = 15

var _value = 0
var _true_rotation = _min_degree

@onready var _arrow = $Arrow

func set_meter(value):
	_value = clamp(value, 0, 1)
	_true_rotation = _min_degree + abs(_min_degree - _max_degree) * value
	_true_rotation = clamp(_true_rotation, _min_degree, _max_degree)

func _process(delta):
	var rotation_delta = _shake * _value
	_arrow.rotation_degrees = lerp(_arrow.rotation_degrees, clamp(_true_rotation + randf_range(-rotation_delta, rotation_delta), _min_degree, _true_max_degree), _lerp_speed * delta)
