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
@export_group("Door Interaction")
@export_multiline var closed_desc : String = "" # the closed description (pre-discovery)
@export_multiline var closed_locked_desc : String = "" # the closed description for locked (post-discovery)
@export_multiline var open_desc : String = "" # the open description
@export_multiline var broken_desc : String = "" # the broken description
var broken : bool = false # if the door has been broken
var discovered : int = false # if true then the door's locked status is known
var door_reference_exists : bool = false # if the door is in the level_doors Global
var door_ref : int = 0 # based on the x coord for the tiles
var tilemap_ref : int = 1 # defaults to 1 (solid/can't see thru)
var frame_ref : int = 474 # the reference UI frame (defaults to black)
var is_active : bool = false # true if the player is colliding
var door_desc : String = "A closed door stands before you..."
var door_frame : int = 0 # the frame for the door (is set when matching door_type in ready)
var door_choices : Array = ["Open", "Return"]
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
		door_update() # run the door_update function

func _process(_delta: float) -> void:
	door_control() # door control (input)


func door_control():
	# check if the door is active and look for input
	if is_active:
		if Input.is_action_just_pressed("ci_A"):
			if !interaction_ui:
				var i_ui = INTERACT_UI.instantiate()
				i_ui.parent = self # set the parent
				i_ui.description_frame = door_frame # set the image
				i_ui.description_text = door_desc # set the description
				i_ui.choices = door_choices # set the choices
				get_tree().root.add_child(i_ui)
				interaction_ui = i_ui # set a reference for this object

func door_update():
	# check against the set door_type then assign the texture accordingly
	# set the door_ref and tilemap_ref to fix door sprite and field of view
	match door_type:
		"wood_a":
			if !broken:
				if !opened:		
					door_ref = 0 # closed
					frame_ref = 95
					tilemap_ref = 1 # set to obscure visibility if closed again
					door_frame = 0 # HUD frame closed
					if !discovered: 
						door_desc = closed_desc # update HUD description
						door_choices = ["Open", "Return"] # update choices
					else: 
						if locked: 
							door_desc = closed_locked_desc # update HUD description
							door_choices = ["Pick Lock", "Bash", "Return"] # update choices
						else: 
							door_desc = closed_desc # update HUD description
							door_choices = ["Open", "Return"] # update choices
				else:
					door_ref = 1 # opened
					frame_ref = 96 # change the actual door frame
					tilemap_ref = 0 # swap tilemap layer
					door_frame = 1 # HUD frame closed
					door_choices = ["Close", "Return"] # update choices
					door_desc = open_desc # update HUD description
			else:
				# show as open if broken
				door_ref = 1 # opened
				frame_ref = 96
				tilemap_ref = 0 # swap tilemap layer
				door_frame = 1 # open UI door
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
	var door_position = current_tilemap.local_to_map(global_position) # get the current position
	current_tilemap.set_cell(door_position,tilemap_ref,Vector2i(door_ref,5)) # update the door tile based on frame
	if interaction_ui: 
		# if the interaction_ui exists then run this section to update
		interaction_ui.description_frame = door_frame # set the image
		interaction_ui.description_text = door_desc # set the description
		interaction_ui.choices = door_choices # set the choices
		interaction_ui.int_update() # run the int_update function for the HUD
		# update the field of view
		

func interaction(choice : String):
	if choice == "Open":
		# check if the door is locked or not and then respond
		# the player will have no idea if it's locked or not
		if !locked:
			# open the door and change the sprite
			opened = true # door is now opened
			door_update()
			# close the interaction UI
			interaction_ui.queue_free() # delete the UI
			interaction_ui = null # set the interaction_ui to null
			Globals.can_move = true # return control to the player
		else:
			# inform the player that the door is locked and update the description
			# and choices to now reflect that the door is locked
			discovered = true # set this door to discovered
			door_update()
	elif choice == "Close":
		# close the door
		opened = false
		door_update()
		# close the interaction UI
		interaction_ui.queue_free() # delete the UI
		interaction_ui = null # set the interaction_ui to null
		Globals.can_move = true # return control to the player
	elif choice == "Pick Lock":
		# pick the lock
		pass
	elif choice == "Return":
		interaction_ui.queue_free() # delete the UI
		interaction_ui = null # set the interaction_ui to null
		Globals.can_move = true # return control to the player
	else:
		print("ERROR: Unrecognized choice: ", self) # ERROR


func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		# update the HUD to let the player know they can interact with the door
		is_active = true # set to true

func _on_body_exited(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		# update the HUD the player is now out of range of the door
		is_active = false # set to false
