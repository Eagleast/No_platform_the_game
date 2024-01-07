extends Node2D

const JUMPER = preload("res://Scenes/player/jumper.tscn")



func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		var new_jumper = JUMPER.instantiate()
		add_child(new_jumper)
		
