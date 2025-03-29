extends Node2D

var icons : Array[TextureRect]

const ICON_GREEN : String = "res://assets/icon_green.svg"
const ICON_YELLOW : String = "res://assets/icon_yellow.svg"
const ICON_RED : String = "res://assets/icon_red.svg"

# Called when the node enters the scene tree for the first time.
func _ready():
	$NextButton.pressed.connect(func() : GM.map_completed.emit())
	%CurrentLevel.text = "current: " + str(GM.current_level)
	prep_icons()
	set_icon_colors()

# casts icons from Nodes to TextureRects
func prep_icons():
	var uncasted := $LevelIcons.get_children()
	for u in uncasted:
		icons.append(u as TextureRect)

func set_icon_colors_forwards():
	for i in range(len(icons)):
		if i < GM.current_level:
			icons[i].texture = load(ICON_GREEN)
		elif i == GM.current_level:
			icons[i].texture = load(ICON_YELLOW)
		elif i > GM.current_level:
			icons[i].texture = load(ICON_RED)	

func set_icon_colors_backwards():
	for i in range(len(icons)):
		if i > GM.current_level:
			icons[i].texture = load(ICON_GREEN)
		elif i == GM.current_level:
			icons[i].texture = load(ICON_YELLOW)
		elif i < GM.current_level:
			icons[i].texture = load(ICON_RED)

# switches icon colors based on current level
func set_icon_colors():
	if GM.travelling_back:
		set_icon_colors_backwards()
	else:
		set_icon_colors_forwards()
