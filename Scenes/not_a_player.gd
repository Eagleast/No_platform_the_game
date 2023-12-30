extends CharacterBody2D
@onready var player_2 = $"."
var pullers = []
var not_pullers = []
@export var MAX_VELOCITY = Vector2(10000, 10000)

func max_velocity(chien):
	if chien.y > MAX_VELOCITY.y :
		velocity.y = MAX_VELOCITY.y
	if chien.x > MAX_VELOCITY.x :
		velocity.x = MAX_VELOCITY.x
	if chien.y < -MAX_VELOCITY.y :
		velocity.y = -MAX_VELOCITY.y
	if chien.x < -MAX_VELOCITY.x :
		velocity.x = -MAX_VELOCITY.x
		
func gravitational_pull_remove(body_pos):
	not_pullers.append(body_pos)
	
func gravitational_pull_remover(not_pullers, pullers):
	for i in range(len(pullers)):
		for j in range(len(not_pullers)):
			if pullers[i] == not_pullers[j]:
				pullers.pop_at(i)
				not_pullers.pop_at(j)

func gravitational_pull_add(body_pos):
	pullers.append(Vector2(body_pos))
	print("puller added")
	pass
	
func gravitational_pull(pullers, delta):
	for i in range(len(pullers)):
		var scaling = Vector2(pullers[i]).distance_to(player_2.position)
		#print(scaling)
		player_2.velocity += Vector2(pullers[i] - player_2.position).normalized() * (20000000/pow(scaling,2)) * delta
		#print(player_2.velocity)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#calculate velocity with blackholes
	gravitational_pull(pullers, delta)
	gravitational_pull_remover(not_pullers, pullers)
	#set gravity
	if not is_on_floor():
		#print("add gravity")
		player_2.velocity.y += 300 * delta
		print("vel : " ,player_2.velocity)
	max_velocity(velocity)
	move_and_slide()
	pass
