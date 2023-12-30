extends RigidBody2D

const SPEED = 300.0
var jump_force = 0.0
var is_sticking = false
var body_on_which_sticked
var tr_ci_collider_to_ball = Transform2D()
var jumping = false
var starting_pos = Vector2(0,0)
var jump_velocity = Vector2(0,0)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var max_jump_vel:float
@export var time_to_max_jump:float
@onready var timer = $Timer
@onready var area_2d = $Area2D
@onready var jump_preview = $Jump_preview
@onready var direction_vector = $direction_vector

func _ready():
	position = starting_pos

func _process(delta):
	if Input.is_action_pressed("jump"):
		add_jump_force(delta)
	if Input.is_action_just_released("jump"):
		print("jump")
		jump()
	if Input.is_action_pressed("reset"):
		game_over()
	jump_preview.update_preview(jump_force, max_jump_vel)
	direction_vector.update(linear_velocity)

func get_mouse_dir():
	var screen_size = get_window().size
	var mouse_pos = get_viewport().get_mouse_position()
	var jump_direction = mouse_pos - Vector2(screen_size /2)
	var true_jump_dir = jump_direction.normalized()
	return true_jump_dir

func jump():
	jump_velocity = get_mouse_dir() * jump_force
	jumping = true #jumping true dure la durée du timer pour entre autre empecher jumper de se recoller a la deuxieme frame du saut
	timer.start()
	apply_central_impulse(jump_velocity)
	jump_force = 0

func _on_timer_timeout():
	jumping = false
	pass # Replace with function body.

func add_jump_force(delta):
	jump_force += max_jump_vel / time_to_max_jump * delta
	if jump_force >= max_jump_vel:
		jump_force = max_jump_vel
	print(jump_force)
	

func game_over():
	respawn()
	is_sticking = false

func respawn(): 
	set_position(starting_pos)
