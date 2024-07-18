extends CharacterBody2D

var idle = false
var walking = false
var in_quest = false
var chatting = false
var in_quest_area = false
var player
var apples_collected 

@onready var tile_map = get_parent()
@onready var meee_sound = $MeeeSound



var xdir = 1 # 1 == right, -1 == left
var ydir = 1 # 1 == down, -1 == up
var speed = 20

var moving_vertical_horizontal = 1 # 1==x 2 == y

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



func _ready():
	walking = true
	randomize()
	collision_mask = 255
	z_index = 7
	

func _physics_process(_delta):
	floors()
	var player_bottom_position : Vector2i = global_position 
	
	first_floor = is_on_first_floor(player_bottom_position)
	second_floor = is_on_second_floor(player_bottom_position)
	third_floor = is_on_third_floor(player_bottom_position)
	fourth_floor = is_on_fourth_floor(player_bottom_position)
	fifth_floor = is_on_fifth_floor(player_bottom_position)
	sixth_floor = is_on_sixth_floor(player_bottom_position)
	
	is_on_water(player_bottom_position)
	is_on_slope(player_bottom_position)
	
	sheep_movement()
	
	

func sheep_movement():
	if walking == false:
		var x = randi_range(1,2)
		if x > 1.5:
			moving_vertical_horizontal = 1
		else:
			moving_vertical_horizontal = 2	
		
	if walking == true:
		if moving_vertical_horizontal == 1:
			if xdir == -1:
				$AnimatedSprite2D.play("walking_left")
				velocity.x = -speed
				velocity.y = 0
			if xdir == 1:
				$AnimatedSprite2D.play("walking_right")
				velocity.x = speed
				velocity.y = 0
			
			
		elif moving_vertical_horizontal == 2:
			if ydir == -1:
				$AnimatedSprite2D.play("walking_back")
				velocity.y = -speed
				velocity.x = 0
			if ydir == 1:
				$AnimatedSprite2D.play("walking_front")
				velocity.y = speed
				velocity.x = 0
		
	if idle == true:
		$AnimatedSprite2D.play("idle")
		velocity = Vector2.ZERO
		
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

func _on_changestate_timeout():
	var waittime = 1
	if walking == true:
		idle = true
		walking = false
		waittime = randi_range(1,5)
	
	elif idle == true:
		walking = true
		idle = false
		waittime = randi_range(2,6)
		$changestate.wait_time = waittime
		$changestate.start()

func _on_walking_timeout():
	var x = randi_range(1,2)
	var y = randi_range(1,2)
	var waittime = randi_range(1,4)
	
	if x > 1.5:
		xdir = 1 #right
	else:
		xdir = -1 #left
	if y > 1.5:
		ydir = 1
	else:
		ydir = -1
	$walkingtimer.wait_time = waittime
	$walkingtimer.start()

func _on_mee_timer_timeout():
	var waittime
	meee_sound.play()
	waittime = randi_range(30, 150)
	$MeeTimer.wait_time = waittime
	$MeeTimer.start()
