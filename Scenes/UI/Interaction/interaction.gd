extends CanvasLayer
# INTERACTION SCRIPT
# This HUD element is instanced whenever the player talks or interacts with an NPC or object.
# Dialogue/interaction choices will be listed along with an image of what the player is interacting with.
@onready var DESC_IMAGE = $Object_Sprite
@onready var DESC_TEXT = $Object_Desc
@onready var INSTRUCT = $Interact_Instruction
@onready var SEL_NODES = $Selector_Nodes
@onready var CHOICES = $Choices
var description_frame : int = 0 # holds the frame for the description/object image
var description_text : String = "" # holds the descriptions (Strings) 
var choices : Array = [] # holds the choices (Strings)
var description_pos : int = 0 # the current description_text array position
var choices_pos : int = 0 # the current choices array position
var choices_max : int = 0 # how many choices the player can select
var can_select : bool = true # used pause choice selector iteration from player
var update : bool = false # if true then update the interaction HUD dialogue
var choice : String = "" # holds the choice made that will be passed to the interact object
var parent # holds the parent object to pass back commands


func _ready() -> void:
    # TODO
    # set the dialogue texts and visible characters to 0
    # get the list of choices and iterate through each choices child filling in the
    # text and then making the extra choices invisible...
    Globals.can_move = false # stop player movement
    DESC_IMAGE.frame = description_frame # set the image frame
    DESC_TEXT.text = description_text # set the text
    if choices.size() > 0:
        for n in choices.size():
            CHOICES.get_child(n).text = choices[n] # change the texts
            CHOICES.get_child(n).visible = true
            SEL_NODES.get_child(n).visible = true
            if n == choices_pos: SEL_NODES.get_child(n).frame = 1 # set the current selector pos
    else:
        print("ERROR: NO CHOICES SET FOR ", self) # ERROR OUT
        #get_tree().quit() # close the game after feeding the error
    choices_max = choices.size()-1 # set the choices max
    choice = CHOICES.get_child(choices_pos).text # set the current selected choice reference

func _process(_delta: float) -> void:
    int_controls() # check for input


func int_controls():
    # check for choices and then respond to input
    if choices_max > 0:
        if Input.is_action_just_pressed("ci_DOWN"):
            if choices_pos < choices_max: 
                choices_pos += 1 # move down by incrementing choices_pos
                SEL_NODES.get_child(choices_pos).frame = 1 # set the next selection down's frame
                SEL_NODES.get_child(choices_pos-1).frame = 0 # set the previous selection frame back
                choice = CHOICES.get_child(choices_pos).text # set the current choice reference
        if Input.is_action_just_pressed("ci_UP"):
            if choices_pos > 0: 
                choices_pos -= 1 # move up by decrementing choices_pos
                SEL_NODES.get_child(choices_pos).frame = 1 # set the 'next' selection's frame
                SEL_NODES.get_child(choices_pos+1).frame = 0 # set the 'previous' selection's frame
                choice = CHOICES.get_child(choices_pos).text # set the current choice reference
        if Input.is_action_just_pressed("ci_A"):
            parent.interaction(choice)

func int_update():
    # clear out the choices
    # change the dialogue
    # set the new choices and reset the choices_pos/choices_max
    for n in CHOICES.get_child_count():
        CHOICES.get_child(n).visible = false # hide each child