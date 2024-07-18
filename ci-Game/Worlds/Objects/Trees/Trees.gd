extends StaticBody2D

var state = "not shaken"
var player_in_area = false
var player

@onready var tree_shaking_sound = $TreeShakingSound
@onready var collect_sound = $CollectSound

@export var apple: InvItem
@export var stick: InvItem
# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.collision_mask = 255
	collision_layer = 128
	z_index = 7

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	shake()

func shake():
	if player_in_area == true:
		
		if Input.is_action_just_pressed("e"):
			tree_shaking_sound.play()
			if state == "not shaken":
				var num = randi_range(0 , 100)
				if num <= 20:
					player.collect(apple)
					collect_sound.play()
					print("+1 Apple")
				elif num >= 80:
					player.collect(stick)
					collect_sound.play()
					print("+1 Stick")
				state = "shaken"
				print("shaken")
			else:
				print("already shaken")
				


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true
		player = body


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false
	
