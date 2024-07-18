extends TileMap 

#Setting the Maps Variables
var altitude = FastNoiseLite.new()
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()

var altMultiplier = 10

var width = 500
var height = 500

#Tile Set
const grassSet = 4
const specialSet = 5
#const grassNoTextureSet = 3
#const grassAlternateSet = 2

const water = Vector2i(3, 1)
const townFoundation = Vector2i(2, 1)

# Bleached Grass
const bleachedGrass = Vector2i(4, 0)
const bleachedGrassSlopeLeftUp = Vector2i(0, 0)
const bleachedGrassSlopeRightUp = Vector2i(1, 0)
const bleachedGrassSlopeLeftDown = Vector2i(2, 0)
const bleachedGrassSlopeRightDown = Vector2i(3, 0)

# Bright Grass
const brightGrass = Vector2i(4, 1)
const brightGrassSlopeLeftUp = Vector2i(0, 1)
const brightGrassSlopeRightUp = Vector2i(1, 1)
const brightGrassSlopeLeftDown = Vector2i(2, 1)
const brightGrassSlopeRightDown = Vector2i(3, 1)

# Light Grass
const lightGrass = Vector2i(4, 2)
const lightGrassSlopeLeftUp = Vector2i(0, 2)
const lightGrassSlopeRightUp = Vector2i(1, 2)
const lightGrassSlopeLeftDown = Vector2i(2, 2)
const lightGrassSlopeRightDown = Vector2i(3, 2)

# Grass
const grass = Vector2i(4, 3)
const grassSlopeLeftUp = Vector2i(0, 3)
const grassSlopeRightUp = Vector2i(1, 3)
const grassSlopeLeftDown = Vector2i(2, 3)
const grassSlopeRightDown = Vector2i(3, 3)

# Dark Grass
const darkGrass = Vector2i(4, 4)
const darkGrassSlopeLeftUp = Vector2i(0, 4)
const darkGrassSlopeRightUp = Vector2i(1, 4)
const darkGrassSlopeLeftDown = Vector2i(2, 4)
const darkGrassSlopeRightDown = Vector2i(3, 4)

# Deep Dark Grass
const deepDarkGrass = Vector2i(4, 5)
const deepDarkGrassSlopeLeftUp = Vector2i(0, 5)
const deepDarkGrassSlopeRightUp = Vector2i(1, 5)
const deepDarkGrassSlopeLeftDown = Vector2i(2, 5)
const deepDarkGrassSlopeRightDown = Vector2i(3, 5)

var existingTownHalls = []

enum layers {
	level0 = 0,
	level1 = 1,
	level2 = 2,
	level3 = 3,
	level4 = 4,
	level5 = 5,
	level6 = 6, 
}

func _ready(): 
	altitude.seed = randi()
	altitude.frequency = 0.01
	altitude.noise_type = FastNoiseLite.TYPE_PERLIN  
	altitude.cellular_distance_function = 15
	mapGeneration()
	addSlope()
	addRock()
	addGrass()
	addTree()
	addWater()
	addSheep()
	addSlime()
	addTownHall(existingTownHalls)
	addCart()


func mapGeneration():
	for y in range(height):
		for x in range(width):
			var alt = altitude.get_noise_2d(x, y) * altMultiplier
			var layerLevel = getLayerLevel(alt)
			set_cell(layerLevel, Vector2i(2 + x, 2 + y), grassSet, getTile(layerLevel))

func getLayerLevel(alt):
	if alt < 1:
		return layers.level0
	elif alt < 2:
		return layers.level1 
	elif alt < 3:
		return layers.level2
	elif alt < 4:
		return layers.level3
	elif alt < 5:
		return layers.level4
	elif alt < 6:
		return layers.level5
	else:
		return layers.level6

func getTile(layerLevel):
	match layerLevel:
		layers.level0:
			return deepDarkGrass
		layers.level1:
			return darkGrass 
		layers.level2:
			return grass
		layers.level3:
			return lightGrass
		layers.level4: 
			return brightGrass
		layers.level5:
			return bleachedGrass
		layers.level6:
			return bleachedGrass

