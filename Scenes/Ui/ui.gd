extends CanvasLayer

@onready var fuel_lvl = $Control/MarginContainer/VBoxContainer/HBoxContainer/Fuel_lvl
@onready var score_label = $scoreLabel
@onready var fuel_label = $fuelLabel

func _on_fuel_lvl(fuel_lvl_player, max_fuel_player):
	fuel_lvl.value = fuel_lvl_player / max_fuel_player
	fuel_label.text ="Fuel level : %04d/%s" % [int(fuel_lvl_player),max_fuel_player]

func score_update():
	score_label.text="bonjour"
