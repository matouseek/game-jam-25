extends Node2D

# ASSETS LOADING
const BULLET_ICON_PATH = "res://assets/shooting_balls/balls/ball"
var bullet_scene = preload("res://scenes/minigames/shooting_balls/bullet.tscn")

const CANNON_SOUND = "res://assets/sfx/fireworks.wav"

# ONREADY STUFF
@onready var cannon = $Cannon
@onready var targets = $Targets
@onready var target_count = targets.get_child_count()

var selected_ammo : int

# label blinking
@onready var space_to_shoot = $SpaceToShoot
const BLINK_TIME = 1
const MAX_STRETCH = 1.05

# shot timing
var shot_timer : Timer
const SHOT_DELAY : float = 1.0

# cannon rotation
const CANNON_ROT_SPEED : float = PI / 100
const CANNON_ROT_DOWN_LIM : float = 0
const CANNON_ROT_UP_LIM : float = - PI / 2

# balls to shoot
const MAX_BALL_WEIGHT = 9
const BALLS_QUEUE_SIZE = 2
const BALL_QUEUE_OFFSET = GM.WINDOW_WIDTH / 10.0
const STARTING_BALLS = [3,5,7,2,4,1,9,6,3,1,4,2,1,1,1]
const PI_DIGS = [3,1,4,1,5,9,2,6,5,3,5,8,9,7,9,3,2,3,8,4,6,2,6,4,3,3,8,3,2,7,9,5,0,2,8,8,4,1,9,7,1,6,9,3,9,9,3,7,5,1,0,5,8,2,0,9,7,4,9,4,4,5,9,2,3,0,7,8,1,6,4,0,6,2,8,6,]
var next_ball = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_shot_timer()
	setup_balls_to_shoot()
	connect_to_targets()
	tween_label()
	
func setup_balls_to_shoot():
	for i in range(BALLS_QUEUE_SIZE):
		append_bullet_to_stack()

func tween_bullet_to_stack():
	var bullet = append_bullet_to_stack()
	bullet.position.x -= BALL_QUEUE_OFFSET
	var tween = get_tree().create_tween()
	tween.tween_property(bullet, "position", Vector2(bullet.position.x+BALL_QUEUE_OFFSET,bullet.position.y), SHOT_DELAY)


func get_next_ball():
	next_ball += 1
	return (STARTING_BALLS + PI_DIGS)[next_ball % (len(STARTING_BALLS) + len(PI_DIGS))]

func get_random_bullet_weight():
	if GM.travelling_back:
		return 0
	else:
		return get_next_ball()

func append_bullet_to_stack():
	var bullet : Bullet = bullet_scene.instantiate() as Bullet
	bullet.position.x -= $BallsStack.get_child_count() * BALL_QUEUE_OFFSET
	bullet.digit = get_random_bullet_weight()
	var sprite = bullet.get_node("Sprite2D")
	sprite.texture = load(BULLET_ICON_PATH + str(bullet.digit) + ".png")
	$BallsStack.add_child(bullet)
	return bullet

func delete_oldest_bullet_from_stack():
	$BallsStack.get_child(0).free()

func tween_balls():
	var tween
	for ball in $BallsStack.get_children():
		tween = get_tree().create_tween()
		tween.tween_property(ball, "position", Vector2(ball.position.x+BALL_QUEUE_OFFSET,ball.position.y), SHOT_DELAY)
	await tween
	delete_oldest_bullet_from_stack()
	tween_bullet_to_stack()
	
func setup_shot_timer():
	shot_timer = Timer.new()
	shot_timer.wait_time = SHOT_DELAY
	shot_timer.one_shot = true
	shot_timer.autostart = false
	add_child(shot_timer)
	shot_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_cannon_direction()

# connect to targets destroyed signals
func connect_to_targets():
	for target in targets.get_children():
		target.i_am_destroyed.connect(check_targets_destroyed)	

# sends signal to complete level if all targets destroyed
func check_targets_destroyed():
	target_count -= 1
	if target_count == 0:
		GM.level_completed.emit()

func set_cannon_direction():
	var dir = Input.get_axis("up","down")
	cannon.rotation += dir * CANNON_ROT_SPEED
	limit_cannon_movement()

func limit_cannon_movement():
	if cannon.rotation < CANNON_ROT_UP_LIM:
		cannon.rotation = CANNON_ROT_UP_LIM
	if cannon.rotation > CANNON_ROT_DOWN_LIM:
		cannon.rotation = CANNON_ROT_DOWN_LIM

func _input(event):
	if Input.is_action_just_pressed("shoot"):
		shoot()


# shoots the specified digit, the digit value controls the weight of the bullet
func shoot():
	if shot_timer.time_left == 0:
		GM.play_sfx(CANNON_SOUND)
		shot_timer.start()
		var bullet : Bullet = bullet_scene.instantiate() as Bullet
		bullet.position = cannon.position
		bullet.direction = Vector2(cos(cannon.rotation),sin(cannon.rotation))
		bullet.digit = $BallsStack.get_child(0).digit
		var sprite = bullet.get_node("Sprite2D")
		sprite.texture = load(BULLET_ICON_PATH + str(bullet.digit) + ".png")
		bullet.start_flying()
		get_tree().current_scene.add_child(bullet)
		tween_balls()
	else:
		pass #TODO: add shot impossible sound

func tween_label():
	space_to_shoot.pivot_offset = space_to_shoot.size * 0.5
	var tween = get_tree().create_tween()
	tween.tween_property(space_to_shoot, "scale", Vector2(MAX_STRETCH,MAX_STRETCH), BLINK_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(space_to_shoot, "scale", Vector2(1.0,1.0), BLINK_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()
