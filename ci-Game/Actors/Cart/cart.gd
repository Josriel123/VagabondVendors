extends CharacterBody2D

# Reference to the player character
var player
var player_in_area = false
@onready var playerInv = get_parent().get_child(2).get_child(3)
@onready var cartInv = get_parent().get_child(2).get_child(2)
# Reference to the wagon
var wagon = null
var in_pos = false

# States: "unmounted", "mounted"
var state = "unmounted"
@onready var area_2d = $Sprite2D/Area2D

@export var inv: Inv

func _ready():
	collision_mask = 255
	if area_2d != null:
		area_2d.collision_mask = 255
	global_position = Vector2(0, 4000)
	z_index = 7
	collision_layer = 128

func _process(_delta):
	mount()

func mount():
	if state == "unmounted": 
		if player_in_area: 
			if Input.is_action_just_pressed("e") and !playerInv.is_open and !cartInv.is_open:
				state = "mounted"
				collision_layer = 0
	elif state == "mounted":
		if in_pos == false:
			in_pos = true
			player.global_position = Vector2(global_position.x + 15, global_position.y)
			
		global_position = Vector2(player.global_position.x - 15, player.global_position.y)
		if Input.is_action_just_pressed("e"):
			state = "unmounted"
			collision_layer = 128
			in_pos = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_in_area = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false
		
func collect(item):
	inv.insert(item)

func eat(item):
	if item == player.apple:
		inv.delete(item)
		player.health += 10
		player.eat_sound.play()

func transfer(item):
	if item != null:
		inv.delete(item)
		player.transfer_sound.play()
