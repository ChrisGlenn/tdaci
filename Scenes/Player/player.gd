extends CharacterBody2D
# PLAYER SCRIPT
# handles player input, movement, interaction, ect.
signal player_moved # custom player script signal
@onready var PLAYER_SPRITE = $AnimatedSprite2D
@onready var STEP_AUDIO = $Steps
@onready var RAY_UP = $Ray_UP
@onready var RAY_RIGHT = $Ray_RIGHT
@onready var RAY_DOWN = $Ray_DOWN
@onready var RAY_LEFT = $Ray_LEFT
@onready var tilemap : TileMapLayer = get_parent().get_node("Enviornment_Tiles") # for field of view algorithm
@export var move_timer_set : int = 20 # pause length between movement
@export var field_of_view : int = 30 # how many tiles the player can see ahead
var move_timer : int = 0 # paused time before player moves again
var map_position # holds the current player position on the map
var interactable # holds the interactable object once it comes into the area

func _ready():
	PLAYER_SPRITE.frame = Globals.frame # sync the animation frame to the global frame
	Globals.player_position = Vector2(global_position.x, global_position.y)
	# field of view additions
	if tilemap:
		map_position = tilemap.local_to_map(position)
	else:
		print("No tilemap set") # DEBUG???

func _process(delta):
	PLAYER_SPRITE.frame = Globals.frame # sync the animation frame to the global frame
	# functions
	player_input(delta)
	# updates
	Globals.player_position = Vector2(position.x, position.y)


func player_input(clock):
	# check for player input and update the game accordingly
	# PLAYER MOVEMENT
	# controls the player movement
	if Globals.can_move:
		if Input.is_action_pressed("ci_UP"):
			# move up
			if !RAY_UP.is_colliding():
				if move_timer < 1:
					STEP_AUDIO.play() # play the step sfx
					global_position.y -= 24 # move the player
					move_timer = move_timer_set # set the timer
					emit_signal("player_moved") # emit the signal that the player has moved
					Globals.player_moved = true # player has moved
			else:
				# PLAY BLOCK AUDIO
				pass
		if Input.is_action_pressed("ci_RIGHT"):
			# move right
			if !RAY_RIGHT.is_colliding():
				if move_timer < 1:
					STEP_AUDIO.play() # play the step sfx
					PLAYER_SPRITE.flip_h = true # flip the player sprite
					global_position.x += 16 # move the player
					move_timer = move_timer_set # set the timer
					emit_signal("player_moved") # emit the signal that the player has moved
					Globals.player_moved = true # player has moved
			else:
				# PLAY BLOCK AUDIO
				PLAYER_SPRITE.flip_h = true # flip the player sprite
		if Input.is_action_pressed("ci_DOWN"):
			# move down
			if !RAY_DOWN.is_colliding():
				if move_timer < 1:
					STEP_AUDIO.play() # play the step sfx
					global_position.y += 24 # move the player
					move_timer = move_timer_set # set the timer
					emit_signal("player_moved") # emit the signal that the player has moved
					Globals.player_moved = true # player has moved
			else:
				# PLAY BLOCK AUDIO
				pass
		if Input.is_action_pressed("ci_LEFT"):
			# move left
			if !RAY_LEFT.is_colliding():
				if move_timer < 1:
					STEP_AUDIO.play() # play the step sfx
					PLAYER_SPRITE.flip_h = false # return sprite H to default
					global_position.x -= 16 # move the player
					move_timer = move_timer_set # set the timer
					emit_signal("player_moved") # emit the signal that the player has moved
					Globals.player_moved = true # player has moved
			else:
				# PLAY BLOCK AUDIO
				PLAYER_SPRITE.flip_h = false # return sprite H to default
		if !Input.is_action_pressed("ci_RIGHT") and !Input.is_action_pressed("ci_LEFT") and !Input.is_action_pressed("ci_UP") and !Input.is_action_pressed("ci_DOWN"):
			if move_timer != 0: move_timer = 0 # reset the move timer if no direction input is pressed
		# movement timer
		if move_timer > 0:
			move_timer -= clock * Globals.timer_ctrl # decrement the timer
	# DEBUG
	if Input.is_action_just_pressed("ci_DEBUG"):
		print(global_position) # get current player position
	if Input.is_action_just_pressed("ci_END"):
		get_tree().quit() # exit the game

func hit(dmg : int):
	# the player has been hit
	Globals.player["hp"] -= dmg
	print("Player HP: ", Globals.player["hp"])