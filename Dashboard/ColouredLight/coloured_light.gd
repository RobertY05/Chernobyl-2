extends Node2D

@export var _colour = Color.WHITE
@onready var _light_on = $LightOn
@onready var _shadow = $Shadow
@onready var _timer = $Timer

func _ready():
	$LightOff.modulate = _colour
	_light_on.modulate = _colour

func flash(time):
	_timer.start(time)
	_light_on.show()
	_shadow.hide()

func _on_timer_timeout():
	_light_on.hide()
	_shadow.show()
