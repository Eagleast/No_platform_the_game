extends RigidBody2D
@onready var collision_shape_2d = $CollisionShape2D


func impulse(mass_pos, jump_dir,mass_player):
	apply_impulse(-jump_dir * mass_player / mass,mass_pos-position)
	print("mass of platform : ", mass)

func add_collision(player_col_shape, player_col_location):
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(100, 100)
	var player_mirror = CollisionShape2D.new()
	player_mirror.shape = player_col_shape 
	player_mirror.global_transform =get_global_transform().inverse() * player_col_location 
	add_child(player_mirror)
	
	print("added")
	pass

func _process(delta):
	
	pass
