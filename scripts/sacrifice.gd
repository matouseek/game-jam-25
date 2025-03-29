extends Node2D

var people : Array = []
const SACRIFICE_TIME : float = 1.0
const DIALOG_TIME : float = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	people = $People.get_children()
	spread_people()
	$Hud.digit_pressed.connect(sacrifice)
	var tween = get_tree().create_tween()
	tween.tween_property($Natives, "modulate:a", 1, DIALOG_TIME)
	await  tween.finished
	tween = get_tree().create_tween()
	tween.tween_property($Ship, "modulate:a", 1, DIALOG_TIME)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spread_people():
	#var chunk_size : float = get_viewport().size.x / (len(people) + 1)
	var chunk_size : float = GM.WINDOW_WIDTH / (len(people) + 1)
	var current_pos : float = chunk_size
	var TOP_OFFSET = 1/4.0
	var y =  get_viewport().size.y * TOP_OFFSET 
	for p in people:
		var sprite = p as Sprite2D
		sprite.position.x = current_pos
		current_pos += chunk_size
		sprite.position.y = y

func sacrifice(to_sacrifice : int):
	var tween
	for i in range(to_sacrifice):
		tween = get_tree().create_tween()
		var sprite = people[i] as Sprite2D
		tween.tween_property(sprite, "position", Vector2(sprite.position.x, 500), SACRIFICE_TIME)
		tween.parallel().tween_property(sprite, "modulate", Color.RED, SACRIFICE_TIME)
		tween.parallel().tween_property(sprite, "scale", Vector2(), SACRIFICE_TIME)
		
	await tween.finished
	GM.level_completed.emit()
		
