extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.button_down.connect(func() : GM.level_completed.emit())
	$Hud.digit_pressed.connect(print_button)
	pass # Replace with function body.

func print_button(digit_pressed : int):
	print(digit_pressed)
	
