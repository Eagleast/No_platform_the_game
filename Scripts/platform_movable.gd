extends RigidBody2D
var mass_platform = 300
var scaling = 0.3

func impulse(mass_pos, jump_dir,mass_player):
	apply_impulse(jump_dir*-scaling,mass_pos-position)
