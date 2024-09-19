extends Node2D
# INTERACTION SCRIPT
# This HUD element is instanced whenever the player talks or interacts with an NPC or object.
# Dialogue/interaction choices will be listed along with an image of what the player is interacting with.
var description_text : Array = [] # holds the descriptions (Strings) 
var choices : Array = [] # holds the choices (Strings)
var description_pos : int = 0 # the current description_text array position
var choices_pos : int = 0 # the current choices array position
var can_select : bool = true # used pause choice selector iteration from player