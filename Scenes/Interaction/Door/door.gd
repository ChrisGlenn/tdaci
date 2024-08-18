extends Area2D
# DOOR SCRIPT
# unlocked/locked, even portcullis, this script covers doors!
@onready var SPRITE = $AnimatedSprite2D
@export_enum("wood_a", "wood_b", "portcullis", "steel") var door_type : String = "wood_a" # defaults to wood_a
@export var opened : bool = false # if the door is opened or not
@export var locked : bool = false # if the door is 'locked'
@export var breakable : bool = true # if this door is breakable or not
@export var switch_controlled : bool = false # if this door requires a switch to open it (also other unlock methods outside of the door)
@export var hit_points : int = 5 # defaults to 5 IF breakable
@export var defense : int = 6 # the defense (how much it could damage the player's weapon)


func _ready():
    # set the starting frame based on the door_type
    match door_type:
        "wood_a": 
            SPRITE.frame = 0 # first wood door
        "wood_b":
            SPRITE.frame = 2 # second wood door
        "portcullis":
            SPRITE.frame = 4 # portcullis
        "steel":
            SPRITE.frame = 6 # steel door