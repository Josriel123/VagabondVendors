extends Node2D

var townSheepScene = preload("res://Actors/sheep/Town Sheep/Town Sheep.tscn")
@onready var sprite = $Sprite2D as Sprite2D
var sheepInHouse = false
func _ready():
	spawnSheep()
	#z_index = 7
	sprite.z_index = 7
	

func spawnSheep():
	var townHallPosition = global_transform.origin
	
	# Instantiate the sheep scene directly on the town hall position
	var sheepInstance = townSheepScene.instantiate()
	
	# Set the position of the sheep instance
	sheepInstance.global_position = townHallPosition
	
	# Add the sheep instance as a child of the parent node
	get_parent().add_child(sheepInstance)



























func _on_area_2d_body_entered(body):
	if body.is_in_group("TownSeep"):
		sheepInHouse = true
		print("sheep in house")
		



func _on_area_2d_body_exited(body):
		pass # Replace with function body.
