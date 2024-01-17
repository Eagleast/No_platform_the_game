extends Button
var nb_player=1
var is_focused=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_focused:
		if Input.is_action_just_pressed("ui_left") : 
			if nb_player > 1 :
				nb_player-=1
		if Input.is_action_just_pressed("ui_right"):
			if nb_player < 8 :
				nb_player+=1
	set_text("Nombre joueur = %s" % nb_player)


func _on_focus_entered():
	is_focused=true


func _on_focus_exited():
	is_focused=false

func get_nb_player() -> int:
	return nb_player
