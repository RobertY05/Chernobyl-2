extends Node2D

@onready var _light = $Light
@onready var _dark = $Dark

func set_light(val):
	if val:
		_light.show()
		_dark.hide()
	else:
		_light.hide()
		_dark.show()
