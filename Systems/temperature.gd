extends Node2D

const _max_temperature = 100
const _warning_threshold = 0.8

var _temperature = 0.0
var _temperature_per_heating = 0
var _temperature_per_cooling = 3.5
var _meters_enabled = true

var _max_pump_volume = 10.0
var _desired_pump_volume = -80.0

@onready var _temperature_meter = $TemperatureMeter
@onready var _pressure_meter = $PressureMeter
@onready var _flow_meter = $FlowMeter
@onready var _lever = $Lever
@onready var _warning_tint = $WarningTint
@onready var _warning_audio = $WarningAudio

signal lever_grabbed
signal lever_released

signal game_over

func make_harder(val):
	_temperature_per_heating += val

func _ready():
	$Keyhole.catch($Key)

func _process(delta):
	if _meters_enabled:
		_flow_meter.set_meter(_lever.get_value())
		_pressure_meter.set_meter(_lever.get_pressure())
		_temperature_meter.set_meter(_temperature / _max_temperature)
	else:
		_flow_meter.set_meter(0)
		_pressure_meter.set_meter(0)
		_temperature_meter.set_meter(0)
	if _temperature / _max_temperature >= _warning_threshold:
		_warning_tint.start_flashing()
		if !_warning_audio.playing:
			_warning_audio.play()
	else:
		_warning_tint.stop_flashing()
		_warning_audio.stop()

func _on_temperature_timer_timeout():
	_temperature = clamp(_temperature + _temperature_per_heating - _temperature_per_cooling * _lever.get_value(), 0, _max_temperature)
	if _temperature == _max_temperature:
		game_over.emit()
		_temperature = 0
		_temperature_per_heating = 0

func _on_keyhole_key_inserted():
	_meters_enabled = true

func _on_keyhole_key_removed():
	_meters_enabled = false

func _on_lever_lever_grabbed():
	lever_grabbed.emit()

func _on_lever_lever_released():
	lever_released.emit()
