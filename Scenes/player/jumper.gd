extends RigidBody2D

signal fuel_lvl()


@onready var sprite_2d = $Sprite2D
@onready var prout = $sound_holder/prout
@onready var boosters = $sound_holder/boosters
@onready var death_zone = $"../death_zone"
@onready var dash_reloading = $Dash/dash_reloading
@onready var dash_activation = $Dash/dash_activation
@onready var ui = $Control

var bumpable = true
var prev_vel = 0
var moving = true
var starting_pos = Vector2(0,0)
var thruster_speed = 600
var booster_fuel = 100
var is_boosting = false
var is_dead = false
var move_dir = Vector2(0,0)

enum INPUT_SCHEMES {KEYBOARD, GAMEPAD}
static var Input_scheme : INPUT_SCHEMES = INPUT_SCHEMES.KEYBOARD

@export var max_booster_fuel = 1000
@export var fuel_regen = 200
@export var fuel_conso = 500 

@export var base_thruster_speed = 200
@export var booster_speed = 600
@export var max_speed = 1000
@export var dash_force = 10000

@export var bumpiness = 1

func _ready():
	thruster_speed = base_thruster_speed
	position = starting_pos
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	lock_rotation = true

func _integrate_forces(state):
	if is_dead:
		respawn()

func _physics_process(delta):
	handle_inputs() #handles input presses
	move() #makes the player move
	bump(prev_vel) #handles bumps with other players or environement
	prev_vel = linear_velocity #needed so we dont use uptated velocitys when coliding.
	boost(delta)
	ui.dash_reload_update(dash_reloading.wait_time, dash_reloading.time_left)

func _process(_delta):
	pass

func handle_inputs():
	if Input_scheme == INPUT_SCHEMES.GAMEPAD or Input_scheme == INPUT_SCHEMES.KEYBOARD:
		var input_dir_y = Input.get_axis("move_up", "move_down")
		var input_dir_x = Input.get_axis("move_left", "move_right")
		move_dir = Vector2(input_dir_x, input_dir_y)
		if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			$Sprite2D.global_rotation = move_dir.angle()
		
		

	if Input.is_action_pressed("reset"):
		game_over()
	if Input.is_action_just_pressed( "boost"):
		try_boost()
	if Input.is_action_just_released("boost"):
		stop_boost()
	if Input.is_action_just_pressed("dash"):
		try_dash()

func boost(delta):
	if is_boosting:
		if not boosters.playing:
			boosters.play()
		sprite_2d.flip_v = true
		thruster_speed = base_thruster_speed + booster_speed
		booster_fuel -= fuel_conso * delta
		if booster_fuel <= 0:
			is_boosting = false
	else:
		if boosters.playing:
			boosters.stop()
		sprite_2d.flip_v = false
		booster_fuel += fuel_regen * delta
		if booster_fuel >= max_booster_fuel:
			booster_fuel = max_booster_fuel
	ui.fuel_lvl_update(booster_fuel, max_booster_fuel)

func try_boost():
	if booster_fuel > 0 and not is_boosting:
		is_boosting = true

func stop_boost():
	is_boosting = false
	thruster_speed = base_thruster_speed

func bump(speed):
	if get_contact_count() > 0: #contact interactions
		var colliding_bodies = get_colliding_bodies()
		for collider in colliding_bodies:
			if collider.is_in_group("bumper") and collider.bumpable:
				prout.play()
				collider.bumped()
				var collider_dir = get_collider_dir(collider)
				apply_central_impulse(collider_dir.normalized() * (speed.length() + 1) * bumpiness)
				print("linear velocity : ", speed.length())
			else: 
				pass

func bumped():
	pass

func get_collider_dir(collider):
	var global_dir : Vector2 = global_position - collider.global_position
	return global_dir
	
#func get_mouse_dir() -> Vector2:
	#var screen_size = get_window().size
	#var mouse_pos = get_viewport().get_mouse_position()
	#var jump_direction = mouse_pos - Vector2(screen_size /2)
	#var true_jump_dir = jump_direction.normalized()
	#return true_jump_dir

func move():
	if moving:
		var move_dir_speed = move_dir * thruster_speed
		apply_central_force(move_dir_speed)

func game_over():
	is_dead = true

func respawn(): 
	set_position(starting_pos)
	linear_velocity = Vector2(0,0)
	is_dead = false

func try_dash():
	if dash_reloading.is_stopped() and dash_activation.is_stopped():
		dash_activation.start()

func _on_dash_activation_timeout():
	apply_central_impulse(move_dir * dash_force)
	dash_reloading.start()
