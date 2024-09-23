extends Node
# FUNCTIONS
# this is where a bunch of numbers are crunched mostly related to combat
var RNG = RandomNumberGenerator.new() # random number generator


func _ready() -> void:
    RNG.randomize() # seed random


# FUNCTIONS
# combat function
# hit function for melee attacks
func melee_hit(skill : int, attack : Array):
    # calculate and return the damage that has been caused by a melee attack
    var attack_value = RNG.randi_range(attack[0], attack[1]) # get the attack value
    var damage = (skill + attack_value) / 2 # return an integer
    return damage


# interaction functions
# pick door/chest locks
func pick_lock():
    # calculate and return if the lock was picked or not
    pass