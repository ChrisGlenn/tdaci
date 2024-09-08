extends Node
# OVERWORLD(MAP) ENEMY
# a template script for the overworld enemies that will just move to the player (or away)
# and initialize combat
@onready var tilemap : TileMapLayer = get_parent().get_parent().get_node("Enviornment_Tiles")
@onready var ANIM = $AnimatedSprite2D
@export_group("Enemy Attributes")
@export var enemy_name : String = "" # name of the enemy
@export var movement_inc : float = 60 # increment time between space movement
var player_spotted : bool = false # if true the player has been spotted (default is false)
# pathfinding
var astar_grid : AStarGrid2D
var current_path : Array = [] # the current path to the player
# misc
var movement_rec # records the movement_inc timer


func _ready() -> void:
	movement_rec = movement_inc # record the movement_inc timer
	# pathfinding setup
	astar_grid = AStarGrid2D.new() # instance new astargrid2d
	astar_grid.region = tilemap.get_used_rect() # returns a rectangle enclosing the used (non-empty) tiles of the map
	astar_grid.cell_size = Vector2(16, 24) # set the cell size for the tiles
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER # disable any diagonal movement
	astar_grid.update() # update the grid
	# disabling tiles
	for x in tilemap.get_used_rect().size.x:
		for y in tilemap.get_used_rect().size.y:
			# iterate through the tiles starting with the top most left tile
			var tile_position = Vector2i(
				x + tilemap.get_used_rect().position.x, 
				y + tilemap.get_used_rect().position.y
			) # get current tile position
			var tile_data = tilemap.get_cell_tile_data(tile_position)
			if !tile_data or !tile_data.get_custom_data("navigation"):
				astar_grid.set_point_solid(tile_position) # set the 

func _process(delta: float) -> void:
	# animation
	ANIM.frame = Globals.frame # set the animation frame
	# pathfinding
	if player_spotted:
		if current_path.is_empty():
			var id_path = astar_grid.get_id_path(
				tilemap.local_to_map(self.global_position),
				tilemap.local_to_map(Globals.player_position)
			).slice(1) # remove the enemies current position
			current_path = id_path
			player_spotted = false
		else:
			if !current_path.is_empty():
				# move towards the player!!!
				if movement_inc > 0:
					movement_inc -= Globals.timer_ctrl * delta # decrement timer
				else:
					var target_position = tilemap.map_to_local(current_path.front()) # get the target position
					self.global_position = Vector2(target_position.x - 8, target_position.y - 12) # move the enemy to the position
					current_path.pop_front() # remove the current target position
					print(current_path)
					movement_inc = movement_rec # reset the timer
	# DEBUGGING DEBUGGING DEBUGGING
	if Input.is_action_just_pressed("ci_A"):
		player_spotted = true # DEBUG
