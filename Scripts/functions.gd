extends Node
# FUNCTIONS
# this is where a bunch of numbers are crunched mostly related to combat

func melee_hit(skill, attack):
    # calculate and return the damage that has been caused by a melee attack
    var damage = (skill + attack)/2
    return damage