extends CanvasLayer
# QUEST MENU SCRIPT
# the player is given a list of the current quests they are on along with a text screen that shows the
# details of said quest
@onready var QUESTS = $List_Background/Quests
@onready var SELECTORS = $List_Background/Selectors
@onready var QUEST_TITLE = $Quest_Background/Quest_Title
@onready var QUEST_TEXT = $Quest_Background/Quest_Text
@onready var QUEST_STATUS = $Quest_Background/Quest_Status
@onready var RETURN = $Quest_Background/Press_Return
var sel_pos : int = 0 # tracks the player's position


func _ready() -> void:
	get_tree().paused = true # pause the game
	# loop through the Globals quests and then set the descriptions/titles
	if Globals.quests.size() == 0:
		QUEST_TEXT.text = "You have no current quests..."
	else:
		# iterate through the quests to get the list populated
		for n in Globals.quests.size():
			SELECTORS.get_child(n).visible = true # show the selector
			QUESTS.get_child(n).visible = true
			QUEST_STATUS.visible = true
			QUESTS.get_child(n).text = Globals.quests[n]["title"]
		SELECTORS.get_child(sel_pos).frame = 1 # show the selected selector
	update_journal() # run the journal ui
	RETURN.text = str("Press ", Globals.cancel_button, " to close.")
	visible = true # show the journal

func _process(_delta: float) -> void:
	journal_selection() # journal function


func journal_selection():
	if Globals.quests.size() > 0:
		# update the selector
		SELECTORS.get_child(sel_pos).frame = 1
		# move up and down
		if Input.is_action_just_pressed("ci_DOWN"):
			if sel_pos < Globals.quests.size()-1:
				sel_pos += 1
				update_journal()
				SELECTORS.get_child(sel_pos - 1).frame = 0 # reset previous frame
		if Input.is_action_just_pressed("ci_UP"):
			if sel_pos > 0:
				sel_pos -= 1
				update_journal()
				SELECTORS.get_child(sel_pos + 1).frame = 0 # reset previous frame
	# close the journal
	if Input.is_action_just_pressed("ci_B") or Input.is_action_just_pressed("ci_START"):
		get_tree().paused = false # unpase the game
		queue_free() # delete self

func update_journal():
	# update the journal gui
	for i in Globals.quests.size():
		if i == sel_pos:
			QUEST_TITLE.text = Globals.quests[i]["title"]
			QUEST_TEXT.text = Globals.quests[i]["description"]
			QUEST_STATUS.text = str("Status: ", Globals.quests[i]["status"])
