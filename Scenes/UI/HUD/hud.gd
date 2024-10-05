extends CanvasLayer
# HEADS UP DISPLAY
# the HUD for the game
# PLAYER INFO
@onready var PLAYER_NAME = $Player_Info/Player_Name_Label
@onready var PLAYER_HP = $Player_Info/HP_Current
@onready var PLAYER_LEVEL = $Player_Info/Current_Level
@onready var PLAYER_CLASS = $Player_Info/Class_Stat
@onready var PLAYER_GOLD = $Player_Info/Gold_Label
# TERMINAL
@onready var TERMINAL = $Terminal/Term_Text
var terminal_string : String = "" # the terminal text


func _ready() -> void:
	# update player section of HUD
	PLAYER_NAME.text = Globals.player["name"] # update player name
	PLAYER_HP.text = str(Globals.player["hp"], "/", Globals.player["max_hp"]) # update player hp
	PLAYER_LEVEL.text = str(Globals.player["level"]) # update player level
	PLAYER_CLASS.text = Globals.player["class"] # update player class
	PLAYER_GOLD.text = str(Globals.player["gold"]) # update player gold
	# show the terminal start message
	TERMINAL.text = Globals.terminal
	

func _process(_delta: float) -> void:
	update_hud() # the HUD updater that keeps all info current


func update_hud():
	# update player section of HUD
	PLAYER_NAME.text = Globals.player["name"] # update player name
	PLAYER_HP.text = str(Globals.player["hp"], "/", Globals.player["max_hp"]) # update player hp
	PLAYER_LEVEL.text = str(Globals.player["level"]) # update player level
	PLAYER_CLASS.text = Globals.player["class"] # update player class
	PLAYER_GOLD.text = str(Globals.player["gold"]) # update player gold
	# update HUD colors/sprites
	# player health turns red at certain percentage
	var danger_percentage : float = .25
	if Globals.player["hp"] == (danger_percentage * Globals.player["max_hp"]):
		PLAYER_HP.modulate = Color() # change the color to red
	else:
		PLAYER_HP.modulate = Color() # otherwise keep it yellow
	# update the terminal
	if TERMINAL.text != Globals.terminal:
		TERMINAL.text = Globals.terminal # update the terminal
