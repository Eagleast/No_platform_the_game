extends RigidBody2D
var mass_platform = 300
var scaling = 0.3

func impulse(mass_pos, jump_dir,mass_player):
	print("mass player inside ", mass_player)
	apply_impulse((Vector2(0, jump_dir*-scaling)), Vector2(0,0))
	print("scale ", scaling)
