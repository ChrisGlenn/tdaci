extends Area2D
# THE RAT!!!
# THIS IS NOT A SEEKING ENEMY
# a template script for the overworld enemies that will just move to the player (or away)
# and initialize combat BUT if the player is too strong the enemy just dies and yields very low XP and no gold
@onready var tilemap : TileMapLayer = get_parent().get_parent().get_node("Enviornment_Tiles")
@onready var visibility_map : TileMapLayer = get_parent().get_parent().get_node("Visibility")
@onready var ANIM = $AnimatedSprite2D
@onready var RAY = $RayCast2D
@onready var ATB_BAR = $Combat_Stats/ProgressBar
@export_category("General")
@export var enemy_name : String = "ENEMY REF" # used to check against the unspawn checklist
@export var enemy_id : int = 0 # gets passed to the battleground to spawn the battler
@export var chase_steps : int = 10 # how many steps before checking if the player is still in field of view
@export var movement_inc : float = 50.0 # increment time between space movement
@export var enemy_level_range : int = 2 # around the level the player should be when facing this enemy
@export var flee_to : Vector2 # the position the enemy will flee too if the player is too strong
# combat stats
@export_category("Combat")
@export var hit_points : int = 6 # the rat's hit pints
@export var enemy_str : int = 8 # the rat's strength stat
@export var enemy_str_mod : int = 1 # 8 = 3
@export var enemy_agi : int = 8 # the rat's agility stat
@export var enemy_agi_mod : int = 1 # 8 = 1
@export var agility_mod : int = 0 # the rat's agility mod
@export var enemy_weapon : int = 2 # unarmed rat
@export var enemy_weapon_penalty : int = 0 # no penalty
# pathfinding
var STATE = "IDLE" # IDLE ALERTED ENGAGED PANICKED FOILED COMBAT and DEAD!
var astar_grid : AStarGrid2D
var current_path : Array = [] # the current path to the player
var paths : Array = [0,0,0] # check if a path has been generated [ENGAGED, PANICKED, FOILED]
# misc
var starting_pos : Vector2
var run_level : int = 99 # the level at which the enemy will run from the player
var player_out_of_range : bool = false # if the player has fled the enemy
var current_chase_steps : int = 0 # counts the current steps
var movement_rec # records the movement_inc timer
var combat_target # holds the player
var combat_target_ac # holds the target's armor class
var combat_timer : int = 0 # how long a combat round takes
var current_atb : float = 100.0 # the current atb 
var enemy_atb : float = 100.0 # max ATB


func _ready() -> void:
	# check if this enemy should be here or not
	if Globals.cleared_levels[Globals.current_level] == 1:
		queue_free() # the current level is clear so move out!
	# start enemy ready
	starting_pos = Vector2(global_position.x, global_position.y) # in case the enemy needs to return
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
	if ANIM.animation == "default":	
		ANIM.frame = Globals.frame # set the animation frame
	# Enemy AI 2.0
	enemy_ai(delta)


