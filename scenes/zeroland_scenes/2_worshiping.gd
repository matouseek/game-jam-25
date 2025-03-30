extends Node2D

const docking_scene = "res://scenes/zeroland_scenes/1docking.tscn"
@export var scene_duration = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	GM.ship_back = true
	var timer = get_tree().create_timer(scene_duration)
	await timer.timeout
	GM.fade_to_scene(docking_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
