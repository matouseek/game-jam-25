extends Node

const PATH_TO_SCENES = "res://scenes/" 
const SCENES := ["minigames/empty.tscn"] ## contains filenames for scenes in sequential order

signal level_completed ## each minigame sends it when done

var current_level : int = 0 ## tracks the current game state

# Called when the node enters the scene tree for the first time.
func _ready():
	level_completed.connect(next_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# changes tracker to next position
func next_level() -> void:
	current_level += 1

# TODO: loads the current scene, fade in/out
func load_level() -> void:
	pass
