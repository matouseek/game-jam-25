extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.button_down.connect(func() : GM.level_completed.emit())
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass	
