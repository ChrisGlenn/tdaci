extends Node2D
# THE COURTYARD
# the player navigates thru the courtyard to get to the various locations
@onready var PLAYER_CAM = $Player/Camera2D


func _ready() -> void:
    PLAYER_CAM.enabled = false # turn off the player's camera