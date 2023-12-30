extends Line2D

@export var l_scale = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update(velocity):
	set_point_position(1, Vector2(velocity.length() * l_scale , 0))
	look_at(velocity + global_position)