func enemy_ai(clock) -> void:
	# updates
	ATB_BAR.value = current_atb # set the atb bar
	# slowly bring the ATB back up
	if current_atb < enemy_atb:
		current_atb += Globals.timer_thirty * clock
	else:
		current_atb = enemy_atb # stop it from going over
	# check the states
	if STATE == "IDLE":
		paths = [0,0,0] # reset the paths
		# just stay still basically...
		if movement_inc != 0: movement_inc = 0 # set the movement increment to 0 to remove pause before chasing player
	elif STATE == "ALERTED":
		# move the raycast target to the player and search for a hit
		# if there is a direct LOS to the player then move to engage
		RAY.target_position = to_local(Globals.player_position) # set the ray to the player
		if RAY.is_colliding():
			# check the collider and if it's the player then engage!!! 
			# or panic and run away
			var collider = RAY.get_collider()
			if collider.is_in_group("PLAYER"):
				if Globals.player["level"] >= run_level:
					current_path.clear() # remove current path
					STATE = "PANICKED" # change the state to panicked
				else:
					STATE = "ENGAGED" # change the state to engaged
	elif STATE == "ENGAGED":
		# chase the player
		# get the path to the player
		paths[1] = 0 # reset path
		paths[2] = 0 # reset path
		if paths[0] == 0:
			# get the astar path
			var id_path = astar_grid.get_id_path(
			tilemap.local_to_map(self.global_position),
			tilemap.local_to_map(Globals.player_position)
			).slice(1) # remove the enemies current position
			current_path = id_path # set the current_path and start moving
			paths[0] = 1 # the path has been set
		else:
			# update the current_path if the player has moved
			if Globals.player_moved:
				var id_path = astar_grid.get_id_path(
				tilemap.local_to_map(self.global_position),
				tilemap.local_to_map(Globals.player_position)
				).slice(1) # remove the enemies current position
				current_path = id_path # set the current_path and start moving
			if Globals.can_move:
				# move towards the player!!!
				if movement_inc > 0:
					movement_inc -= Globals.timer_ctrl * clock # decrement timer
				else:
					# check if the path still has any values left and then move if so
					if current_path.size() > 0:
						var target_position = tilemap.map_to_local(current_path.front()) # get the target position
						if target_position.x > global_position.x: ANIM.flip_h = true # flip if moving right
						elif target_position.x < global_position.x: ANIM.flip_h = false # unflip if moving left
						self.global_position = Vector2(target_position.x - 8, target_position.y - 12) # move the enemy to the position
						current_path.pop_front() # remove the current target position
						current_chase_steps += 1 # increment current chase steps
						movement_inc = movement_rec # reset the timer
			# count the enemy steps and if they are maxed check if the player is still inside of the
			# engagement area and if so then reset and continue, otherwise move on
			if current_chase_steps >= chase_steps:
				RAY.target_position = to_local(Globals.player_position) # set the ray to the player
				if RAY.is_colliding():
					# check the collider and if it's the player then engage!!! 
					# or panic and run away
					var collider = RAY.get_collider()
					if collider.is_in_group("PLAYER"):
						current_chase_steps = 0 # reset the chase steps
					else:
						current_chase_steps = 0 # reset the chase steps
						STATE = "FOILED" # the player has evaded the enemy
	elif STATE == "PANICKED":
		# run off towards a set flee to point
		paths[0] = 0 # reset path
		paths[2] = 0 # reset path
		if paths[1] == 0:
			# get the astar path to the flee position
			var id_path = astar_grid.get_id_path(
			tilemap.local_to_map(self.global_position),
			tilemap.local_to_map(flee_to)
			).slice(1) # remove the enemies current position
			current_path = id_path # set the current_path and start moving
			paths[1] = 1 # path is set
		else:
			# escape!!!
			if Globals.can_move:
				if movement_inc > 0:
					movement_inc -= Globals.timer_ctrl * clock # decrement timer
				else:
					# check if the path still has any values left and then move if so
					if current_path.size() > 0:
						var target_position = tilemap.map_to_local(current_path.front()) # get the target position
						if target_position.x > global_position.x: ANIM.flip_h = true # flip if moving right
						elif target_position.x < global_position.x: ANIM.flip_h = false # unflip if moving left
						self.global_position = Vector2(target_position.x - 8, target_position.y - 12) # move the enemy to the position
						current_path.pop_front() # remove the current target position
						current_chase_steps += 1 # increment current chase steps
						movement_inc = movement_rec # reset the timer
		# if the player is out of range then return to the start point
		if current_chase_steps == chase_steps:
			if player_out_of_range:
				current_chase_steps = 0
				STATE = "FOILED" # the player has evaded the enemy
			else:
				current_chase_steps = 0 # reset the current chase steps
	elif STATE == "FOILED":
		# the player has fled the enemy who will now wait until the timer runs out then return
		# to the starting area
		paths[0] = 0 # reset path
		paths[1] = 0 # reset path
		if paths[2] == 0:
			var id_path = astar_grid.get_id_path(
				tilemap.local_to_map(self.global_position),
				tilemap.local_to_map(starting_pos)
			).slice(1) # remove the enemies current position
			current_path = id_path # set the current_path
			paths[2] = 1
		else:
			# check to see if the player is back in the enemies area of alertness
			# and if so then resume the persuit IF NOT PANICKED
			if !player_out_of_range:
				RAY.target_position = to_local(Globals.player_position) # set the ray to the player
				if RAY.is_colliding():
					# check the collider and if it's the player then engage!!! 
					# or panic and run away
					var collider = RAY.get_collider()
					if collider.is_in_group("PLAYER"):
						if Globals.player["level"] >= run_level:
							current_path.clear() # remove current path
							STATE = "PANICKED" # change the state to panicked
						else:
							STATE = "ENGAGED" # change the state to engaged
		# move back towards the starting position
		if Globals.can_move:
			if movement_inc > 0:
				movement_inc -= Globals.timer_ctrl * clock # decrement timer
			else:
				# check if the path still has any values left and then move if so
				if current_path.size() > 0:
					var target_position = tilemap.map_to_local(current_path.front()) # get the target position
					self.global_position = Vector2(target_position.x - 8, target_position.y - 12) # move the enemy to the position
					if target_position.x > global_position.x: ANIM.flip_h = true # flip if moving right
					elif target_position.x < global_position.x: ANIM.flip_h = false # unflip if moving left
					current_path.pop_front() # remove the current target position
					movement_inc = movement_rec # reset the timer
		if global_position == starting_pos:
			STATE = "IDLE" # return to idle state
	elif STATE == "COMBAT":
		# begin attacking the player when the ATB is full
		if current_chase_steps > 0: current_chase_steps = 0 # reset the chase steps
		if current_atb == enemy_atb:
			attack() # attack the player
		if combat_timer > 0:
			ANIM.play("attack") # play the attack animation
			combat_timer -= Globals.timer_ctrl * clock
		else:
			combat_timer = 0 # set at 0
			ANIM.play("default") # return to default animation
	elif STATE == "DEAD":
		# PLAY THE SFX
		queue_free() # just delete self for now DEBUG
	# CHECK IF THE ENEMY IS IN A SHADED/BLACKED OUT TILE AND THEN HIDE
	var current_tile = visibility_map.local_to_map(global_position)
	if visibility_map.get_cell_source_id(current_tile) == 1:
		visible = false # hide enemy
	else:
		visible = true # show the enemy

