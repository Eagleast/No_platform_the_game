extends CharacterBody2D

var concected_platforms = []
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var area_2d = $Area2D
var mass_player = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)



func jump():
	velocity.y = JUMP_VELOCITY
	move_and_slide()
	var connected_bodys = area_2d.get_overlapping_bodies()
	print("conected ", connected_bodys)
	for j in range(len(connected_bodys)):
		print(connected_bodys[j])
		if connected_bodys[j].is_in_group("platform"):
			print("platform ", connected_bodys[j], " added")
			concected_platforms.append(connected_bodys[j])
	for i in range(len(concected_platforms)):
		print("impulsed")
		concected_platforms[i].impulse(position, JUMP_VELOCITY, mass_player)
		print("mass plaer ", mass_player)
