extends Area2D
@onready var clearance_checker = $"."
@onready var sprite = $Sprite
var PLATFORM_DASH_1 = preload("res://Scenes/platform_dash1.tscn")

signal place_platform(platform_type, Position)


func create_platform(clearance):
	if clearance:
		var pos = get_viewport().get_mouse_position()
		place_platform.emit(PLATFORM_DASH_1, pos)
		print("signal emmited")

func change_icon():
	if not clearance_checker.has_overlapping_areas():
		sprite.set_self_modulate(150) 
	else:
		sprite.set_self_modulate(50) 

func check_for_clearance():
	if not clearance_checker.has_overlapping_areas():
		return true
	else:
		return false

func _process(delta):
	check_for_clearance()
	change_icon()
	clearance_checker.position = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("clic"):
		print("clicked")
		create_platform(check_for_clearance())
