extends Node2D

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E,
				  Vector2(0, 1): S, Vector2(-1, 0): W}

var tile_size = 25	# in pixels (from TileMap
var currentLevel = 1 

var end = Vector2()
var powerUps = []
	
func _ready():
	randomize()
	make_maze()

# Returns array of unvisited neighbor cells
func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []
	var stack = []
	$MazeTiles.clear()
	$OverlayTiles.clear()
	powerUps.clear()
	
	currentLevel = get_parent().level
	var size = 3 + (2 * currentLevel) # in tiles
	
	# Fill map with solid tiles
	for x in range(size):
		for y in range(size):
			unvisited.append(Vector2(x, y))
			$MazeTiles.set_cellv(Vector2(x, y), N|E|S|W)	# N|E|S|W = 1111
	var current = Vector2(0, 0)
	unvisited.erase(current)
	
	# Recursive backtracker algorithm
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			
			# Remove wall between cells
			var dir = next - current	# direction moved in
			var current_walls = $MazeTiles.get_cellv(current) - cell_walls[dir]
			var next_walls = $MazeTiles.get_cellv(next) - cell_walls[-dir]
			$MazeTiles.set_cellv(current, current_walls)
			$MazeTiles.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			var randIfPower = randi() % 50 # 2% chance
			if randIfPower == 0:
				add_power(current)
			current = stack.pop_back()	# backtrack if no unvisited neighbors
	var start = stack[0] 
	$OverlayTiles.set_cellv(start, 0)
	
	# Make sure end isn't close to start
	var minSize = size/2
	var randIncrease = randi() % 2
	if randIncrease == 0:
		end = Vector2(randi() % size, (randi() % minSize) + minSize)
	if randIncrease == 1:
		end = Vector2((randi() % minSize) + minSize, randi() % size)
	$OverlayTiles.set_cellv(end, 1)

func get_tile_pos(position):
	var tile_pos = $OverlayTiles.world_to_map((position)/2)
	return tile_pos
	
func add_power(current_tile):
	var randPower = (randi() % 4) + 4
	$OverlayTiles.set_cellv(current_tile, randPower)
	powerUps.append(current_tile)

func get_power_type(tile):
	return $OverlayTiles.get_cellv(tile)
