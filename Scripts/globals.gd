extends Node
# GLOBAL VARIABLES (SINGLETONS)
# player variables
var player_x # stores the player's X coords
var player_y # stores the player's Y coords
var player_name : String = "Adan" # player's name
var player_class : String = "Fighter" # Fighter, Mage, Ranger (defaults to fighter)
var player_hp : int = 39 # player's current hit points
var player_max_hp : int = 39 # player's hit points
var player_mp : int = 10 # player's current mana points
var player_max_mp : int = 10 # player's mana points
var player_gold : int = 20 # player's gold
var player_xp : int = 0 # player's current xp
var player_strength : int = 8 # player strength (fighter, ranger)
var player_wisdom : int = 5 # player wisdom (mage only)
var player_health : int = 9 # player's health (all classes)
var player_stamina : int = 7 # player's stamina (fighter, ranger)
var player_mana : int = 5 # player's mana (mage only)
var shield_hp : int = 10 # fighter's current shield hit points
var shield_max_hp : int = 10 # fighter's shield hit points
var sword_hp : int = 10 # fighter's current sword hit points
var sword_max_hp : int = 10 # fighter's sword hit points
var stamina_max_points : int = 100 # how many max points the player's stamina is
var stamina_points : int = 100 # the current stamina points for the player
var sword_attack : int = 4 # the attack power of the player's sword (can get upgraded by blacksmith)
var player_attack : bool = false # this will be true when the player is attacking (used for enemy blocking/dodging)
var player_is_dead : bool = false # if the player is dead then this is true


# npc variables


# game/system variables
var stage : int = 0 # game stage
var can_move : bool = true # if the player can move the character
var timer_ctrl : int = 100 # timer control
var frame : int = 0 # switches between 0 and 1 global frame set
var frame_timer : int = 42 # time between frame switch
var inside_interior : bool = false # tracks if player is inside an interior setting (used for sfx effects)

# level variables
var level_one_discovered_tiles : Dictionary = {} # stores the discovered tiles


# global process
func _process(delta):
    # global frames
    # this counts down the timer and then swaps the frame back and fourth
    # this allows every animated sprite in the game to be in sync
    if frame_timer > 0:
        frame_timer -= timer_ctrl * delta # decrement the frame timer
    else:
        if frame == 0:
            frame = 1 # change frame
            frame_timer = 42 # reset the frame timer
        else:
            frame = 0 # change the frame
            frame_timer = 42 # reset the frame timer