extends Area2D

class_name Target

signal i_am_destroyed

# move timer
@export var SPEED : float = 1.5
@export var AMPLITUDE : float = 100.0
@export var ticks : float = 0

var start_y

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(on_hit_by_bullet)
	start_y = position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ticks += delta * SPEED
	position.y = start_y + sin(ticks) * AMPLITUDE
	

func on_hit_by_bullet(area):
	i_am_destroyed.emit()
	queue_free()
