extends CanvasLayer
# STATUS MENU
# gives an overview of the payer's stats and equipment along with health information
# this screen starts with no visibility and then becomes visible after setting the information to stop any
# glitches showing the default label text
@onready var PLAYER_NAME = $Player_Name_Label


func _ready() -> void:
    # set the player information
    PLAYER_NAME.text = Globals.player["name"] # set the player name
    visible = true # show after setting all the player stats