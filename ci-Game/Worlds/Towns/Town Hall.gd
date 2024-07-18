extends Node2D

var buildingScene = preload("res://Worlds/Towns/Building.tscn")

func _ready():
	createBuilding()

func createBuilding():
	var townSize = randi_range(3, 10)
	
	# Get the position of the town hall
	var townHallPosition = global_transform.origin
	
	for i in range(1, townSize):
		# Calculate a random angle and distance from the town hall
		var angle = randf() * 2 * PI
		var distance = randi_range(500, 750)  # Adjust the range as needed
		
		# Calculate the position of the new building
		var xOffset = cos(angle) * distance
		var yOffset = sin(angle) * distance
		var buildingPosition = Vector2(townHallPosition.x + xOffset, townHallPosition.y + yOffset)
		
		# Instantiate the building scene
		var buildingInstance = buildingScene.instantiate()
		
		# Set the position of the building instance
		buildingInstance.global_position = buildingPosition
		
		# Add the building instance as a child of the parent node
		get_parent().add_child(buildingInstance)
