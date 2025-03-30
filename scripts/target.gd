extends Area2D

class_name Target

signal i_am_destroyed

# move timer
@export var SPEED : float = 1.5
@export var AMPLITUDE : float = 100.0
@export var ticks : float = 0

var velocity_y = 0
var start_y
var falling : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(on_hit_by_bullet)
	start_y = position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not falling:
		bounce_spider(delta)
	else:
		fall_down_spider(delta)
	check_out_of_bounds()
	
func bounce_spider(delta):
	ticks += delta * SPEED
	position.y = start_y + sin(ticks) * AMPLITUDE

func fall_down_spider(delta):
	velocity_y += GM.GRAVITY * delta
	$Spider.position.y += velocity_y * delta
	$CollisionShape2D.position.y += velocity_y * delta

func check_out_of_bounds():
	if $CollisionShape2D.position.y > GM.WINDOW_HEIGHT:
		i_am_destroyed.emit()
		queue_free()

func on_hit_by_bullet(area):
	falling = true
	
