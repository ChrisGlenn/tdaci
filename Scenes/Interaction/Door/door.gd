extends Area2D
# DOOR SCRIPT
# unlocked/locked, even portcullis, this script covers doors!
# door tile reference (0,5x1 2,5x3 4,5x5 10,5x11)
@onready var INTERACT_UI = preload("res://Scenes/UI/Interaction/interaction.tscn")
@export_group("Door Attributes")
@export var door_id : String = "" # sets the door ID to search in the globals on loading
@export var current_tilemap : TileMapLayer # set the current tilemap to manipulate
@export_enum("wood_a", "wood_b", "portcullis", "steel") var door_type : String = "wood_a" # defaults to wood_a
@export var opened : bool = false # if the door is opened or not
@export var locked : bool = false # if the door is 'locked'
@export var breakable : bool = true # if this door is breakable or not
@export var switch_controlled : bool = false # if this door requires a switch to open it (also other unlock methods outside of the door)
@export var hit_points : int = 5 # defaults to 5 IF breakable
var broken : bool = false # if the door has been broken
var door_reference_exists : bool = false # if the door is in the level_doors Global
var door_ref : int = 0 # based on the x coord for the tiles
var tilemap_ref : int = 1 # defaults to 1 (solid/can't see thru)
var frame_ref : int = 474 # the reference UI frame (defaults to black)
var is_active : bool = false # true if the player is colliding
var interaction_data : Dictionary = {} # this gets sent to the Interaction HUD
var interaction_ui # holds the interaction UI


func _ready():
	# load the door configuration from the Globals data IF it exists and if not then save the configuration
	if Globals.level_doors.size() > 0:
		for n in Globals.level_doors.size():
			if Globals.level_doors[n]["id"] == door_id:
				opened = Globals.level_doors[n]["opened"]
				locked = Globals.level_doors[n]["locked"]
				hit_points = Globals.level_doors[n]["hit_points"]
				broken = Globals.level_doors[n]["hit_points"]
				door_reference_exists = true
			if n == Globals.level_doors.size()-1:
				if !door_reference_exists:
					# record this door
					var this_door = {"id": door_id,"opened": opened,"locked": locked,"hit_points": hit_points,"broken": broken}
					Globals.level_doors.append(this_door) # add to the array
	else:
		# record this door
		var this_door = {"id": door_id,"opened": opened,"locked": locked,"hit_points": hit_points,"broken": broken}
		Globals.level_doors.append(this_door) # add to the array
	if current_tilemap:
		# get the current position
		var door_position = current_tilemap.local_to_map(global_position)
		# check against the set door_type then assign the texture accordingly
		# set the door_ref and tilemap_ref to fix door sprite and field of view
		match door_type:
			"wood_a":
				if !broken:
					if !opened:		
						door_ref = 0 # closed
						frame_ref = 95
						if locked: pass # locked data
						else: pass # unlocked data
					else:
						door_ref = 1 # opened
						frame_ref = 96
						tilemap_ref = 0 # swap tilemap layer
						# open data here
				else:
					# show as open if broken
					door_ref = 1 # opened
					frame_ref = 96
					tilemap_ref = 0 # swap tilemap layer
			"wood_b":
				if !opened:
					door_ref = 2 # closed
					frame_ref = 97
				else:
					door_ref = 3 # opened
					frame_ref = 98
					tilemap_ref = 0 # swap tilemap layer
			"portcullis":
				if !opened:
					door_ref = 4 # closed
					frame_ref = 99
				else:
					door_ref = 5 # opened
					frame_ref = 100
					tilemap_ref = 0 # swap tilemap layer
			"steel":
				if !opened:
					door_ref = 10 # closed
					frame_ref = 105
				else:
					door_ref = 11 # opened
					frame_ref = 106
					tilemap_ref = 0 # swap tilemap layer
		# update the tilemap based on the door_type
		current_tilemap.set_cell(door_position,tilemap_ref,Vector2i(door_ref,5))

func _process(_delta: float) -> void:
	door_control() # door control (input)


func door_control():
	# check if the door is active and look for input
	if is_active:
		if Input.is_action_just_pressed("ci_A"):
			if !interaction_ui:
				var i_ui = INTERACT_UI.instantiate()
				get_tree().root.add_child(i_ui)
				interaction_ui = i_ui
				print(interaction_ui)

func door_update():
	pass


func _on_body_exited(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		# update the HUD to let the player know they can interact with the door
		is_active = true # set to true

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		# update the HUD the player is now out of range of the door
		is_active = false # set to false
