extends CharacterBody2D

var enemy_inAttack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var attacking = false
var player_attack_cooldown = true
var enemy = []
var tree
var slimes_collected = 0
var cart_inv_area = false
var cart
var town_sheep 

const walk_speed = 80
const max_speed = 150
const accel = 500
const friction = 600

@onready var camera_2d = $Camera2D
@onready var animated_sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var tile_map = get_parent()
@onready var stamina_bar = get_parent().get_child(2).get_child(0)
@onready var hitbox = $Hitbox as Area2D
@onready var walking_sound = $WalkingSound
@onready var running_sound = $runningSound
@onready var water_sound = $waterSound
@onready var water_running_sound = $waterRunningSound
@onready var cart_sound = $cartSound
@onready var hurt_sound = $HurtSound
@onready var player_attack_sound = $PlayerAttackSound
@onready var blocking_sound = $BlockingSound
@onready var eat_sound = $EatSound
@onready var transfer_sound = $TransferSound


var input = Vector2.ZERO

var is_slope_custom_data = "is_slope"
var is_dryGrass_custom_data = "is_dryGrass"
var is_grass_custom_data = "is_grass"
var is_tile_custom_data = "is_tile"
var is_water_custom_data ="is_water"

var first_floor = false
var second_floor = false
var third_floor = false
var fourth_floor = false
var fifth_floor = false
var sixth_floor = false

var curr_layer

var isbSlope = false
var iscSlope = false
var isWater = false

var zoom_min = Vector2(1 , 1)
var zoom_max = Vector2(10, 10)

@export var inv: Inv
@export var apple: InvItem
@export var stick: InvItem
@export var slime: InvItem

var direction
var taking_damage = false


func _ready():
	collision_mask = 128
	hitbox.collision_mask = 255
	global_position = Vector2(0, 4000)
	

	

func _physics_process(delta):
	if Input.is_action_just_pressed("block"):
		slimes_collected += 1
	zoom()
	floors()
	if cart != null:
		if cart.state != "mounted":
			attack()
			take_damage()
	
	if health <= 0:
		get_tree().change_scene_to_file("res://Menus/Main Menu/Main Menu.tscn")

	player_movement(delta)
	
	var player_bottom_position : Vector2i = global_position
	
	first_floor = is_on_first_floor(player_bottom_position)
	second_floor = is_on_second_floor(player_bottom_position)
	third_floor = is_on_third_floor(player_bottom_position)
	fourth_floor = is_on_fourth_floor(player_bottom_position)
	fifth_floor = is_on_fifth_floor(player_bottom_position)
	sixth_floor = is_on_sixth_floor(player_bottom_position)
	
	is_on_water(player_bottom_position)
	is_on_slope(player_bottom_position)

func floors():
	if first_floor:
		curr_layer = 1
		collision_layer = 1
		z_index = 7
		
	elif second_floor:
		curr_layer = 2
		collision_layer = 2
		z_index = 7
		
	elif third_floor:
		curr_layer = 3
		collision_layer = 3
		z_index = 7
		
	elif fourth_floor:
		curr_layer = 4
		collision_layer = 4
		z_index = 7
		
	elif fifth_floor:
		curr_layer = 5
		collision_layer = 5
		z_index = 7
		
	elif sixth_floor:
		curr_layer = 6
		collision_layer = 6
		z_index = 7
		

func zoom():
	if Input.is_action_just_pressed("zoom_in") and camera_2d.zoom < zoom_max:
		if camera_2d.zoom < Vector2(4, 4):
			camera_2d.zoom += Vector2(.1, .1)
		elif camera_2d.zoom >= Vector2(4, 4):
			camera_2d.zoom += Vector2(.5, .5)
		

	elif Input.is_action_just_pressed("zoom_out") and camera_2d.zoom > zoom_min:
		if camera_2d.zoom < Vector2(4, 4):
			camera_2d.zoom -= Vector2(.1, .1)
		elif camera_2d.zoom >= Vector2(4, 4):
			camera_2d.zoom -= Vector2(.5, .5)
	

func getInput():
	input.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	input.y = int(Input.is_action_pressed("back")) - int(Input.is_action_pressed("foward"))
	return input.normalized()