func addSlope():
	for y in range(height):
		for x in range(width):
			var centerAlt = altitude.get_noise_2d(x, y) * altMultiplier
			var centerLayer = getLayerLevel(centerAlt)
			# Check neighboring tiles for slope addition
			for dy in range(-1, 2):
				for dx in range(-1, 2):
					if dx != 0 or dy != 0:  # Skip the center tile
						var ny = y + dy
						var nx = x + dx
						if nx >= 0 and nx < width and ny >= 0 and ny < height:
							var neighborAlt = altitude.get_noise_2d(nx, ny) * altMultiplier
							var neighborLayer = getLayerLevel(neighborAlt)
							# Check if slope needs to be added
							if centerLayer > neighborLayer:
								if centerLayer == 1: 
									if dx == 1 and dy == 0:  # Right
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, darkGrassSlopeRightUp)
									elif dx == 0 and dy == 1:  # Down
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, darkGrassSlopeLeftUp)
									elif dx == -1 and dy == 0:  # Left
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, darkGrassSlopeLeftDown)
									elif dx == 0 and dy == -1:  # Up
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, darkGrassSlopeRightDown)
								elif centerLayer == 2: 
									if dx == 1 and dy == 0:  # Right
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, grassSlopeRightUp)
									elif dx == 0 and dy == 1:  # Down
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, grassSlopeLeftUp)
									elif dx == -1 and dy == 0:  # Left
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, grassSlopeLeftDown)
									elif dx == 0 and dy == -1:  # Up
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, grassSlopeRightDown)
								elif centerLayer == 3: 
									if dx == 1 and dy == 0:  # Right
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, lightGrassSlopeRightUp)
									elif dx == 0 and dy == 1:  # Down
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, lightGrassSlopeLeftUp)
									elif dx == -1 and dy == 0:  # Left
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, lightGrassSlopeLeftDown)
									elif dx == 0 and dy == -1:  # Up
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, lightGrassSlopeRightDown)
								elif centerLayer == 4: 
									if dx == 1 and dy == 0:  # Right
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, brightGrassSlopeRightUp)
									elif dx == 0 and dy == 1:  # Down
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, brightGrassSlopeLeftUp)
									elif dx == -1 and dy == 0:  # Left
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, brightGrassSlopeLeftDown)
									elif dx == 0 and dy == -1:  # Up
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, brightGrassSlopeRightDown)
								elif centerLayer == 5: 
									if dx == 1 and dy == 0:  # Right
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, bleachedGrassSlopeRightUp)
									elif dx == 0 and dy == 1:  # Down
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, bleachedGrassSlopeLeftUp)
									elif dx == -1 and dy == 0:  # Left
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, bleachedGrassSlopeLeftDown)
									elif dx == 0 and dy == -1:  # Up
										set_cell(centerLayer, Vector2i(2 + nx, 2 + ny), grassSet, bleachedGrassSlopeRightDown)

func addRock():
	# Setting the probability of rock spawning
	var rockSpawnChance = 0.0005
	# Loading the rock scene
	var rockScene = preload("res://Worlds/Objects/Rocks/rocks.tscn")
	# Tile size, adjust according to your tile size
	var tile_size = Vector2(32, 16) # Adjusted for isometric tile map

	# Iterating over each tile
	for y in range(height): 
		for x in range(width):
			# Getting the altitude value for the current tile
			var alt = altitude.get_noise_2d(x, y) * altMultiplier

			# Calculating the world position of the tile in isometric coordinates
			var iso_x = (x - y) * (tile_size.x / 2)
			var iso_y = (x + y) * (tile_size.y / 2)
			var world_position = Vector2(iso_x, iso_y)

			# Check if a rock should spawn on this tile
			if randf() < rockSpawnChance * (1 - alt / altMultiplier):
				spawnRock(rockScene, world_position)

func spawnRock(rockScene, position):
	# Instantiating the rock scene
	var rockInstance = rockScene.instantiate()
	# Setting the global position of the rock instance
	rockInstance.global_transform.origin = position
	# Adding the rock instance to the scene
	add_child(rockInstance)

func addTree():
	var treeSpawnChance = 0.02
	var treeScene = preload("res://Worlds/Objects/Trees/trees.tscn")
	var tile_size = Vector2(32, 16)
	for y in range(height): 
		for x in range(width): 
			var moistureLevel = moisture.get_noise_2d(x, y) * 15
			var alt = altitude.get_noise_2d(x, y) * altMultiplier
			if moistureLevel > 1 and moistureLevel < 3 :
				if randf() < treeSpawnChance * (1 - alt / altMultiplier):
					var iso_x = (x - y) * (tile_size.x / 2)
					var iso_y = (x + y) * (tile_size.y / 2)
					var world_position = Vector2(iso_x, iso_y)
					var treeInstance = treeScene.instantiate()
					treeInstance.global_transform.origin = world_position
					add_child(treeInstance)

