extends Control

const PATH_TO_BUTT_ICONS : String = "res://assets/button_icons/"

enum Layout { BASE, NOT_SOLVABLE, ZERO }

var layouts : Dictionary = { Layout.BASE : range(1,10) , Layout.NOT_SOLVABLE : range(1,11), Layout.ZERO : range(0,10) }

signal digit_pressed(value : int) ## value will be -1 if not solvable

@export var current_layout : Layout

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_butts = layouts.get(current_layout)
	connect_buttons()
	initialize_button_icons()
	enable_buttons(current_butts)
	spread_buttons(current_butts)

# initialize button pictures
func initialize_button_icons():
	for i in $Buttons.get_child_count():
		var butt = $Buttons.get_child(i) as TextureButton
		butt.texture_normal = load(PATH_TO_BUTT_ICONS + "default" + str(i) + ".png")
		butt.texture_hover = load(PATH_TO_BUTT_ICONS + "hover" + str(i) + ".png")
		butt.texture_pressed = load(PATH_TO_BUTT_ICONS + "pressed" + str(i) + ".png")

# connects to the buttons pressed signals
func connect_buttons():
	for i in $Buttons.get_child_count():
		var butt = $Buttons.get_child(i) as TextureButton
		butt.pressed.connect(func() : digit_pressed.emit(i))
		butt.mouse_entered.connect(func() : GM.mouse_entered_button.emit())
		butt.mouse_exited.connect(func() : GM.mouse_exited_button.emit())

# set as visible the buttons to values given in the array
func enable_buttons(to_enable : Array):
	for i in to_enable:
		var button = $Buttons.get_child(i) as TextureButton
		button.visible = true

# spreads the buttons on the screen
func spread_buttons(to_spread : Array):
	const BUTT_OFFSET_RATIO = 3.0 / 4  
	
	var chunk_size : float = get_viewport().size.x / (len(to_spread) + 1)
	var top_offset : float = get_viewport().size.y * BUTT_OFFSET_RATIO
	var current_pos : float = chunk_size
	for i in to_spread:
		var button = $Buttons.get_child(i) as TextureButton
		button.position.x = current_pos - button.size.x / 2
		button.position.y = top_offset
		current_pos += chunk_size