func player_movement(delta):
	input = getInput()
	direction = input
	if cart == null or cart.state == "unmounted":
		cart_sound.stop()
		if input == Vector2.ZERO:
			if velocity.length() > (friction * delta):
				velocity -= velocity.normalized() * (friction * delta)
			else: 
				velocity = Vector2.ZERO
				if taking_damage == false or player_attack_cooldown == true:
					$AnimatedSprite2D.play("idle")
			walking_sound.stop()
			running_sound.stop()
			water_sound.stop()
			water_running_sound.stop()
		else:
			velocity += (input * accel * delta)
			if Input.is_action_pressed("Shift") and stamina_bar.value > 0:
				if isbSlope or iscSlope:
					velocity = velocity.limit_length(max_speed - 65)
					if !walking_sound.playing:
						running_sound.stop()
						water_sound.stop()
						water_running_sound.stop()
						walking_sound.play()
				elif isWater:
					velocity = velocity.limit_length(max_speed - 80)
					if !water_running_sound.playing:
						running_sound.stop()
						walking_sound.stop()
						water_sound.stop()
						water_running_sound.play()
				else:
					if !running_sound.playing:
						walking_sound.stop()
						water_sound.stop()
						water_running_sound.stop()
						running_sound.play()
					velocity = velocity.limit_length(max_speed)
				if taking_damage == false or player_attack_cooldown == true:
					if direction.x == -1:
						$AnimatedSprite2D.play("run_left")
					elif direction.x < 0 and direction.y < 0:
						$AnimatedSprite2D.play("run_left_back")
					elif direction.x > 0 and direction.y < 0:
						$AnimatedSprite2D.play("run_right_back")
					elif direction.y == 1:
						$AnimatedSprite2D.play("run_foward")
					elif direction.x == 1:
						$AnimatedSprite2D.play("run_right")
					elif direction.y == -1:
						$AnimatedSprite2D.play("run_back")
					
			else:
				if isbSlope or iscSlope:
					velocity = velocity.limit_length(walk_speed - 45)
				elif isWater:
					velocity = velocity.limit_length(walk_speed - 50)
					if !water_sound.playing:
						running_sound.stop()
						walking_sound.stop()
						water_running_sound.stop()
						water_sound.play()
				else:
					velocity = velocity.limit_length(walk_speed)
					if !walking_sound.playing:
						running_sound.stop()
						water_sound.stop()
						water_running_sound.stop()
						walking_sound.play()
				if taking_damage == false or player_attack_cooldown == true:
					if direction.x == -1:
						$AnimatedSprite2D.play("walk_left")
					elif direction.x < 0 and direction.y < 0:
						$AnimatedSprite2D.play("walk_left_back")
					elif direction.x > 0 and direction.y < 0:
						$AnimatedSprite2D.play("walk_right_back")
					elif direction.y == 1:
						$AnimatedSprite2D.play("walk_front")
					elif direction.x == 1:
						$AnimatedSprite2D.play("walk_right")
					elif direction.y == -1:
						$AnimatedSprite2D.play("walk_back")
	elif cart.state == "mounted":
		walking_sound.stop()
		running_sound.stop()
		water_sound.stop()
		water_running_sound.stop()
		if input == Vector2.ZERO:
			if velocity.length() > (friction * delta):
				velocity -= velocity.normalized() * (friction * delta)
				cart_sound.pitch_scale -= 0.02
			else: 
				velocity = Vector2.ZERO
				cart_sound.stop()

		else:
			velocity += (input * accel * delta)
			velocity = velocity.limit_length(max_speed + 80)
			if !cart_sound.playing:
				cart_sound.pitch_scale = 2
				cart_sound.play()
	move_and_slide()

func is_on_water(player_bottom_position):
	var tile_player_bpos : Vector2i = tile_map.local_to_map(player_bottom_position)
	# Gets the data of the tile at a specific layer and tile position
	var tile_bdata : TileData = tile_map.get_cell_tile_data(collision_layer - 1, tile_player_bpos)
	
	if tile_bdata:
		# Gets the custom metadata to check if the tile is a slope or not
		var is_water = tile_bdata.get_custom_data(is_water_custom_data)
		
		# Checks if it is a slope
		if is_water:
			
			# Sets the global variable isbSlope to true
			isWater = true
		else:
			isWater = false
			
	# Same process with the center of the character 
	
	else:
	
		# If not data, then there is no slope at character position
		isWater = false

