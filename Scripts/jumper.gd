extends RigidBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -700.0
@onready var area_2d = $Area2D
var mass_player = 100
var is_sticking = false
var body_on_which_sticked
var tr_ci_collider_to_ball = Transform2D()
var jumping = false
@onready var timer = $Timer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Enable the logging of 5 collisions.
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	
	# Apply Godot physics at first
	set_use_custom_integrator(false) 

func _process(delta):
	
	if Input.is_action_just_pressed("jump"):
		print("jump")
		
		is_sticking = false
		set_use_custom_integrator(false)
		jump()

func _integrate_forces(body_state):
	# Handle jump.
	print(body_state.get_contact_count())
	if is_sticking == false && body_state.get_contact_count() == 1 and not jumping:
		is_sticking = true
		# Ignore Godot physics once the ball sticks
		set_use_custom_integrator(true)
		# Get the rigid body on which the ball will stick
		body_on_which_sticked = body_state.get_contact_collider_object(0)
		# For debug, check on which we are sticking
		print("The ball is sticking on a ", body_on_which_sticked.get_name())
		# Some transforms (tr) at the collision instant (ci)
		var tr_ci_world_to_ball = get_global_transform() # from the world coordinate system to the ball coordinate system
		var tr_ci_world_to_collider = body_on_which_sticked.get_global_transform() # from the world cs to the collider cs
		tr_ci_collider_to_ball = tr_ci_world_to_collider.inverse() * tr_ci_world_to_ball # Because: collider->ball = collider->world then world->ball = inverse(world->collider) then world->ball
		
	# Behavior when sticking
	if is_sticking :
		# We take the last transform of the moving collider, and we keep the same relative position of the ball to the collider it had at the collision instant.
		# In other words: "world->collider (at latest news), and then, collider->ball (like at the collision instant)".
		global_transform = body_on_which_sticked.get_global_transform() * tr_ci_collider_to_ball

func jump():
	var screen_size = get_window().size
	var mouse_pos = get_viewport().get_mouse_position()
	var jump_direction = mouse_pos - Vector2(screen_size /2)
	var true_jump_dir = - jump_direction.normalized()
	var jump_force = true_jump_dir * JUMP_VELOCITY
	jumping = true
	timer.start()
	apply_central_impulse(jump_force)

func _on_timer_timeout():
	jumping = false
	pass # Replace with function body.
