extends Node2D

@onready var _label = $Label
@onready var _shake_timer = $ShakeTimer
@onready var _intercom_audio = $IntercomAudio

var _old_position = 0
var _shaking = false

const _shake = 20

func _ready():
	_old_position = _label.global_position

func set_text(message):
	_label.text = message
	_shake_timer.start()
	_shaking = true
	_intercom_audio.play()

func _process(delta):
	if _shaking:
		_label.global_position += Vector2(randf_range(-_shake, _shake), randf_range(-_shake, _shake))
	_label.global_position.x = lerp(_label.global_position.x, _old_position.x, 0.9)
	_label.global_position.y = lerp(_label.global_position.y, _old_position.y, 0.9)

func _on_shake_timer_timeout():
	_shaking = false
