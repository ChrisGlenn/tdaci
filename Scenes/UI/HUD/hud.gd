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
# variables
var health_fractions : float = 0 # holds the health fractions
var stamina_fractions : float = 0 # holds the stamina fractions
var mana_fractions : float = 0 # holds the mana fractions


func _ready():
    self.visible = true # DEBUGGING show the HUD
    # set the HUD
    HEART_LABEL.text = str(Globals.player_hp, "/", Globals.player_max_hp) # set the player's HP label
    # set FIGHTER HUD
    if Globals.player_class == "Fighter":
        SHIELD_LABEL.text = str(Globals.shield_hp, "/", Globals.shield_max_hp) # set the shield HP label
        SWORD_LABEL.text = str(Globals.sword_hp, "/", Globals.sword_max_hp)
        F_GOLD_LABEL.text = str(Globals.player_gold)
    # run the icon update function
    icon_update()

func _process(_delta):
    pass


func icon_update():
    # a function to update the hud icons based on their relative stat
    # the stat will be divided based on the number of frames and then each frame will
    # correspond to the current stat amount based on that division
    # none of that probably made sense but no one will read this so who cares
    pass