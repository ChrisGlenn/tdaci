extends CharacterBody2D
# PLAYER SCRIPT
# handles player input, movement, interaction, ect.
@onready var PLAYER_SPRITE = $AnimatedSprite2D
@onready var PLAYER_AUDIO = $AudioStreamPlayer
@onready var RAY_UP = $Ray_UP
@onready var RAY_RIGHT = $Ray_RIGHT
@onready var RAY_DOWN = $Ray_DOWN
@onready var RAY_LEFT = $Ray_LEFT


func _ready():
    PLAYER_SPRITE.frame = Globals.frame # sync the animation frame to the global frame

func _process(_delta):
    PLAYER_SPRITE.frame = Globals.frame # sync the animation frame to the global frame
    # functions
    player_input()
    # updates
    Globals.player_x = global_position.x # update player_x
    Globals.player_y = global_position.y # update player_y


func player_input():
    # check for player input and update the game accordingly
    # PLAYER MOVEMENT
    # controls the player movement
    if Globals.can_move:
        if Input.is_action_just_pressed("ci_UP"):
            # move up
            if !RAY_UP.is_colliding():
                global_position.y -= 24 # move up
                # PLAY STEP AUDIO HERE
            else:
                # PLAY BLOCK AUDIO HERE
                pass
        if Input.is_action_just_pressed("ci_RIGHT"):
            # move right
            if !RAY_RIGHT.is_colliding():
                global_position.x += 16 # move right
                PLAYER_SPRITE.flip_h = true # flip the sprite
                # PLAY STEP AUDIO HERE
            else:
                # PLAY BLOCK AUDIO HERE
                PLAYER_SPRITE.flip_h = true # flip the sprite
        if Input.is_action_just_pressed("ci_DOWN"):
            # move down
            if !RAY_DOWN.is_colliding():
                global_position.y += 24 # move down
                # PLAY STEP AUDIO HERE
            else:
                # PLAY BLOCK AUDIO HERE
                pass
        if Input.is_action_just_pressed("ci_LEFT"):
            # move left
            if !RAY_LEFT.is_colliding():
                global_position.x -= 16 # move left
                PLAYER_SPRITE.flip_h = false # un-flip the sprite
                # PLAY STEP AUDIO HERE
            else:
                # PLAY BLOCK AUDIO HERE
                PLAYER_SPRITE.flip_h = false # un-flip the sprite
    # DEBUG
    if Input.is_action_just_pressed("ci_END"):
        get_tree().quit() # exit the game