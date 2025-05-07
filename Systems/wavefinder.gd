extends Node2D

signal won_game

@onready var _slider_brightness = $SliderBrightness
@onready var _slider_loss = $SliderLoss
@onready var _slider_add = $SliderAdd
@onready var _slider_sub = $SliderSub
@onready var _graph_timer = $GraphTimer
@onready var _oscilliscope = $Oscilliscope

@onready var _noise_sliders = [$SliderAdd, $SliderSub, $SliderLoss, $SliderBrightness]
var _needed = []

var _game_started = false
var _victory = false

const _epsilon = 0.05

func _ready():
	for i in range(3):
		_needed.append(randf())

func _on_graph_timer_timeout():
	var deltas = [0, 0, 0]
	var victory = true
	for i in range(3):
		deltas[i] = abs(_noise_sliders[i].get_value() - _needed[i])
		if deltas[i] <= _epsilon:
			deltas[i] = 0
		else:
			victory = false
	
	_oscilliscope.plot(deltas[0], deltas[1], deltas[2], _slider_brightness.get_value())
	
	if victory and _game_started and !_victory:
		_victory = true
		won_game.emit()

func start_game():
	_game_started = true

func is_won():
	return _victory

func _start_rumbling():
	for i in range(4):
		_noise_sliders[i].start_rumbling()

func _stop_rumbling():
	for i in range(4):
		_noise_sliders[i].stop_rumbling()
