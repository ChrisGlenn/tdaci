extends CanvasLayer
# QUEST MENU SCRIPT
# the player is given a list of the current quests they are on along with a text screen that shows the
# details of said quest
@onready var QUESTS = $List_Background/Quests
@onready var SELECTORS = $List_Background/Selectors
@onready var QUEST_TITLE = $Quest_Background/Quest_Title
@onready var QUEST_TEXT = $Quest_Background/Quest_Text
@onready var RETURN = $Quest_Background/Press_Return
var sel_pos : int = 0 # tracks the player's position


func _ready() -> void:
	get_tree().paused = true # pause the game
	# loop through the Globals quests and then set the descriptions/titles
	if Globals.quests.size() == 0:
		QUEST_TEXT.text = "You have no current quests..."
	else:
		for n in Globals.quests.size():
			SELECTORS.get_child(n).visible = true # show the selector
			QUESTS.get_child(n).visible = true
			QUESTS.get_child(n).text = Globals.quests[n]["title"]
			QUEST_TITLE.visible = true
			QUEST_TITLE.text = Globals.quests[n]["title"]
			QUEST_TEXT.text = Globals.quests[n]["description"]
			if Globals.quests[n]["status"] == "complete":
				# change the color to gray
				pass
		SELECTORS.get_child(sel_pos).frame = 1 # show the selected selector
	visible = true # show the journal

func _process(_delta: float) -> void:
	journal_selection() # journal function


func journal_selection():
	if Input.is_action_just_pressed("ci_B"):
		get_tree().paused = false # unpase the game
		queue_free() # delete self
