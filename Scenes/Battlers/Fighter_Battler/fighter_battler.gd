extends Node2D
# FIGHTER BATTLER SCRIPT
# if the player is the fighter class then this is the battler for them!
@onready var FIGHTER_ANIM = $Animation_Fighter
@export var cool_down : int = 60 # cool down period between movements
var FIGHTER_STATE : String = "IDLE" # IDLE, HIT, ATTACK, BLOCK, DEAD, DODGE LEFT, DODGE RIGHT, FATIGUED, CASTING, ITEM
var cool_down_rec # keeps track of cool_down


func _ready():
    cool_down_rec = cool_down # record the cool_down setting

func _process(delta):
    fighter_control(delta) # fighter control function


func fighter_control(_clock):
    # the fighter ai is totally dependent on the player's input so there IS no ai
    # the fighter will stay idle until player input is detected or the player is hit or killed
    if FIGHTER_STATE == "IDLE":
        # idle state ideally awaiting user input...
        FIGHTER_ANIM.play("idle")
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