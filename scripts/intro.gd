extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Camera2D, "position", Vector2(0,0), 5).set_trans(Tween.TRANS_CUBIC)
	
