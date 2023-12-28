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
@onready var marker_2d = $"../Marker2D"
@onready var jumper = $"."
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $CollisionShape2D



func _ready():
	
	position = starting_pos
	# Enable the logging of 5 collisions.
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	
	# Apply Godot physics at first
	set_use_custom_integrator(false) 


func _process(delta):
	if Input.is_action_pressed("jump") and is_sticking:
		add_jump_force(delta)
	if Input.is_action_just_released("jump") and is_sticking:
		print("jump")
		is_sticking = false
		set_use_custom_integrator(false)
		set_freeze_enabled(0)
		jump()
	if Input.is_action_pressed("reset"):
		game_over()

func _integrate_forces(body_state):
	if Input.is_action_pressed("reset"):
		game_over()
	if is_sticking == false && body_state.get_contact_count() == 1 and not jumping:
		is_sticking = true
		#set jumper velocity to 0 so the old velocity doesnt add up in next jump
		jumper.set_linear_velocity(Vector2(0,0))
		# Ignore Godot physics once the jumper sticks
		#set_use_custom_integrator(true)
		set_freeze_mode(FREEZE_MODE_STATIC)
		set_freeze_enabled(1)
		print(get_freeze_mode())
		# Get the rigid body on which the ball will stick
		body_on_which_sticked = body_state.get_contact_collider_object(0)
		if body_on_which_sticked.is_in_group("platform"):
			pass
			#body_on_which_sticked.add_collision(collision_shape_2d.get_shape(),global_transform)
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

func pushing_platforms(jumping_force):
	var colliding_bodys = get_colliding_bodies()
	var colliding_platforms = []
	
	for i in range(len(colliding_bodys)):
		if colliding_bodys[i].is_in_group("platform"):
			colliding_platforms.append(colliding_bodys[i])
	for j in range(len(colliding_platforms)):
		colliding_platforms[j].impulse(position, jumping_force, mass)
		print("impulse sent")

# saute dans la direction du curseur et
func jump():
	#recupere la taille de la fenetre
	var screen_size = get_window().size
	#recupere la position de la souris dans l'ecran
	var mouse_pos = get_viewport().get_mouse_position()
	#comme le jumper est toujours au centre de l'ecran
	#on peut faire l'euristique de dire que le jumper doit sauter
	#dans la direction du vecteur qui va du centre de l'ecran à a souris
	var jump_direction = mouse_pos - Vector2(screen_size /2)
	#on normalize le vecteur pour ensuite lui appliquer la force voulu
	var true_jump_dir = - jump_direction.normalized()
	#valeur finale du saut il faut remplacer jump velocity pour que le joueur puisse regler la puissance du saut
	jump_velocity =- true_jump_dir * jump_force
	#jumping true dure la durée du timer pour entre autre empecher jumper de se recoller a la deuxieme frame du saut
	pushing_platforms(jump_velocity)
	jumping = true
	timer.start()
	apply_central_impulse(jump_velocity)
	jump_force = 0
	
	
	#updates the position of the debug marker (not working rn)

func update_marker():
	marker_2d.update_pos(jump_velocity / 2 + position)
	#timer pour que jumper ne puisse pas se reacrcher instantanément après avoir sauté

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
	respawn()
	is_sticking = false
func respawn(): 
	set_position(starting_pos)
