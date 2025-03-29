extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_play_pressed() -> void: GM.fade_to_scene(GM.MATH_FORMULAS_SCENE)

func _on_audio_pressed() -> void:
	GM.menu_toggle()
