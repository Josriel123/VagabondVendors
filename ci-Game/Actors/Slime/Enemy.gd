extends CharacterBody2D

var speed = 85
var lower_speed = 35
var player_chase = false
var player = null
var dead = false
var animal = null
var animal_chase= false
var health = 100
var player_inAttack_range = false
var attacking = false
var slime_attack_cooldown = true

@onready var tile_map = get_parent()
@onready var sprite = $AnimatedSprite2D as Sprite2D
@onready var detection_mask = $DetectionArea as Area2D
@onready var hit_box = $HitBox as Area2D
@onready var health_bar = $HealthBar as ProgressBar
@onready var slime_walking = $slimeWalking


var is_slope_custom_data = "is_slope"
var is_tile_custom_data = "is_tile"
var is_water_custom_data ="is_water"

var first_floor = false
var second_floor = false
var third_floor = false
var fourth_floor = false
var fifth_floor = false
var sixth_floor = false

var isbSlope = false
var iscSlope = false
var isWater = false

var sprite_size

@export var slime = InvItem



func _ready():
	dead = false
	collision_mask = 128
	hit_box.collision_mask = 127
	detection_mask.collision_mask = 127
	health_bar.value = 100
	z_index = 7
	

func _physics_process(delta):
	floors()
	take_damage()
	attack()
	
	health_bar.value = health
	
	var player_bottom_position : Vector2i = global_position 
	
	first_floor = is_on_first_floor(player_bottom_position)
	second_floor = is_on_second_floor(player_bottom_position)
	third_floor = is_on_third_floor(player_bottom_position)
	fourth_floor = is_on_fourth_floor(player_bottom_position)
	fifth_floor = is_on_fifth_floor(player_bottom_position)
	sixth_floor = is_on_sixth_floor(player_bottom_position)
	
	is_on_water(player_bottom_position)
	is_on_slope(player_bottom_position)
	slime_movement(delta)

func slime_movement(delta):
	if !dead:
		$DetectionArea/CollisionShape2D.disabled = false
		if player_chase or animal_chase:
			var direction
			if player_chase:
				direction = (player.global_position - global_position).normalized()
			elif animal_chase:
				direction = (animal.global_position - global_position).normalized()
			
			if player.global_position.distance_to(global_position) < 20 or player.global_position.distance_to(global_position) < 20:
				$AnimatedSprite2D.play("attack")
				slime_walking.stop()
				
			else:
				if isbSlope or isWater:
					global_position += direction * lower_speed * delta
					$AnimatedSprite2D.play("walking")
					
				else:
					global_position += direction * speed * delta
					$AnimatedSprite2D.play("walking")
				if !slime_walking.playing:
					slime_walking.play()
				
			if direction.x < 0:
					$AnimatedSprite2D.flip_h = true
			else:
					$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("idle")
			slime_walking.stop()
	else:
		$AnimatedSprite2D.play("death")
		slime_walking.stop()
	
	move_and_slide()

func floors():
	if first_floor:
		collision_layer = 1
		
	elif second_floor:
		collision_layer = 2
		
	elif third_floor:
		collision_layer = 3
		
	elif fourth_floor:
		collision_layer = 4
		
	elif fifth_floor:
		collision_layer = 5
		
	elif sixth_floor:
		collision_layer = 6

func is_on_water(player_bottom_position):
	var tile_player_bpos : Vector2i = tile_map.local_to_map(player_bottom_position)
	# Gets the data of the tile at a specific layer and tile position
	var tile_bdata : TileData = tile_map.get_cell_tile_data(0, tile_player_bpos)
	
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

func is_on_slope(player_bottom_position):
	# Gets the position of the at the players position (Bottom and Center)
	var tile_player_bpos : Vector2i = tile_map.local_to_map(player_bottom_position)
	#var tile_player_cpos : Vector2i = tile_map.local_to_map(player_center_position)
	
	# Gets the data of the tile at a specific layer and tile position
	var tile_bdata : TileData = tile_map.get_cell_tile_data(collision_layer, tile_player_bpos)
	#var tile_cdata : TileData = tile_map.get_cell_tile_data(collision_layer, tile_player_cpos)

	# Checks if there is any data at the tile at the feet of the player
	if tile_bdata:
		
		# Gets the custom metadata to check if the tile is a slope or not
		var is_bslope = tile_bdata.get_custom_data(is_slope_custom_data)
		
		# Checks if it is a slope
		if is_bslope:
			# Sets the global variable isbSlope to true
			isbSlope = true
			
	# Same process with the center of the character 
	#elif tile_cdata:

		#var is_cslope = tile_cdata.get_custom_data(is_slope_custom_data)
		#if is_cslope:
			#print("Center")
			#iscSlope = true
			
	else:
	
		# If not data, then there is no slope at character position
		isbSlope = false
		#iscSlope = false

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true
	elif body.is_in_group("Animals"):
		animal = body
		animal_chase = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		player_chase = false
	elif body.is_in_group("Animals"):
		animal = null
		animal_chase = false

func _on_hit_box_body_entered(body):
	if body.is_in_group("Player"):
		player_inAttack_range = true


func _on_hit_box_body_exited(body):
	if body.is_in_group("Player"):
		player_inAttack_range = false
		

func take_damage():
	if player_inAttack_range and player.attacking:
		health -= 25
		
		if health <= 0:
			health = 0
			dead = true
			$DeathAnimation.start()
			player.collect(slime)
			
func attack():
	if slime_attack_cooldown:
		attacking = true
		slime_attack_cooldown = false
		$DealDamageCooldown.start()
	else:
		attacking = false

func _on_deal_damage_cooldown_timeout():
	slime_attack_cooldown = true
	$DealDamageCooldown.stop()

func _on_death_animation_timeout():
	self.queue_free()
