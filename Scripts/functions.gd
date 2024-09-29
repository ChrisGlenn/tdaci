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
    # calculate and return if an attacker has hit
    # do this by 'rolling' a 4 d6 and add the attackers agility modifier then compare it 
    # against the defenders armor class + shields/helmets + endurance modifier
    # if the roll is above the defenders defensive state then return true
    # if 1 then the attacker misses but IF 24 then a score with a full mod hit
    var roll = RNG.randi_range(1,24)
    if roll == 1:
        return "MISS" # the attacker has missed
    elif roll == 24:
        return "CRIT" # the attacker has hit
    else:
        # check against the defenders stats to see if there is a hit
        return "HIT"

func melee_dmg():
    # calculate the damage done this is done with the following formula:
    # weapon stat + 0 to STR(MOD) - ANY PENALTY /2
    pass

func spell_dmg():
    pass


# interaction functions
# pick door/chest locks
func pick_lock():
    # calculate and return if the lock was picked or not
    pass