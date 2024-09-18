extends CanvasLayer
# GAME HUD
# the heads up display for the game
# will differ in the information that it displays depending on the character class
# HUD state scenes
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
# variables


func _ready():
	self.visible = true # DEBUGGING show the HUD
	# set the HUD
	HEART_LABEL.text = str(Globals.player_hp, "/", Globals.player_max_hp) # set the player's HP label
	# set FIGHTER HUD
	if Globals.player_class == "Fighter":
		HEALTH_LABEL.text = str(Globals.player_hp, "/", Globals.player_max_hp)
		HEALTH_BAR.max_value = Globals.player_max_hp
		HEALTH_BAR.value = Globals.player_hp
		SHIELD_LABEL.text = str(Globals.shield_hp, "/", Globals.shield_max_hp) # set the shield HP label
		SHIELD_BAR.max_value = Globals.shield_max_hp
		SHIELD_BAR.value = Globals.shield_hp
		SWORD_LABEL.text = str(Globals.sword_hp, "/", Globals.sword_max_hp)
		SWORD_BAR.max_value = Globals.sword_max_hp
		SWORD_BAR.value = Globals.sword_hp
		STAMINA_BAR.max_value = Globals.stamina_max_points
		STAMINA_BAR.value = Globals.stamina_points
		F_GOLD_LABEL.text = str(Globals.player_gold)
	else:
		print("ERROR: INCORRECT PLAYER CLASS SET!!!")
		get_tree().quit() # exit the game after the error
	# run the icon update function
	icon_update()

func _process(_delta):
	# CHECK THE HUD_STATE AND DISPLAY THE ACTIVE HUD
	if Globals.HUD_STATE == "HUD":
		# hide the non-active elements
		# update the icons for the player's avatar
		icon_update() # update the hud
	elif Globals.HUD_STATE == "DIALOGUE":
		pass
	elif Globals.HUD_STATE == "INTERACTION":
		pass


func icon_update():
	# keeps the HUD status bars and labels updated
	# set FIGHTER HUD
	if Globals.player_class == "Fighter":
		HEALTH_LABEL.text = str(Globals.player_hp, "/", Globals.player_max_hp)
		HEALTH_BAR.value = Globals.player_hp
		SHIELD_LABEL.text = str(Globals.shield_hp, "/", Globals.shield_max_hp) # set the shield HP label
		SHIELD_BAR.value = Globals.shield_hp
		SWORD_LABEL.text = str(Globals.sword_hp, "/", Globals.sword_max_hp)
		SWORD_BAR.value = Globals.sword_hp
		STAMINA_BAR.value = Globals.stamina_points
		F_GOLD_LABEL.text = str(Globals.player_gold)
	else:
		print("ERROR: INCORRECT PLAYER CLASS SET!!!")
		get_tree().quit() # exit the game after the error
