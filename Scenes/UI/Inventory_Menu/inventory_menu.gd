extends CanvasLayer
# INVENTORY SCRIPT
# the inventory script controls the inventory screen (brilliant) along with the equipment
# display
@onready var INV_SLOTS = $Inventory_Background/Inventory_Slots
@onready var INV_SELECTOR = $Inventory_Background/Inventory_Selector
@onready var INSPECT_TITLE = $Inventory_Background/Inspector_Title
@onready var INSPECT_SPRITE = $Inventory_Background/Inspector_Sprite
@onready var CONTROLS = $Inventory_Background/Press_Return
@onready var INSPECT_DESC = $Inventory_Background/Inspector_Desc
@onready var EQUIP_SLOTS = $Inventory_Background2/Equip_Slots
@onready var HELMET_SLOT = $Inventory_Background2/Equip_Slots/helmet_slot
@onready var AMULET_SLOT = $Inventory_Background2/Equip_Slots/amulet_slot
@onready var SHIELD_SLOT = $Inventory_Background2/Equip_Slots/shield_slot
@onready var ARROW_SLOT = $Inventory_Background2/Equip_Slots/arrow_slot
@onready var RING_SLOT_ONE = $Inventory_Background2/Equip_Slots/ring_slot_1
@onready var RING_SLOT_TWO = $Inventory_Background2/Equip_Slots/ring_slot_2
@onready var WEAPON_SLOT = $Inventory_Background2/Equip_Slots/weapon_slot
@onready var ARMOR_SLOT = $Inventory_Background2/Equip_Slots/armor_slot
var cur_pos : int = 0 # inventory select cursor position


func _ready() -> void:
	get_tree().paused = true # pause the game
	# set the inventory slots
	if Globals.player["INV"].size() > 0:
		# iterate through and set the frame for each slot based on the reference
		# in the Items class database
		for n in Globals.player["INV"].size():
			INV_SLOTS.get_child(n).frame = Items.Items_DB[Globals.player["INV"][n]]["frame"]
			Globals.player["current_weight"] += Items.Items_DB[Globals.player["INV"][n]]["weight"]
		update_inspector() # update the inventory inspector
		update_controls(Items.Items_DB[Globals.player["INV"][cur_pos]]["type"])
	else:
		# update the inventory inspector to show no items in inventory
		INV_SELECTOR.visible = false # hide the inventory selector
		INSPECT_TITLE.text = "" # blank
		INSPECT_DESC.text = "Your inventory is empty..."
		update_controls("NULL") # run control update w/ Null
	visible = true # show the inventory screen AFTER updating

func _process(_delta: float) -> void:
	inventory_control() # the control function


func inventory_control():
	# CYCLE THROUGH THE INVENTORY
	if Globals.player["INV"].size() > 0:
		if Input.is_action_just_pressed("ci_RIGHT"):
			if cur_pos < Globals.player["INV"].size() - 1:
				cur_pos += 1
				INV_SELECTOR.position = INV_SLOTS.get_child(cur_pos).position
				update_inspector()
				update_controls(Items.Items_DB[Globals.player["INV"][cur_pos]]["type"])
		if Input.is_action_just_pressed("ci_LEFT"):
			if cur_pos > 0:
				cur_pos -= 1
				INV_SELECTOR.position = INV_SLOTS.get_child(cur_pos).position
				update_inspector()
				update_controls(Items.Items_DB[Globals.player["INV"][cur_pos]]["type"])
		if Input.is_action_just_pressed("ci_DOWN"):
			if (cur_pos + 5) < Globals.player["INV"].size():
				cur_pos += 5
				INV_SELECTOR.position = INV_SLOTS.get_child(cur_pos).position
				update_inspector()
				update_controls(Items.Items_DB[Globals.player["INV"][cur_pos]]["type"])
		if Input.is_action_just_pressed("ci_UP"):
			if (cur_pos - 5) >= 0:
				cur_pos -= 5
				INV_SELECTOR.position = INV_SLOTS.get_child(cur_pos).position
				update_inspector()
				update_controls(Items.Items_DB[Globals.player["INV"][cur_pos]]["type"])
		# USE/EQUIP/ECT THE OBJECT
		if Input.is_action_just_pressed("ci_A"):
			# Globals.player["INV"].remove_at(cur_pos)
			# if cur_pos > 0: 
			# 	cur_pos -= 1
			# 	INV_SELECTOR.position = INV_SLOTS.get_child(cur_pos).position
			# Globals.player["current_weight"] = 0.0
			# update_inventory()
			# USE ITEM
			# get the type and run the function w/ the type and name
			pass
	# CLOSE THE INVENTORY MENU
	if Input.is_action_just_pressed("ci_B") or Input.is_action_just_pressed("ci_START"):
		get_tree().paused = false # unpause the game
		queue_free() # delete the inventory instance

func update_inspector():
	INSPECT_TITLE.text = Items.Items_DB[Globals.player["INV"][cur_pos]]["title"]
	INSPECT_SPRITE.frame = Items.Items_DB[Globals.player["INV"][cur_pos]]["frame"]
	INSPECT_DESC.text = Items.Items_DB[Globals.player["INV"][cur_pos]]["desc"]

func update_inventory():
	# iterate through and set the frame for each slot based on the reference
	# in the Items class database
	for n in INV_SLOTS.get_child_count():
		if n <= Globals.player["INV"].size()-1:
			INV_SLOTS.get_child(n).frame = Items.Items_DB[Globals.player["INV"][n]]["frame"]
			Globals.player["current_weight"] += Items.Items_DB[Globals.player["INV"][n]]["weight"]
		else:
			INV_SLOTS.get_child(n).frame = 259
	if Globals.player["INV"].size() == 0:
		INV_SELECTOR.visible = false # hide the selector
		# update the inventory inspector to show no items in inventory
		Globals.player["current_weight"] = 0.0 # reset the weight
		INV_SELECTOR.visible = false # hide the inventory selector
		INSPECT_SPRITE.frame = 259 # blank
		INSPECT_TITLE.text = "" # blank
		INSPECT_DESC.text = "Your inventory is empty..."
	else:
		update_inspector() # update the inspector

func update_controls(control_type : String):
	# update the controls at the bottom of the screen
	match control_type:
		"NULL":
			CONTROLS.text = str("Press ", Globals.cancel_button, " to close inventory.")
		"CONSUMABLE":
			CONTROLS.text = str(Globals.interact_button, ": Use  ", Globals.status_button, ": Discard  ", Globals.cancel_button, ": Close")