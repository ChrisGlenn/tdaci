extends Area2D
# FIREPLACE
# this is where the player can start a fire and save their game while also
# resting and regaining HP back
# if there are status effects in this game this will NOT heal them
@onready var ANIM = $AnimatedSprite2D
@export_multiline var intro : String = "" # the text that will appear when the player enters the fireplace area
var STATE : String = "EMPTY" # EMPTY, FIRE, AND SMOKE


func _ready() -> void:
    ANIM.visible = false # hide the fire/smoke
    ANIM.frame = Globals.frame # set the animation frame