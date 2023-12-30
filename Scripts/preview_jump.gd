extends Line2D
@onready var jumper = $".."
var min_size = 100
var max_size = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_mouse_dir() + global_transform.origin)
	print(get_mouse_dir())

func update_tra(player_tra):
	pass

func update_preview(jump_force, max_jump):
	set_point_position(1, Vector2((jump_force * (1/ max_jump)*max_size) , 0)+ Vector2(min_size, 0))

func get_mouse_dir():
	var screen_size = get_window().size
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_dir = mouse_pos - Vector2(screen_size /2)
	var jump_dir = mouse_dir.normalized()
	return jump_dir
