extends Node

const PATH_TO_SCENES := "res://scenes/minigames/" 
const SCENES := ["0math_formulas.tscn","1sacrifice.tscn","2shooting_balls.tscn"] ## contains filenames for scenes in sequential order

const MAP_SCENE_PATH := "res://scenes/map.tscn"

signal level_completed ## each minigame emits it when done
signal map_completed ## emits by map when player chose next minigame

var current_level : int = 0 ## tracks the current game state

# Called when the node enters the scene tree for the first time.
func _ready():
	level_completed.connect(switch_to_map)
	map_completed.connect(load_level)

# loads map scene and increases the current level count
func switch_to_map():
	current_level += 1
	get_tree().change_scene_to_file(MAP_SCENE_PATH)

# TODO: fade in/out
func load_level() -> void:
	get_tree().change_scene_to_file(PATH_TO_SCENES + SCENES[current_level])
