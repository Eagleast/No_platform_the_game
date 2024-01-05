extends CanvasLayer

@onready var fuel_lvl = $Control/MarginContainer/VBoxContainer/HBoxContainer/Fuel_lvl


func _on_fuel_lvl(fuel_lvl_player, max_fuel_player):
	fuel_lvl.value = fuel_lvl_player / max_fuel_player
