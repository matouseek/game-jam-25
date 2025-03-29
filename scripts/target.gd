extends Area2D

class_name Target

signal i_am_destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(on_hit_by_bullet)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_hit_by_bullet(area):
	i_am_destroyed.emit()
	queue_free()
