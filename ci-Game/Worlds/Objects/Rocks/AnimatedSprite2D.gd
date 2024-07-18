extends AnimatedSprite2D


var rockTypes = ["rock1", "rock3"]  # List of rock types
var rockType = ""

func _ready():
	# Initialize random number generator
	randomize()
	# Randomize rockType from rockTypes list
	rockType = rockTypes[randi() % rockTypes.size()]
	# Set the animation to the slected rock type
	play(rockType)
