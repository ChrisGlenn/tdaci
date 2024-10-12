extends Node
# GLOBAL VARIABLES (SINGLETONS)
# player variables
var player_position : Vector2

var player : Dictionary = {
    "name": "Adan",
    "gender": "Male",
    "race": "Human",
    "class": "Fighter",
    "level": 1,
    "max_hp": 8,
    "mp": 0,
    "max_mp": 0,
    "hp": 8,
    "xp": 0,
    "xp_to": 100,
    "current_status": "Healthy",
    "current_weight": 0.0,
    "carry_capacity": 40.0,
    "encumbered": false,
    "gold": 10,
    "ATB": 100,
    "ATB_MAX": 100,
    "STR": 11,
    "STR_MOD": 4,
    "END": 9,
    "END_MOD": 2,
    "AGI": 10,
    "AGI_MOD": 3,
    "INT": 7,
    "INT_MOD": 0,
    "CHR": 9,
    "CHR_MOD": 2,
    "bonus": 1,
    "AC": 2,
    "WPN_DMG": 0,
    "WPN_PEN": 0,
    "INV": ["meat"],
    "Spells": [],
    "Dead": false
}

# npc variables

# HUD variables
var HUD_STATE : String = "KEYBOARD"
var hud_interaction_frame : int = 474 # default is question mark which will do a search (399 question mark if needed)
var interaction_frame_default : int = 474 # what to reset to
var interaction_data : Dictionary = {} # holds the interaction 'dialogue' data
var search_data : Dictionary = {} # holds the search 'dialogue' data
var dialogue_data : Dictionary = {} # holds the dialogue data
# input display settings
# checks if controller is plugged in or not and then sets accordingly
var a_button : String = "SPACE" # 'accept' or interact
var b_button : String = "CTRL" # 'cancel' or 'block'
var x_button : String = "I" # inventory
# terminal
var terminal : String = "> Hail! Welcome to The Dragon at Castle Ivalyn.\n" # starting message for the terminal on the HUD

# game/system variables
var stage : int = 0 # game stage
var quests : Array = [

] # holds the current quests for the game
var can_move : bool = true # if the player can move the character
var player_moved : bool = false # true if the player has moved
var timer_ctrl : float = 100.0 # timer control
var frame : int = 0 # switches between 0 and 1 global frame set
var frame_timer : int = 42 # time between frame switch
var inside_interior : bool = false # tracks if player is inside an interior setting (used for sfx effects)
# timers here are for free use so I don't have to make a ton of timer recorders for each instance
var timer_thirty : int = 30

# level variables
var current_level : int = 0 # 0 = 1 used for iterating thru array
var cleared_levels : Array = [0,0,0,0] # if 1 then the cooresponding floor has been cleared
var level_one_discovered_tiles : Dictionary = {} # stores the discovered tiles
var level_doors : Array = [] # stores the door status for each door on each level
var fov_update : bool = false # if true then the game will update the field of view


# --------------------------
# GLOBAL VARIABLES AND PROCESSES/FUNCTIONS
# --------------------------
var last_message : String = ""
var current_minute # holds the current minute
var terminal_reset : int = 5 # when it gets to 0 reset to the last_message

# global process
func _ready() -> void:
    # record variables
    last_message = terminal # record the terminal message
    # hide the mouse
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    # check for gamepad and if detected change the UI button text
    var joypad = Input.get_connected_joypads()
    if joypad.size() > 0:
        HUD_STATE = "JOYPAD" # the player has a joypad plugged in
    # set the current_current minute
    var current_time = Time.get_time_dict_from_system()
    current_minute = current_time["minute"]

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
    # terminal reset
    # every 10 minutes the terminal will clear out except for the last message
    var current_time = Time.get_time_dict_from_system()
    if current_minute != current_time["minute"]:
        current_minute = current_time["minute"]
        # check if the terminal_reset is 0 and if so then reset the terminal
        if terminal_reset > 0:
            terminal_reset -= 1 # decrement the reset
        else:
            terminal = last_message # clear out the terminal except for last message
            terminal_reset = 5 # reset
    # player movement check
    if player_moved: player_moved = false # reset
    # DEBUG
    if Input.is_action_just_pressed("ci_F1"):
        # used for testing but a good template for player options settings
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func update_terminal(message : String):
    terminal_reset = 5 # add more time to the terminal reset
    last_message = message # set the last message
    terminal += str(message) # update with the message