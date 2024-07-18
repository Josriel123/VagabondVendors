extends ProgressBar

@onready var player = get_parent().get_parent().get_child(0)


# Called when the node enters the scene tree for the first time.
func _ready():
	value = player.health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player != null:
		value = player.health
		if value < 100:
			show()
			if value <= 0:
				value = 0
		
		elif value >= 100:
			hide()
			value = 100

