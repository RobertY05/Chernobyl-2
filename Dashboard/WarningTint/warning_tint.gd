extends Node2D

var _is_flashing = false

const _warning_alpha = 0.1
const _flash_alpha = 0.25
var _desired_alpha = 0.0

const _color_lerp_speed = 0.15

@onready var _tint = $Tint
@onready var _wait_timer = $WaitTimer
@onready var _flash_timer = $FlashTimer

func _process(delta):
	_tint.modulate.a = lerp(_tint.modulate.a, _desired_alpha, _color_lerp_speed)

func start_flashing():
	if _is_flashing:
		return
	_wait_timer.start()
	_desired_alpha = _warning_alpha
	_is_flashing = true

func stop_flashing():
	if !_is_flashing:
		return
	_flash_timer.stop()
	_wait_timer.stop()
	_desired_alpha = 0.0
	_is_flashing = false

func _on_wait_timer_timeout():
	_desired_alpha = _flash_alpha
	_flash_timer.start()

func _on_flash_timer_timeout():
	_desired_alpha = _warning_alpha
