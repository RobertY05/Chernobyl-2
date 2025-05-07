extends Node2D

signal won_game

@onready var _counter_tens = $CounterTens
@onready var _counter_ones = $CounterOnes
@onready var _button_tens = $ButtonTens
@onready var _button_onese = $ButtonOnes
@onready var _light_grid = $LightGrid
@onready var _keyhole = $Keyhole

var _victory = false
var _game_started = false

func start_game():
	_game_started = true
	_light_grid.generate()
	if _keyhole.is_key_inserted():
		_light_grid.show_lights()

func is_won():
	return _victory

func _on_keyhole_key_inserted():
	_light_grid.show_lights()

func _on_keyhole_key_removed():
	_light_grid.hide_lights()

func _on_button_tens_button_pressed():
	if _counter_tens.get_number() >= 9:
		_counter_tens.set_number(0)
	else:
		_counter_tens.set_number(_counter_tens.get_number() + 1)

func _on_button_ones_button_pressed():
	if _counter_ones.get_number() >= 9:
		_counter_ones.set_number(0)
	else:
		_counter_ones.set_number(_counter_ones.get_number() + 1)
	
func _on_button_submit_button_pressed():
	var value = _counter_tens.get_number() * 10 + _counter_ones.get_number()
	_counter_tens.set_number(0)
	_counter_ones.set_number(0)
	if value == _light_grid.get_count() and _game_started:
		_victory = true
		won_game.emit()
	else:
		_light_grid.generate()
		if _keyhole.is_key_inserted():
			_light_grid.show_lights()
