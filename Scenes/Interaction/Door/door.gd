extends Area2D
# DOOR SCRIPT
# unlocked/locked, even portcullis, this script covers doors!
@export_group("Door Attributes")
@export var door_id : String = "" # sets the door ID to search in the globals on loading
@export var current_tilemap : TileMapLayer # set the current tilemap to manipulate
@export_enum("wood_a", "wood_b", "portcullis", "steel") var door_type : String = "wood_a" # defaults to wood_a
@export var opened : bool = false # if the door is opened or not
@export var locked : bool = false # if the door is 'locked'
@export var breakable : bool = true # if this door is breakable or not
@export var switch_controlled : bool = false # if this door requires a switch to open it (also other unlock methods outside of the door)
@export var hit_points : int = 5 # defaults to 5 IF breakable


func _ready():
	if current_tilemap:
		# get the current position
		var door_position = current_tilemap.local_to_map(global_position)
		# update the tilemap based on the door_type
		current_tilemap.set_cell(door_position,1,Vector2i(2,5))


func _on_body_exited(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		# update the HUD to let the player know they can interact with the door
		pass

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		# update the HUD the player is now out of range of the door
		pass
