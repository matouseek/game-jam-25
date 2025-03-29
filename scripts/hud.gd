extends Control

enum Layout { BASE, NOT_SOLVABLE, ZERO }

var layouts : Dictionary = { Layout.BASE : range(1,10) , Layout.NOT_SOLVABLE : range(1,11), Layout.ZERO : range(0,10) }

signal digit_pressed(value : int) ## value will be -1 if not solvable

@export var current_layout : Layout

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_butts = layouts.get(current_layout)
	connect_buttons()
	enable_buttons(current_butts)
	spread_buttons(current_butts)

# connects to the buttons pressed signals
func connect_buttons():
	for i in $Buttons.get_child_count():
		var butt = $Buttons.get_child(i) as Button
		butt.pressed.connect(func() : digit_pressed.emit(i))

# set as visible the buttons to values given in the array
func enable_buttons(to_enable : Array):
	for i in to_enable:
		var button = $Buttons.get_child(i) as Button
		button.visible = true

# spreads
func spread_buttons(to_spread : Array):
	var chunk_size : float = get_viewport().size.x / (len(to_spread) + 1)
	var current_pos : float = chunk_size
	for i in to_spread:
		var button = $Buttons.get_child(i) as Button
		button.position.x = current_pos
		current_pos += chunk_size
