extends Node2D
const SLIDE_TIMES : Array = [1,2]
const TRANSITIONS_POSITIONS : Array = [Vector2(396,84),Vector2(542,84)]
const TRANSITION_TIME : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(SLIDE_TIMES)):
		var t = SLIDE_TIMES[i]
		var p = TRANSITIONS_POSITIONS[i]
		var timer = get_tree().create_timer(t)
		await timer.timeout
		var tween = get_tree().create_tween()
		tween.tween_property($Camera,"position", p, TRANSITION_TIME)