func attack():
	# attack the player
	# this enemy is a simple melee fighter so it will just attack
	var did_hit = Functions.melee_hit(enemy_agi_mod, (Globals.player["AC"] + Globals.player["END_MOD"]))
	if did_hit == "HIT":
		var attack_dmg = Functions.attack_dmg(false, enemy_weapon, enemy_str_mod, enemy_weapon_penalty, Globals.player["AC"]) 
		Globals.update_terminal(str("> You've taken: ", attack_dmg, " damage!\n"))
		combat_target.hit(attack_dmg)
	elif did_hit == "CRIT":
		var attack_dmg = Functions.attack_dmg(true, enemy_weapon, enemy_str_mod, 0, Globals.player["AC"]) 
		Globals.update_terminal(str("> CRITICAL! You've taken: ", attack_dmg, " damage!\n"))
		combat_target.hit(attack_dmg)
	else:
		Globals.update_terminal("> Rat MISSED!\n")
	current_atb = 0
	combat_timer = Globals.timer_thirty

func hit(dmg : int):
	# the enemy has been hit
	hit_points -= dmg
	if hit_points >= 0: 
		# reward the player and then die
		STATE = "DEAD" # the rat is dead


func _on_visibility_body_entered(body:Node2D) -> void:
	if body.is_in_group("PLAYER") and STATE != "DEAD":
		if STATE == "IDLE": STATE = "ALERTED" # change the enemy state to alerted upon first entering
		player_out_of_range = false # the player is NOT out of range

func _on_visibility_body_exited(body:Node2D) -> void:
	if body.is_in_group("PLAYER") and STATE != "DEAD":
		player_out_of_range = true # the player has fled

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		# check if the player is too powerful and just die or start the battle!
		combat_target = body # set the combat_target
		STATE = "COMBAT" # start combat

func _on_body_exited(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		# check if the player is too powerful and just die or start the battle!
		combat_target = null # reset the combat_target to null
		STATE = "ENGAGED" # start chase after the player
