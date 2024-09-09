extends Node
# OVERWORLD(MAP) ENEMY
# a template script for the overworld enemies that will just move to the player (or away)
# and initialize combat
@onready var tilemap : TileMapLayer = get_parent().get_parent().get_node("Enviornment_Tiles")
@onready var ANIM = $AnimatedSprite2D
@onready var RAY = $RayCast2D
@export_group("Enemy Attributes")
@export var enemy_name : String = "MAP ENEMY" # name of the enemy
@export var seek_player : bool = false # if the enemy will seek after the player (higher level enemies)
@export var movement_inc : float = 40 # increment time between space movement
@export var enemy_level_range : int = 2 # around the level the player should be when facing this enemy
# pathfinding
var astar_grid : AStarGrid2D
var current_path : Array = [] # the current path to the player
# misc
var player_spotted : bool = false # if true the player has been spotted (default is false)
var run_level : int = 99 # the level at which the enemy will run from the player
var panicked : bool = false # if true the enemy will try run away
var player_out_of_range : bool = false # if the player has fled the enemy
var out_of_range_timer : int = 300 # how long before the player returns
var movement_rec # records the movement_inc timer


func _ready() -> void:
	movement_rec = movement_inc # record the movement_inc timer
	movement_inc = 0 # set the movement increment to 0 to remove pause before chasing player
	run_level = enemy_level_range + 6 # this will determine at what player_level this enemy will flee in terror
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
	if !panicked:
		# engage the player
		if player_spotted:
			# set the target position for the ray
			# check if it's hitting anything that isn't the player and if not then create a path and chase the player
			# needs to check if player is in the enemies line of sight...
			if current_path.is_empty():
				var id_path = astar_grid.get_id_path(
					tilemap.local_to_map(self.global_position),
					tilemap.local_to_map(Globals.player_position)
				).slice(1) # remove the enemies current position
				current_path = id_path
				# player_spotted = false
				print(current_path)
			else:
				# if the player moves then update the path
				pass
		else:
			if player_out_of_range:
				# count down the timer and if the player hasn't been found then return to the
				# original spot of the enemy IF they are not there to chase the player
				pass
	else:
		# the player is too high level
		pass
	enemy_movement(delta) # movement function


func enemy_movement(_clock: float) -> void:
	pass


func _on_visibility_body_entered(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		if Globals.player_level >= run_level: panicked = true
		player_spotted = true # the player has been spotted
		player_out_of_range = false # the player is NOT out of range
		print("Player has entered") # DEBUG

func _on_visibility_body_exited(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		player_spotted = false # the player is no longer spotted...or striped either har har
		player_out_of_range = true # the player has fled
		print("Player has exited") # DEBUG


	# if !current_path.is_empty():
	# 	# move towards the player!!!
	# 	if movement_inc > 0:
	# 		movement_inc -= Globals.timer_ctrl * delta # decrement timer
	# 	else:
	# 		var target_position = tilemap.map_to_local(current_path.front()) # get the target position
	# 		self.global_position = Vector2(target_position.x - 8, target_position.y - 12) # move the enemy to the position
	# 		current_path.pop_front() # remove the current target position
	# 		print(current_path)
	# 		movement_inc = movement_rec # reset the timer