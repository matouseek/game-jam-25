extends Node2D

const END_GAME_MUSIC = "res://assets/music/nuke_explosion.mp3"

var transition_duration : float = 2
var bg_duration : float = 1.1
var current_bg_index: int = 0

@onready var bgs = $BGs

# Called when the node enters the scene tree for the first time.
func _ready():
	disable_all()
	GM.play_music(END_GAME_MUSIC)
	switch_to_bg(0)
	for i in range(1,4):
		await get_tree().create_timer(bg_duration).timeout
		await fade_to_bg(i,transition_duration)
	#await get_tree().create_timer(bg_duration).timeout
	get_tree().quit()

func switch_to_bg(new_ind : int):
	bgs.get_child(current_bg_index).visible = false
	bgs.get_child(new_ind).visible = true
	current_bg_index = new_ind

func fade_to_bg(new_ind : int, fade_time : float) -> void:
	await GM.fade_to_function(func() : switch_to_bg(new_ind),fade_time)

func disable_all():
	for bg in bgs.get_children():
		bg.visible = false
