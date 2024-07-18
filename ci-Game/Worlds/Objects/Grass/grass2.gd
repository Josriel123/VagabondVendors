extends Node2D

var grassTypes = ["grass1", "grass2"]  # List of rock types
var grassType = ""

func _ready():
	# Randomize rockType from rockTypes list
	grassType = grassTypes[randi() % grassTypes.size()]

func _process(_delta):
	# Play animation based on rockType
	if grassType == "grass1":
		$AnimatedSprite2D.play("grass1")
	elif grassType == "grass2":
		$AnimatedSprite2D.play("grass2")
