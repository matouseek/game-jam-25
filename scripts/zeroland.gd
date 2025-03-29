extends Node2D
const SLIDE_TIMES : Array = [1,2] # first number - how long the 0th image is there
const TRANSITIONS_POSITIONS : Array = [Vector2(392,84),Vector2(536,84)] # centers of the comics images
const TRANSITION_TIME : float = 0.5 # how long each transition takes

# Called when the node enters the scene tree for the first time.
func _ready():
	start_transitions()

func start_transitions():
	for i in range(len(SLIDE_TIMES)):
		var t = SLIDE_TIMES[i]
		var p = TRANSITIONS_POSITIONS[i]
		var timer = get_tree().create_timer(t)
		await timer.timeout
		var tween = get_tree().create_tween()
		tween.tween_property($Camera,"position", p, TRANSITION_TIME)
		await tween.finished
	GM.level_completed.emit()
