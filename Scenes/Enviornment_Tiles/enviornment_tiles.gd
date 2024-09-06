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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
