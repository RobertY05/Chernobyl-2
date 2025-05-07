extends Node2D

var _lights = []
var _remember = []
var _count = 0

func _ready():
	for row in get_children():
		_lights.append([])
		_remember.append([])
		for light in row.get_children():
			_remember[-1].append(false)
			_lights[-1].append(light)

func generate():
	_count = 0
	for i in range(_lights.size()):
		for j in range(_lights[0].size()):
			if randi_range(0, 1) == 0:
				_remember[i][j] = true
				_count += 1
			else:
				_remember[i][j] = false

func show_lights():
	for i in range(_lights.size()):
		for j in range(_lights[0].size()):
			if _remember[i][j]:
				_lights[i][j].set_light(true)
			else:
				_lights[i][j].set_light(false)

func hide_lights():
	for i in range(_lights.size()):
		for j in range(_lights[0].size()):
			_lights[i][j].set_light(false)

func get_count():
	return _count
