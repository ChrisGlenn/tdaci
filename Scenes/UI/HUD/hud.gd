extends CanvasLayer
# GAME HUD
# the heads up display for the game
# will differ in the information that it displays depending on the character class
@onready var HEART_SPRITE = $Health_Icon
@onready var HEART_LABEL = $Health_Label
# FIGHTER
@onready var SHIELD_SPRITE = $Fighter/Shield_Icon
@onready var SHIELD_LABEL = $Fighter/Shield_Label
@onready var SWORD_SPRITE = $Fighter/Sword_Icon
@onready var SWORD_LABEL = $Fighter/Sword_Label
@onready var F_GOLD_LABEL = $Fighter/Gold_Label


func _ready():
    self.visible = true # DEBUGGING show the HUD
    # set the HUD
    HEART_LABEL.text = str(Globals.player_hp, "/", Globals.player_max_hp) # set the player's HP label
    # set FIGHTER HUD
    if Globals.player_class == "Fighter":
        SHIELD_LABEL.text = str(Globals.shield_hp, "/", Globals.shield_max_hp) # set the shield HP label
        SWORD_LABEL.text = str(Globals.sword_hp, "/", Globals.sword_max_hp)
        F_GOLD_LABEL.text = str(Globals.player_gold)
    # RUN A FUNCTION TO UPDATE THE HUD ICONS HERE