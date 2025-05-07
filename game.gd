extends Node2D

@onready var _timer = $Timer
@onready var _textbox = $Textbox

@onready var _tint = $Tint
@onready var _failure_timer = $FailureTimer
@onready var _failure_audio = $FailureAudio
@onready var _background_audio = $BackgroundAudio

var _story = [
	"PRESS ANY KEY TO START",
	0,
	["Hello friend", 3],
	["Welcome to nuclear reactor", 3],
	["Cooling system broken, pull big lever on right to cool", 5],
	["Pull down very slowly, keep it at bottom for maximum coolant", 10],
	["Look at meter on the left, top is temperature", 10],
	["Middle is pressure, do not pull lever too fast or it will get stuck", 10],
	["Make sure temperature does not reach critical", 15],
	["Okay, very good job", 3],
	"We will run diagnostic, press correct sequence of colour buttons",
	1,
	["Like child games", 3],
	["Next test, not for children", 5],
	["Use slider underneath Oscilliscope to determine waveform", 10],
	"Graph will be perfect sine wave, no movement. Like this: '∿∿∿'",
	2,
	["Did not lie on resume!", 3],
	["Final diagnostic, you can resume shift after", 3],
	["There is key inside slot near oscilliscope, do not remove it yet", 5],
	["If you remove it, meters lose power", 5],
	["When I am ready, I will activate light board, then you put key into other slot to count", 7.5],
	["...", 3],
	"Okay, put key in other slot, count the lights and enter that many in the counter, quickly please",
	3,
	["Great", 3],
	["I will leave you to your job now, goodbye friend", 5],
	["...", 3],
	["YOU WIN", 5],
	["A game by Robert", 3],
	["Special thanks to Soph for art", 3],
	["Royalty free sounds from pixabay.com", 3],
	"THANK YOU FOR PLAYING"
]

var _idx = 0
var _ready_to_start = false
var _tint_fading = false
const _fade_speed = 10

func _ready():
	_timer.start(1.5)

func _process(delta):
	if Input.is_anything_pressed() and _ready_to_start:
		$Temperature.make_harder(0.5)
		_next_line()
		_ready_to_start = false
	
	if _tint_fading:
		_tint.modulate.a = max(0, _tint.modulate.a - _fade_speed * delta)

func _next_line():
	var play_next = false
	_textbox.show()
	
	if _idx == _story.size():
		return
	
	if typeof(_story[_idx]) == TYPE_INT:
		if _story[_idx] == 0:
			_ready_to_start = true
		elif _story[_idx] == 1:
			$Temperature.make_harder(0.5)
			$SimonSays.start_game()
		elif _story[_idx] == 2:
			$Temperature.make_harder(0.3)
			$Wavefinder.start_game()
		elif _story[_idx] == 3:
			$Temperature.make_harder(0.5)
			$LightCount.start_game()
	elif typeof(_story[_idx]) == TYPE_STRING:
		_textbox.set_text(_story[_idx])
		play_next = true
	else:
		_textbox.set_text(_story[_idx][0])
		_timer.start(_story[_idx][1])
	_idx += 1
	
	if play_next:
		_timer.start(0.01)

func _on_temperature_game_over():
	_timer.stop()
	_idx = 0
	_failure_timer.start()
	_tint.modulate.a = 1
	_failure_audio.play()
	_background_audio.stop()
	_textbox.hide()
	_tint_fading = false

func _on_failure_timer_timeout():
	_background_audio.play()
	_tint_fading = true
	_timer.start(1.5)
