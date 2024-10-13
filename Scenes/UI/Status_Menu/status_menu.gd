extends CanvasLayer
# STATUS MENU
# gives an overview of the payer's stats and equipment along with health information
# this screen starts with no visibility and then becomes visible after setting the information to stop any
# glitches showing the default label text
@onready var PLAYER_NAME = $Player_Name_Label
@onready var PLAYER_CLASS = $Class_Text
@onready var PLAYER_HP = $HP_Text
@onready var PLAYER_MP = $MP_Text
@onready var PLAYER_STAT = $Stat_Text
@onready var PLAYER_WEIGHT = $Weight_Text
@onready var PLAYER_XP = $CurrentXP_Text
@onready var PLAYER_NEXT_LEVEL = $NextXP_Text
@onready var PLAYER_STR = $STR_Text
@onready var PLAYER_STR_MOD = $STR_MOD_Text
@onready var PLAYER_END = $END_Text
@onready var PLAYER_END_MOD = $END_MOD_Text
@onready var PLAYER_AGI = $AGI_Text
@onready var PLAYER_AGI_MOD = $AGI_MOD_Text
@onready var PLAYER_INT = $INT_Text
@onready var PLAYER_INT_MOD = $INT_MOD_Text
@onready var PLAYER_CHR = $CHR_Text
@onready var PLAYER_CHR_MOD = $CHR_MOD_Text
@onready var PLAYER_BONUS = $BONUS_Text


func _ready() -> void:
    # set the player information
    get_tree().paused = true # pause the game
    PLAYER_NAME.text = Globals.player["name"] # set the player name
    PLAYER_CLASS.text = Globals.player["class"] # set the player class
    PLAYER_HP.text = str(Globals.player["hp"], "/", Globals.player["max_hp"]) # set the player HP
    PLAYER_MP.text = str(Globals.player["mp"], "/", Globals.player["max_mp"]) # set the player MP
    PLAYER_STAT.text = Globals.player["current_status"] # set player status
    PLAYER_WEIGHT.text = str(Globals.player["current_weight"], "/", Globals.player["carry_capacity"]) # set carry weight
    PLAYER_XP.text = str(Globals.player["xp"]) # set the current player XP
    PLAYER_NEXT_LEVEL.text = str(Globals.player["xp_to"]) # set the XP needed for the next level
    PLAYER_STR.text = str(Globals.player["STR"]) # set player STR
    PLAYER_STR_MOD.text = str(Globals.player["STR_MOD"]) # set player STR_MOD
    PLAYER_END.text = str(Globals.player["END"]) # set player END
    PLAYER_END_MOD.text = str(Globals.player["END_MOD"]) # set player END_MOD
    PLAYER_AGI.text = str(Globals.player["AGI"]) # set player AGI
    PLAYER_AGI_MOD.text = str(Globals.player["AGI_MOD"]) # set player AGI_MOD
    PLAYER_INT.text = str(Globals.player["INT"]) # set player INT
    PLAYER_INT_MOD.text = str(Globals.player["INT_MOD"]) # set player INT_MOD
    PLAYER_CHR.text = str(Globals.player["CHR"]) # set player CHR
    PLAYER_CHR_MOD.text = str(Globals.player["CHR_MOD"]) # set player CHR_MOD
    PLAYER_BONUS.text = str(Globals.player["bonus"]) # set player bonus mod
    visible = true # show after setting all the player stats

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ci_B") or Input.is_action_just_pressed("ci_START"):
        get_tree().paused = false # unpause the rest of the game
        queue_free() # delete self