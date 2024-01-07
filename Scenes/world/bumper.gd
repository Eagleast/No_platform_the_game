extends RigidBody2D
@onready var timer = $Timer
@onready var sprite_2d = $Sprite2D

var bumpable = true

func _ready():
	lock_rotation = true

func bumped():
	stop_bump()
	
func stop_bump(): 
	sprite_2d.flip_v = false
	bumpable = false
	timer.start()

func _on_timer_timeout():
	sprite_2d.flip_v = true
	bumpable = true

