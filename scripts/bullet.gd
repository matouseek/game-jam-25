extends Area2D

class_name Bullet

const INIT_SPEED = 50

var direction = Vector2.ZERO

var velocity : Vector2 = Vector2.ZERO

var digit = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.y = direction.y * INIT_SPEED
	velocity.x = direction.x * INIT_SPEED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	velocity.y += weight_from_digit(digit)
	position.x += INIT_SPEED * direction.x
	position.y += velocity.y 

func weight_from_digit(digit : int):
	return digit
