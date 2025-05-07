extends Node2D

signal won_game

@onready var _lights = [$LightRed, $LightGreen, $LightBlue]
@onready var _button_green = $ButtonGreen
@onready var _button_blue = $ButtonBlue
@onready var _button_red = $ButtonRed

@onready var _timer = $Timer

const _game_length = 5
const _min_delay = 1
const _max_delay = 5

const _min_flash = 0.1
const _max_flash = 1

var _sequence = []
var _flash_idx = 0
var _player_idx = 0

var _flashing = false
var _victory = false

func _choose(number):
	if !_flashing:
		if _sequence.is_empty() or _victory:
			_lights[number].flash(_min_flash)
		elif number == _sequence[_player_idx]:
			_player_idx += 1
			_lights[number].flash(_min_flash)
			if _player_idx == _sequence.size():
				_win_round()
		else:
			_player_idx = 0
			_flash_idx = 0
			_flashing = true
			_timer.start(1)
			#FAILURE -> FLASH AGAIN

func _win_round():
	if _sequence.size() == _game_length:
		_victory = true
		won_game.emit()
	else:
		_player_idx = 0
		_flash_idx = 0
		_sequence.append(randi_range(0, 2))
		_timer.start(1)

func _on_button_red_button_pressed():
	_choose(0)

func _on_button_green_button_pressed():
	_choose(1)

func _on_button_blue_button_pressed():
	_choose(2)

func _on_timer_timeout():
	if _flash_idx == _sequence.size():
		_flashing = false
	else:
		_lights[_sequence[_flash_idx]].flash(randf_range(_min_flash, _max_flash))
		_flash_idx += 1
		_timer.start()

func start_game():
	_win_round()

func is_won():
	return _victory
