extends Area2D
# THE RAT!!!
# a template script for the overworld enemies that will just move to the player (or away)
# and initialize combat BUT if the player is too strong the rat just dies and yields very low XP and no gold
@onready var tilemap : TileMapLayer = get_parent().get_parent().get_node("Enviornment_Tiles")
@onready var ANIM = $AnimatedSprite2D
@onready var RAY = $RayCast2D
@export_group("RAT-tributes")
@export var enemy_name : String = "MAP ENEMY" # name of the enemy
@export var seek_player : bool = false # if the enemy will seek after the player (higher level enemies)
@export var chase_steps : int = 10 # how many steps before checking if the player is still in field of view
@export var movement_inc : float = 50.0 # increment time between space movement
@export var enemy_level_range : int = 2 # around the level the player should be when facing this enemy
@export var flee_to : Vector2 # the position the enemy will flee too if the player is too strong
var STATE = "IDLE" # IDLE ALERTED ENGAGED PANICKED FOILED
# pathfinding
var astar_grid : AStarGrid2D
var current_path : Array = [] # the current path to the player
# misc
var starting_pos : Vector2
var run_level : int = 99 # the level at which the enemy will run from the player
var player_out_of_range : bool = false # if the player has fled the enemy
var out_of_range_timer : float = 300.0 # how long before the player returns
var current_chase_steps : int = 0 # counts the current steps
var oor_timer_rec # records out of range timer
var movement_rec # records the movement_inc timer


func _ready() -> void:
	starting_pos = Vector2(global_position.x, global_position.y) # in case the rat needs to return
	movement_rec = movement_inc # record the movement_inc timer
	movement_inc = 0 # set the movement increment to 0 to remove pause before chasing player
	oor_timer_rec = out_of_range_timer # record the out of range timer
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
	# Enemy AI 2.0
	enemy_ai(delta)

func enemy_ai(clock: float) -> void:
	# check the states
	if STATE == "IDLE":
		# just stay still basically...
		if movement_inc != 0: movement_inc = 0 # set the movement increment to 0 to remove pause before chasing player
		if out_of_range_timer != oor_timer_rec: out_of_range_timer = oor_timer_rec # reset the out of range timer
	elif STATE == "ALERTED":
		# move the raycast target to the player and search for a hit
		# if there is a direct LOS to the player then move to engage
		RAY.target_position = to_local(Globals.player_position) # set the ray to the player
		if RAY.is_colliding():
			# check the collider and if it's the player then engage!!! 
			# or panic and run away
			var collider = RAY.get_collider()
			if collider.is_in_group("PLAYER"):
				if Globals.player_level >= run_level:
					current_path.clear() # remove current path
					STATE = "PANICKED" # change the state to panicked
				else:
					STATE = "ENGAGED"
	elif STATE == "ENGAGED":
		# chase the player
		# get the path to the player
		if current_path.is_empty():
			# get the astar path
			var id_path = astar_grid.get_id_path(
			tilemap.local_to_map(self.global_position),
			tilemap.local_to_map(Globals.player_position)
			).slice(1) # remove the enemies current position
			current_path = id_path # set the current_path and start moving
		else:
			# update the current_path if the player has moved
			if Globals.player_moved:
				var id_path = astar_grid.get_id_path(
				tilemap.local_to_map(self.global_position),
				tilemap.local_to_map(Globals.player_position)
				).slice(1) # remove the enemies current position
				current_path = id_path # set the current_path and start moving
			# move towards the player!!!
			if movement_inc > 0:
				movement_inc -= Globals.timer_ctrl * clock # decrement timer
			else:
				var target_position = tilemap.map_to_local(current_path.front()) # get the target position
				if target_position.x > global_position.x: ANIM.flip_h = true # flip if moving right
				elif target_position.x < global_position.x: ANIM.flip_h = false # unflip if moving left
				self.global_position = Vector2(target_position.x - 8, target_position.y - 12) # move the enemy to the position
				current_path.pop_front() # remove the current target position
				current_chase_steps += 1 # increment current chase steps
				print(current_chase_steps)
				movement_inc = movement_rec # reset the timer
			# count the enemy steps and if they are maxed check if the player is still inside of the
			# engagement area and if so then reset and continue, otherwise move on
			if current_chase_steps == chase_steps:
				if player_out_of_range:
					current_chase_steps = 0
					STATE = "FOILED" # the player has evaded the enemy
				else:
					current_chase_steps = 0 # reset the current chase steps
	elif STATE == "PANICKED":
		# run off towards a set flee to point
		if current_path.is_empty():
			# get the astar path to the flee position
			var id_path = astar_grid.get_id_path(
			tilemap.local_to_map(self.global_position),
			tilemap.local_to_map(flee_to)
			).slice(1) # remove the enemies current position
			current_path = id_path # set the current_path and start moving
		else:
			# chase the player
			# move towards the player!!!
			if movement_inc > 0:
				movement_inc -= Globals.timer_ctrl * clock # decrement timer
			else:
				var target_position = tilemap.map_to_local(current_path.front()) # get the target position
				if target_position.x > global_position.x: ANIM.flip_h = true # flip if moving right
				elif target_position.x < global_position.x: ANIM.flip_h = false # unflip if moving left
				self.global_position = Vector2(target_position.x - 8, target_position.y - 12) # move the enemy to the position
				current_path.pop_front() # remove the current target position
				movement_inc = movement_rec # reset the timer
		if player_out_of_range:
			# if the player is out of range then return to the start point
			if out_of_range_timer > 0:
				print(out_of_range_timer)
				out_of_range_timer -= Globals.timer_ctrl * clock # decrement timer 
			else:
				STATE = "FOILED" # the player has successfully foiled the enemy
	elif STATE == "FOILED":
		# the player has fled the enemy who will now wait until the timer runs out then return
		# to the starting area
		var id_path = astar_grid.get_id_path(
			tilemap.local_to_map(self.global_position),
			tilemap.local_to_map(starting_pos)
		).slice(1) # remove the enemies current position
		current_path = id_path # set the current_path
		# move back towards the starting position
		if movement_inc > 0:
			movement_inc -= Globals.timer_ctrl * clock # decrement timer
		else:
			var target_position = tilemap.map_to_local(current_path.front()) # get the target position
			self.global_position = Vector2(target_position.x - 8, target_position.y - 12) # move the enemy to the position
			if target_position.x > global_position.x: ANIM.flip_h = true # flip if moving right
			elif target_position.x < global_position.x: ANIM.flip_h = false # unflip if moving left
			current_path.pop_front() # remove the current target position
			movement_inc = movement_rec # reset the timer
		if global_position == starting_pos:
			STATE = "IDLE" # return to idle state




func _on_visibility_body_entered(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		if STATE == "IDLE": STATE = "ALERTED" # change the enemy state to alerted upon first entering
		player_out_of_range = false # the player is NOT out of range
		print("Player has entered") # DEBUG

func _on_visibility_body_exited(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		player_out_of_range = true # the player has fled
		out_of_range_timer = oor_timer_rec # reset the out of range timer
		print("Player has exited") # DEBUG

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		# check if the player is too powerful and just die or start the battle!
		pass
