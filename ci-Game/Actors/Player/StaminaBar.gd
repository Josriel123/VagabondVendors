extends ProgressBar

@onready var character_body_2d = get_parent().get_parent().get_child(0)


# Called when the node enters the scene tree for the first time.
func _ready():
	value = 100

	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if character_body_2d != null:
		if character_body_2d.cart.state == "unmounted":
			if Input.is_action_pressed("Shift") and value >= 0 and character_body_2d.input != Vector2.ZERO:
				show()
				value -= 10*delta
		
			else:
				if value <= 100:
					if value <= 50:
						value += 7*delta
					else:
						value += 13*delta
				
			if value == 100:
				hide()
		elif character_body_2d.cart.state == "mounted":
			if value <= 100:
					if value <= 50:
						value += 7*delta
					else:
						value += 13*delta
				
		if value == 100:
			hide()

