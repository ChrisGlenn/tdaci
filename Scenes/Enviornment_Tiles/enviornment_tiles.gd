extends TileMapLayer
var astar = AStarGrid2D.new() # pathfinding!!!


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# pathfinding setup
	var tilemaplayer_size = get_used_rect().end - get_used_rect().position # get the size of the tilemap
	var map_rect = Rect2i(Vector2i.ZERO, tilemaplayer_size) # convert tilemaplayer_size to rectangle
	var tile_size = tile_set.tile_size # get the tile size (16, 24)
	# set astar params
	astar.region = map_rect # assign the map rectangle to the astar.region
	astar.cell_size = tile_size # assign the cell size (tile_size)
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN # rectangular movement
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN # rectangular movement
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER # no diag movement
	astar.update()
	# iterate through the tileset and check for any 'walls'
	for i in tilemaplayer_size.x:
		for j in tilemaplayer_size.y:
			var coords = Vector2i(i, j) # get 'current' coords
			var tilemap_data = get_cell_tile_data(coords)
			if tilemap_data and tilemap_data.get_custom_data('type') == 'wall':
				astar.set_point_solid(coords) # set the wall as solid

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
