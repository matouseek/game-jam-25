extends Node2D

var icons : Array[TextureRect]

@onready var icon_green : Image = Image.load_from_file("res://assets/icon_green.svg")
@onready var icon_yellow : Image = Image.load_from_file("res://assets/icon_yellow.svg")
@onready var icon_red : Image = Image.load_from_file("res://assets/icon_red.svg")

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

# switches icon colors based on current level
func set_icon_colors():
	for i in range(len(icons)):
		if i < GM.current_level:
			icons[i].texture = ImageTexture.create_from_image(icon_green)
		elif i == GM.current_level:
			icons[i].texture = ImageTexture.create_from_image(icon_yellow)
		elif i > GM.current_level:
			icons[i].texture = ImageTexture.create_from_image(icon_red)
