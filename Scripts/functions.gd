extends Node
# FUNCTIONS
# this is where a bunch of numbers are crunched mostly related to combat
var RNG = RandomNumberGenerator.new() # random number generator


func _ready() -> void:
    RNG.randomize() # seed random


# FUNCTIONS
# combat function
# hit function for melee attacks
func melee_hit(agi_mod : int, ac : int):
    # calculate and return if an attacker has hit
    # do this by 'rolling' a 4 d6 and add the attackers agility modifier then compare it 
    # against the defenders armor class + shields/helmets + endurance modifier
    # if the roll is above the defenders defensive state then return true
    # if 1 then the attacker misses but IF 24 then a score with a full mod hit
    var roll = RNG.randi_range(1,24)
    if roll == 1:
        return "MISS" # the attacker has missed automatically
    elif roll == 24:
        return "CRIT" # the attacker has achieved a critical hit (meaning full modification add to damage)
    else:
        # check against the defenders stats to see if there is a hit
        if roll > agi_mod + ac:
            return "HIT" # then the attacker has hit its target
        else:
            return "MISS" # otherwise it is a miss

func attack_dmg(crit : bool, weapon_dmg : int, mod_add : int, penalty : int, target_ac : int):
    # calculate the damage done this is done with the following formula:
    # weapon stat + 0 to STR(MOD) - ANY PENALTY /2
    if !crit:
        # NOT a critical hit
        var damage_mod = RNG.randi_range(0, mod_add) # if not a critical hit then random the weapon mod
        var damage = weapon_dmg + (damage_mod - penalty)
        if weapon_dmg > target_ac:
            return damage # just return the damage without dividing by 2
        else:
            damage = damage / 2
            return damage # return the damage
    else:
        # CRITICAL HIT
        var damage = weapon_dmg + (mod_add - penalty)
        if weapon_dmg > target_ac:
            return damage # just return the damage without dividing by 2
        else:
            damage = damage / 2
            return damage # return the damage

func spell_dmg():
    pass


# interaction functions
# pick door/chest locks
func pick_lock():
    # calculate and return if the lock was picked or not
    pass