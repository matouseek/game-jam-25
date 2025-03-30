extends Node2D

const worshipping_scene = "res://scenes/zeroland_scenes/2worshiping.tscn"

@onready var camera = $Camera2D
@export var ride_duration : float = 1
@export var ship_ride_lenght : float = -800

# Called when the node enters the scene tree for the first time.
func _ready():
	if not GM.ship_back:
		await ride_ship(camera.position,Vector2(camera.position.x+ship_ride_lenght,camera.position.y))
		GM.fade_to_scene(worshipping_scene)
	else:
		await ride_ship(Vector2(camera.position.x+ship_ride_lenght,camera.position.y),camera.position)
		GM.level_completed.emit()

func ride_ship(start_point,end_point):
	camera.position = start_point
	var tween = get_tree().create_tween()
	tween.tween_property(camera,"position",end_point,ride_duration)
	await tween.finished
