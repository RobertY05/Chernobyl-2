extends Node2D

var _numbers = []
var _number = 0

func _ready():
	_numbers = get_children()
	_numbers.erase($Shine)
	set_number(0)

func set_number(num):
	for i in range(10):
		if i == num:
			_numbers[i].show()
		else:
			_numbers[i].hide()
	_number = num

func get_number():
	return _number
