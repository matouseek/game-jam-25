extends CanvasLayer

func appear():
	visible = true
	GM.visible = false

func disappear():
	visible = false
	get_tree().paused = false


func _on_play_pressed() -> void: disappear()


func _on_menu_pressed() -> void:
	visible = false
	GM.menu_toggle()