func is_on_first_floor(player_position):
	var tile_player_pos : Vector2i = tile_map.local_to_map(player_position)
	var tile_data : TileData = tile_map.get_cell_tile_data(0, tile_player_pos)
	
	if tile_data:
		return true
	else:
		return false

func is_on_second_floor(player_position):
	var tile_player_pos : Vector2i = tile_map.local_to_map(player_position)
	var tile_data : TileData = tile_map.get_cell_tile_data(1, tile_player_pos)
	
	if tile_data:
		return true
	else:
		return false

func is_on_third_floor(player_position):
	var tile_player_pos : Vector2i = tile_map.local_to_map(player_position)
	var tile_data : TileData = tile_map.get_cell_tile_data(2, tile_player_pos)
	
	if tile_data:
		return true
	else:
		return false

func is_on_fourth_floor(player_position):
	var tile_player_pos : Vector2i = tile_map.local_to_map(player_position)
	var tile_data : TileData = tile_map.get_cell_tile_data(3, tile_player_pos)
	
	if tile_data:
		return true
	else:
		return false

func is_on_fifth_floor(player_position):
	var tile_player_pos : Vector2i = tile_map.local_to_map(player_position)
	var tile_data : TileData = tile_map.get_cell_tile_data(4, tile_player_pos)
	
	if tile_data:
		return true
	else:
		return false

func is_on_sixth_floor(player_position):
	var tile_player_pos : Vector2i = tile_map.local_to_map(player_position)
	var tile_data : TileData = tile_map.get_cell_tile_data(5, tile_player_pos)
	
	if tile_data:
		return true
	else:
		return false

# Detects if player is on a slope
func is_on_slope(player_bottom_position):
	# Gets the position of the at the players position (Bottom and Center)
	var tile_player_bpos : Vector2i = tile_map.local_to_map(player_bottom_position)
	
	# Gets the data of the tile at a specific layer and tile position
	var tile_bdata : TileData = tile_map.get_cell_tile_data(collision_layer, tile_player_bpos)

	# Checks if there is any data at the tile at the feet of the player
	if tile_bdata:
		# Gets the custom metadata to check if the tile is a slope or not
		var is_bslope = tile_bdata.get_custom_data(is_slope_custom_data)
		
		# Checks if it is a slope
		if is_bslope:
			# Sets the global variable isbSlope to true
			isbSlope = true
			
	else:
		# If not data, then there is no slope at character position

		isbSlope = false
	

func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemies"):
		enemy.append(body)
		enemy_inAttack_range = true
	if body.is_in_group("tree"):
		tree = body
	if body.is_in_group("Town Sheep"):
		town_sheep = body
	if body.is_in_group("Cart"):
		cart_inv_area = true
		cart = body


func _on_hitbox_body_exited(body):
	if body.is_in_group("Enemies"):
		var i = enemy.find(body)
		enemy.remove_at(i)
		enemy_inAttack_range = false
	if body.is_in_group("Cart"):
		cart_inv_area = false

func attack():
	if Input.is_action_just_pressed("attack") and player_attack_cooldown:
		attacking = true
		player_attack_cooldown = false
		$DealDamageCooldown.start()
		player_attack_sound.play()
	else:
		attacking = false

func _on_deal_damage_cooldown_timeout():
	player_attack_cooldown = true
	if direction.x >= 0:
		print("slashing right")
		$AnimatedSprite2D.play("slash_right")
	else:
		print("slashing left")
		$AnimatedSprite2D.play("slash_left")
	$DealDamageCooldown.stop()
	
func take_damage():
	# Checks if the user is blocking the attack
	if Input.is_action_pressed("block"):
		# loops through the enemy in range list
		for e in enemy:
			# Checks if the enemy is in attack range and if it is attacking
			if enemy_inAttack_range and e.attacking:
				health -= 10
				blocking_sound.play()
	else:
		# loops through the enemy in range list
		for e in enemy:
			# Checks if the enemy is in attack range and if it is attacking
			if enemy_inAttack_range and e.attacking:
				health -= 20
				hurt_sound.play()

func collect(item):
	inv.insert(item)
	if town_sheep != null:
		if town_sheep.sheep_quests.quest1_active and item == slime:#"<Resource#-9223372008484502278>":#apple
			slimes_collected += 1
	
func eat(item):
	if item == apple :#apple
		inv.delete(item)
		health += 10
		eat_sound.play()

func transfer(item):
	if item != null:
		inv.delete(item)
		transfer_sound.play()
