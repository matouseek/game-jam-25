extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GM.current_level = -1



func _on_play_pressed() -> void: GM.fade_to_scene("res://scenes/minigames/0math_formulas.tscn")




func _on_audio_pressed() -> void:
	visible = false
	GM.menu_toggle(true)
