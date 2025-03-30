extends Node2D

var icons : Array[TextureRect]

const ICON_GREEN : String = "res://assets/icon_green.svg"
const ICON_YELLOW : String = "res://assets/icon_yellow.svg"
const ICON_RED : String = "res://assets/icon_red.svg"

@onready var curves = $Curves

var ship_icon = "res://assets/map/ship_small.png"
const SHIP_ICON_SCALE = 0.5
const SHIP_MOVE_TIME = 2.0
const SHIP_BOTTOM_OFFSET = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	print(GM.current_level)
	if GM.current_level == 0:
		ship_icon = "res://assets/map/stickman.png"
	
	if not GM.travelling_back:
		await add_ship_to_path(GM.current_level,0.0,1.0)
	else:
		await add_ship_to_path(GM.current_level,1.0,0.0)
	#$NextButton.pressed.connect(func() : GM.map_completed.emit())
	$NextButton.pressed.connect(move_ship_next)

# adds ship to path to be visible right at the start of the scene
func add_ship_to_path(index : int, start_ratio : float, end_ratio : float):
	var curve = curves.get_child(index)
	var path_follow = curve.get_node("PathFollow2D") as PathFollow2D
	path_follow.rotates = false
	path_follow.rotation = 0
	var sprite = Sprite2D.new()
	sprite.texture = load(ship_icon)
	sprite.apply_scale(Vector2(SHIP_ICON_SCALE,SHIP_ICON_SCALE))
	sprite.position.y -= SHIP_BOTTOM_OFFSET
	if GM.travelling_back:
		sprite.flip_h = true
	path_follow.add_child(sprite)
	path_follow.progress_ratio = start_ratio

# start moving the ship to the next point
func tween_path_follow(index : int, start_ratio : float, end_ratio : float):
	var curve = curves.get_child(index)
	var path_follow = curve.get_node("PathFollow2D") as PathFollow2D
	var tween = get_tree().create_tween()
	tween.tween_property(path_follow, "progress_ratio", end_ratio, SHIP_MOVE_TIME)
	await tween.finished

# animate ship moving to the next location
func move_ship_next():
	$NextButton.disabled = true
	if not GM.travelling_back:
		await tween_path_follow(GM.current_level,0.0,1.0)
	else:
		await tween_path_follow(GM.current_level,1.0,0.0)
	GM.map_completed.emit()
