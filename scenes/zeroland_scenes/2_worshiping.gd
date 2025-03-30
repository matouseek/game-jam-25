extends Node2D

@export var scene_duration = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	GM.ship_back = true
	var timer = get_tree().create_timer(scene_duration)
	await timer.timeout
	GM.fade_to_scene(GM.ZEROLAND_SCENE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
