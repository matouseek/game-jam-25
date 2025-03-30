extends Area2D

class_name Bullet

const PLUNGE_SOUND = "res://assets/sfx/plunge.wav"

const INIT_SPEED_BASE = 2000 # hero strength
const POWER_SCALE = 90 # penalty for each weight increase

var direction = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
var speed = 0
var digit = 0

var flying : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_flying():
	var init_speed : float = get_init_speed() 
	velocity.y = direction.y * init_speed
	velocity.x = direction.x * init_speed
	speed = init_speed
	flying = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	if flying:
		check_out_of_bounds_down()
		move(delta)

func move(delta):
	if digit != 0: # special photon case
		velocity.y += GM.GRAVITY * delta
	position.x += velocity.x * delta
	position.y += velocity.y * delta

func check_out_of_bounds_down():
	var height_offset = 20
	if position.y > GM.WINDOW_HEIGHT + height_offset:
		GM.play_sfx(PLUNGE_SOUND,1)
		queue_free()

func get_init_speed() -> float:
	return INIT_SPEED_BASE - (digit * POWER_SCALE)