func addGrass():
	# Setting the probability of rock spawning
	var grassSpawnChance = 0.05
	# Loading the rock scene
	var grassScene = preload("res://Worlds/Objects/Grass/grass.tscn")
	var grassScene2 = preload("res://Worlds/Objects/Grass/grass2.tscn")
	var grassScene3 = preload("res://Worlds/Objects/Grass/grass3.tscn")
	# Tile size, adjust according to your tile size
	var tile_size = Vector2(32, 16) # Adjusted for isometric tile map

	# Iterating over each tile
	for y in range(height): 
		for x in range(width):
			var moistureLevel = moisture.get_noise_2d(x, y) * 15
			var alt = altitude.get_noise_2d(x, y) * altMultiplier
			if randf() < grassSpawnChance * (1 - alt / altMultiplier) and moistureLevel < 6 :
				var iso_x = (x - y) * (tile_size.x / 2)
				var iso_y = (x + y) * (tile_size.y / 2)
				var world_position = Vector2(iso_x, iso_y)
				var grassInstance = null 
				if alt <= 1: 
					grassInstance = grassScene.instantiate()
				elif alt <= 2: 
					grassInstance = grassScene2.instantiate()
				elif alt <= 3: 
					grassInstance = grassScene3.instantiate()
				else: 
					grassInstance = grassScene.instantiate()
				grassInstance.global_transform.origin = world_position
				grassInstance.z_index = alt + 1 
				add_child(grassInstance)

func zIndexAdjust(alt): 
	if alt == 1:
		return 1
	elif alt == 2:
		return 2
	elif alt == 3:
		return 3
	elif alt == 4:
		return 4
	elif alt == 5:
		return 5
	elif alt == 6: 
		return 6 
 
func addWater():
	for y in range(height):
		for x in range(width): 
			var moistureLevel = moisture.get_noise_2d(x, y) * 15
			if moistureLevel > 7:
				set_cell(layers.level0, Vector2i(2 + x, 2 + y), specialSet, water)

func addSheep():
	# Setting the probability of rock spawning
	var sheepSpawnChance = 0.0002
	# Loading the rock scene
	var sheepScene = preload("res://Actors/sheep/New Sheep.tscn")
	# Tile size, adjust according to your tile size
	var tile_size = Vector2(32, 16) # Adjusted for isometric tile map

	# Iterating over each tile
	for y in range(height): 
		for x in range(width):
			var moistureLevel = moisture.get_noise_2d(x, y) * 15
			var alt = altitude.get_noise_2d(x, y) * altMultiplier
			if randf() < sheepSpawnChance * (1 - alt / altMultiplier) and moistureLevel < 6 :
				var iso_x = (x - y) * (tile_size.x / 2)
				var iso_y = (x + y) * (tile_size.y / 2)
				var world_position = Vector2(iso_x, iso_y)
				var sheepInstance = sheepScene.instantiate()
				sheepInstance.global_transform.origin = world_position
				add_child(sheepInstance)

func addSlime():
	# Setting the probability of rock spawning
	var slimeSpawnChance = 0.0002
	# Loading the rock scene
	var slimeScene = preload("res://Actors/Slime/enemy.tscn")
	# Tile size, adjust according to your tile size
	var tile_size = Vector2(32, 16) # Adjusted for isometric tile map

	# Iterating over each tile
	for y in range(height): 
		for x in range(width):
			var moistureLevel = moisture.get_noise_2d(x, y) * 15
			var alt = altitude.get_noise_2d(x, y) * altMultiplier
			if randf() < slimeSpawnChance * (1 - alt / altMultiplier) and moistureLevel < 6 :
				var iso_x = (x - y) * (tile_size.x / 2)
				var iso_y = (x + y) * (tile_size.y / 2)
				var world_position = Vector2(iso_x, iso_y)
				var slimeInstance = slimeScene.instantiate()
				slimeInstance.global_transform.origin = world_position
				add_child(slimeInstance)
				
func addTownHall(existingTownHalls):
	var townHallScene = preload("res://Worlds/Towns/Town Hall.tscn")
	var townHallChance = 0.1
	var minDistance = 1000  # Minimum distance between town halls
	var tile_size = Vector2(32, 16)
	for y in range(height):
		for x in range(width):
			var alt = altitude.get_noise_2d(x, y) * altMultiplier
			if randf() < townHallChance * (1 - alt / altMultiplier) and getLayerLevel(alt) == 4:
				var iso_x = (x - y) * (tile_size.x / 2)
				var iso_y = (x + y) * (tile_size.y / 2)
				var world_position = Vector2(iso_x, iso_y)
				if isPositionValid(world_position, existingTownHalls, minDistance):
					var townHallInstance = townHallScene.instantiate()
					townHallInstance.global_transform.origin = world_position
					add_child(townHallInstance)
					existingTownHalls.append(world_position)

func isPositionValid(position, existingTownHalls, minDistance):
	for townHallPos in existingTownHalls:
		var distance = position.distance_to(townHallPos)
		if distance < minDistance:
			return false
	return true

func addCart(): 
	var cartScene = preload("res://Actors/Cart/Cart.tscn")
	var cartInstance = cartScene.instantiate()
	add_child(cartInstance)

