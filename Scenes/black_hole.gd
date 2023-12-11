extends Area2D
@onready var area_2d = $"."


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("not_a_player"):
		body.gravitational_pull_add(area_2d.position)
	pass # Replace with function body.

func _on_body_exited(body):
	if body.is_in_group("not_a_player"):
		body.gravitational_pull_remove(area_2d.position)
	pass # Replace with function body.
