extends Node2D

const worshipping_scene = "res://scenes/zeroland_scenes/2worshiping.tscn"

@onready var camera = $Camera2D
@onready var duration = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var offset = -800
	if not GM.ship_back:
		await ride_ship(camera.position,Vector2(camera.position.x+offset,camera.position.y))
		GM.fade_to_scene(worshipping_scene)
	else:
		await ride_ship(Vector2(camera.position.x+offset,camera.position.y),camera.position)
		GM.level_completed.emit()

func ride_ship(start_point,end_point):
	camera.position = start_point
	var tween = get_tree().create_tween()
	tween.tween_property(camera,"position",end_point,duration)
	await tween.finished
