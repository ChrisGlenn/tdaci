extends Node
# OVERWORLD(MAP) ENEMY
# a template script for the overworld enemies that will just move to the player (or away)
# and initialize combat
@onready var tilemap : TileMapLayer = get_parent().get_parent().get_node("Enviornment_Tiles")
@export_group("Enemy Attributes")
@export var enemy_name : String = "" # name of the enemy
@export var movement_inc : int = 20 # increment time between space movement
# pathfinding
var player_spotted : bool = false # if true the player has been spotted (default is false)
var current_path : Array[Vector2i]


func _ready() -> void:
	print(self.global_position)
	print(Globals.player_position)

func _process(_delta: float) -> void:
	if player_spotted:
		current_path = tilemap.astar.get_id_path(
			tilemap.local_to_map(self.global_position),
			tilemap.local_to_map(Globals.player_position)
		)
		print(current_path)
		player_spotted = false
	if Input.is_action_just_pressed("ci_A"):
		player_spotted = true # DEBUG
