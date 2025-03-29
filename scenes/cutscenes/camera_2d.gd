extends Camera2D

const SPEED = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var axis = Input.get_axis("up", "down")
	position.y += axis * SPEED * delta
	pass
