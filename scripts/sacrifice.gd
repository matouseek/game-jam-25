extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spread_people()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spread_people():
	var people = $People.get_children()
	for p in people: print(p)
	var chunk_size : float = get_viewport().size.x / (len(people) + 1)
	var current_pos : float = chunk_size
	var TOP_OFFSET = 1/4.0
	var y =  get_viewport().size.y * TOP_OFFSET 
	for p in people:
		var sprite = p as Sprite2D
		sprite.position.x = current_pos
		current_pos += chunk_size
		sprite.position.y = y
