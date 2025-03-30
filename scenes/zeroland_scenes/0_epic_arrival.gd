extends Node2D

const docking_scene = "res://scenes/zeroland_scenes/1docking.tscn"

@onready var camera = $Camera2D
@export var scene_duration : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(scene_duration).timeout
	GM.fade_to_scene(docking_scene)
