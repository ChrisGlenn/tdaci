extends Node
# FUNCTIONS
# this is where a bunch of numbers are crunched mostly related to combat
var RNG = RandomNumberGenerator.new() # random number generator


func _ready() -> void:
    RNG.randomize() # seed random


# FUNCTIONS
# combat function
# hit function for melee attacks
func melee_hit():
    # calculate and return the damage that has been caused by a melee attack
    pass

func melee_dmg():
    pass


# interaction functions
# pick door/chest locks
func pick_lock():
    # calculate and return if the lock was picked or not
    pass