extends Control

const PATH_TO_BUTT_ICONS : String = "res://assets/button_icons/"

const NORMAL_ICON : String = PATH_TO_BUTT_ICONS + "default"
const HOVER_ICON : String = PATH_TO_BUTT_ICONS + "hover"
const PRESSED_ICON : String = PATH_TO_BUTT_ICONS + "pressed"


enum Layout { BASE, NOT_SOLVABLE, ZERO }

var layouts : Dictionary = { Layout.BASE : range(1,10) , Layout.NOT_SOLVABLE : range(1,11), Layout.ZERO : range(0,10) }

signal digit_pressed(value : int) ## value will be -1 if not solvable

@export var current_layout : Layout

@onready var buttons = $Buttons

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_butts = layouts.get(current_layout)
	connect_buttons()
	initialize_button_icons()
	unfocus_buttons()
	enable_buttons(current_butts)
	spread_buttons(current_butts)

func unfocus_buttons():
	for i in buttons.get_child_count():
		var butt = buttons.get_child(i) as TextureButton
		butt.focus_mode = Control.FOCUS_NONE

# initialize button pictures
func initialize_button_icons():
	for i in buttons.get_child_count():
		var butt = buttons.get_child(i) as TextureButton
		butt.texture_normal = load(NORMAL_ICON + str(i) + ".png")
		butt.texture_hover = load(HOVER_ICON + str(i) + ".png")
		butt.texture_pressed = load(PRESSED_ICON + str(i) + ".png")

# connects to the buttons pressed signals
func connect_buttons():
	for i in buttons.get_child_count():
		var butt = buttons.get_child(i) as TextureButton
		butt.pressed.connect(func() : digit_pressed.emit(i))
		butt.mouse_entered.connect(func() : GM.mouse_entered_button.emit())
		butt.mouse_exited.connect(func() : GM.mouse_exited_button.emit())

# set as visible the buttons to values given in the array
func enable_buttons(to_enable : Array):
	for i in to_enable:
		var button = buttons.get_child(i) as TextureButton
		button.visible = true

# spreads the buttons on the screen
func spread_buttons(to_spread : Array):
	const BUTT_OFFSET_RATIO = 3.0 / 4  
	
	#var chunk_size : float = get_viewport().size.x / (len(to_spread) + 1)
	#var top_offset : float = get_viewport().size.y * BUTT_OFFSET_RATIO
	var chunk_size : float = GM.WINDOW_WIDTH / (len(to_spread) + 1)
	var top_offset : float = GM.WINDOW_HEIGHT * BUTT_OFFSET_RATIO
	var current_pos : float = chunk_size
	for i in to_spread:
		var button = buttons.get_child(i) as TextureButton
		button.position.x = current_pos - button.size.x / 2
		button.position.y = top_offset
		current_pos += chunk_size
