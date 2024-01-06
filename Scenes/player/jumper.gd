extends RigidBody2D

signal fuel_lvl()

@onready var sprite_2d = $Sprite2D
@onready var prout = $Node2D/prout
@onready var boosters = $Node2D/boosters
@onready var death_zone = $"../death_zone"

var prev_vel = 0
var moving = true
var starting_pos = Vector2(0,0)
var thruster_speed = 600
var booster_fuel = 100
var is_boosting = false

enum INPUT_SCHEMES {KEYBOARD_MOUSE, GAMEPAD}
static var Input_scheme : INPUT_SCHEMES = INPUT_SCHEMES.GAMEPAD

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
	var input_dir = handle_inputs() #handles input presses
	move(input_dir) #makes the player move
	bump(prev_vel) #handles bumps with other players or environement
	prev_vel = linear_velocity #needed so we dont use uptated velocitys when coliding.
	boost(delta)

func _process(_delta):
	pass
	print(Engine.get_frames_per_second())

func handle_inputs():
	var input_dir:Vector2
	if Input_scheme == INPUT_SCHEMES.GAMEPAD:
		var input_dir_y = Input.get_axis("move_up", "move_down")
		var input_dir_x = Input.get_axis("move_left", "move_right")
		input_dir = Vector2(input_dir_x, input_dir_y)
	elif Input_scheme == INPUT_SCHEMES.KEYBOARD_MOUSE:
		input_dir = get_mouse_dir()
	
	if Input.is_action_pressed("reset"):
		game_over()
	if Input.is_action_just_pressed( "boost"):
		try_boost()
	if Input.is_action_just_released("boost"):
		stop_boost()
	return input_dir

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
		for collider in colliding_bodies:
			if collider.is_in_group("bumper") and collider.bumpable:
				prout.play()
				collider.stop_bump()
				var collider_dir = get_collider_dir(collider)
				apply_central_impulse(collider_dir.normalized() * (speed.length() + 1) * bumpiness)
				print("linear velocity : ", speed.length())
			else: 
				pass

func get_collider_dir(collider):
	var global_dir : Vector2 = global_position - collider.global_position
	return global_dir
	
func get_mouse_dir() -> Vector2:
	var screen_size = get_window().size
	var mouse_pos = get_viewport().get_mouse_position()
	var jump_direction = mouse_pos - Vector2(screen_size /2)
	var true_jump_dir = jump_direction.normalized()
	return true_jump_dir

func move(move_dir):
	if moving:
		var move_dir_speed = move_dir * thruster_speed
		apply_central_force(move_dir_speed)

func game_over():
	respawn()

func respawn(): 
	set_position(starting_pos)


func _on_death_zone_area_entered(_area):
	game_over()
