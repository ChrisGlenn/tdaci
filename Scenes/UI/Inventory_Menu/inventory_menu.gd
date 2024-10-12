extends CanvasLayer
# INVENTORY SCRIPT
# the inventory script controls the inventory screen (brilliant) along with the equipment
# display
@onready var INV_SLOTS = $Inventory_Background/Inventory_Slots
@onready var INV_SELECTOR = $Inventory_Background/Inventory_Selector
@onready var INSPECT_TITLE = $Inventory_Background/Inspector_Title
@onready var INSPECT_SPRITE = $Inventory_Background/Inspector_Sprite
@onready var INSPECT_DESC = $Inventory_Background/Inspector_Desc
@onready var EQUIP_SLOTS = $Inventory_Background2/Equip_Slots
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
		INSPECT_TITLE.text = Items.Items_DB[Globals.player["INV"][cur_pos]]["title"]
		INSPECT_SPRITE.frame = Items.Items_DB[Globals.player["INV"][cur_pos]]["frame"]
		INSPECT_DESC.text = Items.Items_DB[Globals.player["INV"][cur_pos]]["desc"]
	else:
		# update the inventory inspector to show no items in inventory
		INV_SELECTOR.visible = false # hide the inventory selector
		INSPECT_TITLE.text = "" # blank
		INSPECT_DESC.text = "Your inventory is empty..."
	visible = true # show the inventory screen AFTER updating

func _process(_delta: float) -> void:
	inventory_control() # the control function


func inventory_control():
	if Input.is_action_just_pressed("ci_B"):
		get_tree().paused = false # unpause the game
		queue_free() # delete the inventory instance
