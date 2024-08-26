extends Node2D
# FIGHTER BATTLER SCRIPT
# if the player is the fighter class then this is the battler for them!
@onready var FIGHTER_ANIM = $Animation_Fighter
var FIGHTER_STATE : String = "IDLE" # IDLE, HIT, ATTACK, BLOCK, DEAD, DODGE LEFT, DODGE RIGHT, FATIGUED, CASTING, ITEM


func _ready():
    pass

func _process(_delta):
    pass


func fighter_control(_clock):
    # the fighter ai is totally dependent on the player's input so there IS no ai
    # the fighter will stay idle until player input is detected or the player is hit or killed
    if FIGHTER_STATE == "IDLE":
        # idle state ideally awaiting user input...
        pass
    elif FIGHTER_STATE == "HIT":
        pass
    elif FIGHTER_STATE == "FATIGUED":
        pass
    elif FIGHTER_STATE == "CASTING":
        pass
    elif FIGHTER_STATE == "ITEM":
        pass
    elif FIGHTER_STATE == "DEAD":
        pass