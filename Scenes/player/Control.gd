extends Node

@onready var score_label = $scoreLabel
@onready var fuel_label = $fuelLabel

@onready var dash_bar = $dash_bar
@onready var fuel_lvl = $Fuel_lvl

func dash_reload_update(timer, time_left):
	dash_bar.value = (timer - time_left) / timer
	printerr(dash_bar.value)

func fuel_lvl_update(fuel_lvl_player, max_fuel_player):
	fuel_lvl.value = fuel_lvl_player / max_fuel_player
	#fuel_label.text ="Fuel level : %04d/%s" % [int(fuel_lvl_player),max_fuel_player]

#func score_update():
	#score_label.text="bonjour"

