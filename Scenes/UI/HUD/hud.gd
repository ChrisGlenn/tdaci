extends CanvasLayer
# GAME HUD
# the heads up display for the game
# will differ in the information that it displays depending on the character class
# HUD state scenes
# fighter
@onready var HUD = $HUD
@onready var HEART_SPRITE = $HUD/Fighter/Health_Bar
@onready var HEART_LABEL = $HUD/Fighter/Health_Label
@onready var SHIELD_LABEL = $HUD/Fighter/Shield_Label
@onready var SHIELD_BAR = $HUD/Fighter/Shield_Bar
@onready var SWORD_LABEL = $HUD/Fighter/Sword_Label
@onready var SWORD_BAR = $HUD/Fighter/Sword_Bar
@onready var STAMINA_BAR = $HUD/Fighter/Stamina_Bar
@onready var HEALTH_LABEL = $HUD/Fighter/Health_Label
@onready var HEALTH_BAR = $HUD/Fighter/Health_Bar
@onready var F_GOLD_LABEL = $HUD/Fighter/Gold_Label
# hud
@onready var INT_ICON = $HUD/Interaction_Icon
@onready var INT_LABEL = $HUD/Interaction_Label
@onready var INV_LABEL = $HUD/Inventory_Label
# variables


func _ready():
	self.visible = true # DEBUGGING show the HUD
	# set the HUD
	INT_ICON.frame = Globals.hud_interaction_frame # set the interaction icon
	INT_LABEL.text = str("(", Globals.a_button, ")")
	INV_LABEL.text = str("(", Globals.x_button, ")")
	# set FIGHTER HUD
	if Globals.player_class == "Fighter":
		# HEALTH_LABEL.text = str(Globals.player_hp, "/", Globals.player_max_hp)
		# HEALTH_BAR.max_value = Globals.player_max_hp
		# HEALTH_BAR.value = Globals.player_hp
		# F_GOLD_LABEL.text = str(Globals.player_gold)
		pass
	else:
		print("ERROR: INCORRECT PLAYER CLASS SET!!!")
		get_tree().quit() # exit the game after the error
	# run the icon update function
	icon_update()

func _process(_delta):
	# update the icons for the player's avatar
	icon_update() # update the hud


func icon_update():
	# keeps the HUD status bars and labels updated
	INT_ICON.frame = Globals.hud_interaction_frame # update the interaction frame
	# set FIGHTER HUD
	if Globals.player_class == "Fighter":
		# HEALTH_LABEL.text = str(Globals.player_hp, "/", Globals.player_max_hp)
		# HEALTH_BAR.value = Globals.player_hp
		# F_GOLD_LABEL.text = str(Globals.player_gold)
		pass
	else:
		print("ERROR: INCORRECT PLAYER CLASS SET!!!")
		get_tree().quit() # exit the game after the error
