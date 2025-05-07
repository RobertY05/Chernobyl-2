extends Node2D

signal button_pressed
signal button_released

@export var _colour = Color.WHITE

@onready var _coloured_button = $Button
@onready var _coloured_button_pressed = $ButtonPressed

var _pressed = false

func _ready():
	$Button/ColouredButton.modulate = _colour
	$ButtonPressed/ColouredButton.modulate = _colour

func _process(delta):
	if Input.is_action_just_released("left_click"):
		_pressed = false
		_coloured_button_pressed.hide()
		if _pressed:
			button_released.emit()

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		_pressed = true
		_coloured_button_pressed.show()
		button_pressed.emit()
