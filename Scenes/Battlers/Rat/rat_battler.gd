extends Node2D
# THE RAT!!
# a rat enemy that just does basic attacks and blocks some incoming attacks
# this is the first enemy of the game and does minimal damage
@export var hit_points : int = 50 # rat's hit points
@export var defense : int = 20 # rat's defense points
@export var rat_state_timer : int = 60 # every time this hits zero the rat will check and see it's next move
var RAT_STATE : String = "IDLE" # IDLE, HIT, ATTACK, DEAD, BLOCK


func _ready():
    pass

func _process(delta):
    rat_ai(delta)


func rat_ai(_clock):
    # THE BRAINS OF THE RAT
    # The rat_state_timer will count down to 0 and the rat will then decide, based on a series of variables,
    # what the next best move is. The rat will also respond, possibly, to the player's attacks based on whether they
    # were just hit. The rat is a 'dumb' enemy so it's blocking isn't really refined.
    # check the rat state 
    pass