extends Node2D

var icons : Array[TextureRect]

const ICON_GREEN : String = "res://assets/icon_green.svg"
const ICON_YELLOW : String = "res://assets/icon_yellow.svg"
const ICON_RED : String = "res://assets/icon_red.svg"

@onready var curves = $Curves

const SHIP_MOVE_TIME = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#$NextButton.pressed.connect(func() : GM.map_completed.emit())
	$NextButton.pressed.connect(move_ship_next)
	%CurrentLevel.text = "current: " + str(GM.current_level)
	prep_icons()
	set_icon_colors()

# casts icons from Nodes to TextureRects
func prep_icons():
	var uncasted := $LevelIcons.get_children()
	for u in uncasted:
		icons.append(u as TextureRect)

func next_travel(index : int, start_ratio : float, end_ratio : float):
	var curve = curves.get_child(index)
	var path_follow = curve.get_node("PathFollow2D") as PathFollow2D
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/icon.svg")
	path_follow.add_child(sprite)
	# chatgpt generated
	path_follow.progress_ratio = start_ratio
	var tween = get_tree().create_tween()
	tween.tween_property(path_follow, "progress_ratio", end_ratio, SHIP_MOVE_TIME)
	await tween.finished

# animate ship moving to the next location
func move_ship_next():
	$NextButton.disabled = true
	if not GM.travelling_back:
		await next_travel(GM.current_level,0.0,1.0)
	else:
		await next_travel(GM.current_level+1,1.0,0.0)
	GM.map_completed.emit()
	
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
