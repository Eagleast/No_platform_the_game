extends RigidBody2D

signal fuel_lvl()
signal bumped()

@onready var bumper_timer = $bumper_timer
@onready var sprite_2d = $Sprite2D

var prev_vel = 0
var moving = true
var starting_pos = Vector2(0,0)
var thruster_speed = 600
var booster_fuel = 100
var is_boosting = false

@export var max_booster_fuel = 1000
@export var fuel_regen = 200
@export var fuel_conso = 500 

@export var base_thruster_speed = 200
@export var booster_speed = 600
@export var max_speed = 1000

@export var bumpiness = 2

func _ready():
	thruster_speed = base_thruster_speed
	position = starting_pos
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	lock_rotation = true

func _physics_process(delta):
	
	move() #makes the player move
	bump(prev_vel) #handles bumps with other players or environement
	prev_vel = linear_velocity #needed so we dont use uptated velocitys when coliding.

func _process(delta):
	
	handle_inputs() #handles input presses
	
	boost(delta)
	
	print_debbug()

func print_debbug():
	#print(thruster_speed)
	#print(booster_fuel)
	pass
func handle_inputs():
	if Input.is_action_pressed("reset"):
		game_over()
	if Input.is_action_just_pressed( "jump"):
		try_boost()
	if Input.is_action_just_released("jump"):
		stop_boost()

func boost(delta):
	if is_boosting:
		sprite_2d.flip_v = true
		thruster_speed = base_thruster_speed + booster_speed
		booster_fuel -= fuel_conso * delta
		if booster_fuel <= 0:
			is_boosting = false
	else:
		sprite_2d.flip_v = false
		booster_fuel += fuel_regen * delta
		if booster_fuel >= max_booster_fuel:
			booster_fuel = max_booster_fuel
	fuel_lvl.emit(booster_fuel, max_booster_fuel)

func try_boost():
	if booster_fuel > 0 and not is_boosting:
		is_boosting = true

func stop_boost():
	is_boosting = false
	thruster_speed = base_thruster_speed

func bump(speed):
	if get_contact_count() > 0: #contact interactions
		var colliding_bodies = get_colliding_bodies()
		for i in len(colliding_bodies):
			var collider = colliding_bodies[i]
			if collider.is_in_group("player") and collider.bumpable:
				collider.stop_bump()
				var collider_dir = get_collider_dir(colliding_bodies[i])
				apply_central_impulse(collider_dir.normalized() * (speed.length() + 1) * bumpiness)
				print("linear velocity : ", speed.length())
			else: 
				pass

func get_collider_dir(collider):
	var global_dir : Vector2 = global_position - collider.global_position
	return global_dir
	
func get_mouse_dir():
	var screen_size = get_window().size
	var mouse_pos = get_viewport().get_mouse_position()
	var jump_direction = mouse_pos - Vector2(screen_size /2)
	var true_jump_dir = jump_direction.normalized()
	return true_jump_dir

func move():
	if moving:
		var move_dir_speed = get_mouse_dir() * thruster_speed
		apply_central_force(move_dir_speed)

func game_over():
	respawn()

func respawn(): 
	set_position(starting_pos)
