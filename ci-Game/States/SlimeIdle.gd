extends State
class_name SlimeIdle

@export var enemy: CharacterBody2D
@export var move_speed := 10.0

var player : CharacterBody2D

var move_direction : Vector2
var wander_time : float
var wait_time : float

func randomized_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 10)
	wait_time = randf_range(0, 10)
	

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	randomized_wander()

func Update(delta: float):
	if wait_time <= 0:
		if wander_time > 0:
			wander_time -= delta
		else:
			randomized_wander()
	else:
		wait_time -= delta

func Physics_Update(delta : float):
	if enemy:
		if wait_time <= 0:
			enemy.velocity = move_direction * move_speed
		else:
			enemy.velocity = Vector2(0, 0)
	
	var direction = player.global_position - enemy.global_position
	
	if direction.length() < 150:
		Transitioned.emit(self, "SlimeFollow")




