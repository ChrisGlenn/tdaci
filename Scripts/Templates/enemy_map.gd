extends Node
# OVERWORLD(MAP) ENEMY
# a template script for the overworld enemies that will just move to the player (or away)
# and initialize combat
@export_group("Enemy Attributes")
@export var enemy_name : String = "" # name of the enemy
@export var movement_inc : int = 20 # increment time between space movement