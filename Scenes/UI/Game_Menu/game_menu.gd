extends CanvasLayer
# GAME MENU SCRIPT
# if the player hits ESC or START then this menu pops up giving them a list of options
# they can choose from such as see the inventory or character status, ect.
@onready var STAT_MENU = preload("res://Scenes/UI/Status_Menu/status_menu.tscn")
@onready var SELECTORS = $Select_Nodes
var sel_pos : int = 0 # this shows the current selector


func _ready() -> void:
    get_tree().paused = true # pause the game

func _process(_delta: float) -> void:
    game_menu() # the game menu function


func game_menu():
    # check for player input and then respond accordingly depending on the current sel_pos
    if Input.is_action_just_pressed("ci_DOWN"):
        if sel_pos != 4:
            sel_pos += 1 # increment selection position
    if Input.is_action_just_pressed("ci_UP"):
        if sel_pos != 0:
            sel_pos -= 1 # decrement selection position
    if Input.is_action_just_pressed("ci_A"):
        # the player has made a selection check the current position and then react
        if sel_pos == 0:
            # return to game
            get_tree().paused = false # unpause before returning
            queue_free() # delete self
        elif sel_pos == 2:
            # player status
            var stat_menu = STAT_MENU.instantiate()
            get_parent().add_child(stat_menu) # add the menu as a child to the HUD
            queue_free() # delete self
        elif sel_pos == 4:
            # quit the game
            # DEBUG IN THE FUTURE THIS WILL ASK IF THEY ARE SURE
            get_tree().quit() 
    # update the selector animation frame as well
    for n in SELECTORS.get_child_count():
        if n == sel_pos:
            SELECTORS.get_child(n).frame = 1 # selected
        else:
            SELECTORS.get_child(n).frame = 0 # unselected