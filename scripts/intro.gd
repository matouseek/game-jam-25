extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	MM.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property($Camera2D, "position", Vector2(0,0), 1).set_trans(Tween.TRANS_CUBIC)
	
	await tween.finished
	
	tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Camera2D, "zoom", Vector2(4, 4), 12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Camera2D, "position", Vector2(0,1500), 12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	await get_tree().create_timer(3.5).timeout
	
	GM.fade_to_scene("res://scenes/minigames/0math_formulas.tscn")
	
