extends Node2D

const resolution = 200
@onready var _line = $Line2D

@onready var left = $Left.position.x
@onready var right = $Right.position.x
@onready var top = $Top.position.y
@onready var bottom = $Bottom.position.y

const _default_stretch = 0.1
const _default_amplitude = 45
const _additive_noise = 50
const _multiplicative_noise = 50

func _graph(x, add, sub, loss):
	var add_noise = randf_range(0, _additive_noise) * add
	var sub_noise = randf_range(-_additive_noise, 0) * sub
	if randf() <= loss:
		return randf_range(top, bottom)
	else:
		return sin(x * _default_stretch) * _default_amplitude + add_noise + sub_noise
	
func plot(add, sub, anti, bright):
	_line.default_color.a = bright
	_line.clear_points()
	var step = abs(right - left) / resolution
	for i in range(resolution):
		var new_x = left + i * step
		var new_y = _graph(new_x, add, sub, anti) + (left + right) / 2
		new_y = clamp(new_y, top, bottom)
		_line.add_point((Vector2(new_x, new_y)))
	
