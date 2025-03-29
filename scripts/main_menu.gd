extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GM.current_level = -1



func _on_play_pressed() -> void: GM.switch_to_map()




func _on_audio_pressed() -> void:
	GM.menu_toggle()
