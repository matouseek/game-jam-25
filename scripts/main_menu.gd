extends CanvasLayer

func _on_play_pressed() -> void:
	GM.is_playing = true
	MM.visible = false
	get_tree().paused = false


func _on_menu_pressed() -> void:
	GM.menu_toggle()
