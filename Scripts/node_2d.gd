extends Node2D
func _ready():
	var platformplacer = get_node("platform_placer")
	platformplacer.place_platform.connect(_on_platform_placer_place_platform)

func _on_platform_placer_place_platform(platform_type, Position):
	var spawn_platform = platform_type.instantiate()
	spawn_platform.position = Position
	add_child(spawn_platform)
