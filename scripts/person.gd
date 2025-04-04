extends Area2D

class_name Person 

var speed = 0
@onready var anime = $Sprite
@onready var scream = $Scream
const SACRIFICE_TIME : float = 0.5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += delta*speed

func run(spd : float):
	speed = spd
	anime.play("running")

func _on_area_entered(area: Area2D) -> void:
	speed = 0
	anime.play("falling1")
	await anime.animation_finished
	anime.play("falling2")
	scream.pitch_scale += randf_range(-0.1, 0.3)
	scream.stream = load("res://assets/sfx/screaming_falling.wav") as AudioStream
	scream.play(randf_range(0.0, 0.3))
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, 1500), SACRIFICE_TIME)
	#tween.parallel().tween_property(self, "modulate", Color.RED, SACRIFICE_TIME)
	tween.parallel().tween_property(self, "scale", Vector2(0.15,0.15), SACRIFICE_TIME)
