extends Node2D
# BATTLEGROUND SCRIPT
# spawns the enemies, sets a random battlefield (possibly), the script for the battleground
@onready var BACKGROUND = $"Background-Black"
@onready var RNG = RandomNumberGenerator.new() # random number generator


func _ready() -> void:
    RNG.randomize() # seed random
    if Globals.battle_background_dynamic:
        # RANDOM BACKGROUND - get a random number from 0 to background child size (-1) then set that background to visible
        var background_index = RNG.randi_range(0,BACKGROUND.get_child_count()) # get the background number
        var background = BACKGROUND.get_child(background_index)
        background.visible = true # display the random background
    else:
        # STATIC BACKGROUND - get the index from the Global file and set that background to visible
        var background = BACKGROUND.get_child(Globals.battle_static_background)
        background.visible = true # set the background to visible
