extends CharacterBody2D

var concected_platforms = []
const SPEED = 300.0
const JUMP_VELOCITY = -700.0
@onready var area_2d = $Area2D
var mass_player = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#func _ready():
	#set_floor_snap_length(10)
	#apply_floor_snap()
	#print(get_floor_snap_length())

func _physics_process(delta):
	# Add the gravity.
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		jump()


	move_and_slide()



func jump():
	var screen_size = get_window().size
	var mouse_pos = get_viewport().get_mouse_position()
	var jump_direction = mouse_pos - Vector2(screen_size /2)
	var true_jump_dir = - jump_direction.normalized()
	var connected_bodys = area_2d.get_overlapping_bodies()
	
	velocity = true_jump_dir * JUMP_VELOCITY
	for j in range(len(connected_bodys)):
		if connected_bodys[j].is_in_group("platform"):
			concected_platforms.append(connected_bodys[j])
	for i in range(len(concected_platforms)):
		concected_platforms[i].impulse(position, JUMP_VELOCITY, mass_player)
