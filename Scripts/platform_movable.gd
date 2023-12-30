extends RigidBody2D
@onready var collision_shape_2d = $CollisionShape2D


func impulse(mass_pos, jump_dir,mass_player):
	apply_impulse(-jump_dir * mass_player / mass,mass_pos-position)
	print("mass of platform : ", mass)
