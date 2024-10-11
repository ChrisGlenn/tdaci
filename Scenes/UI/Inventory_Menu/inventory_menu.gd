extends CanvasLayer
# INVENTORY SCRIPT
# the inventory script controls the inventory screen (brilliant) along with the equipment
# display
var cur_pos : int = 0 # inventory select cursor position


func _ready() -> void:
    get_tree().paused = true # pause the game
    visible = true # show the inventory screen AFTER updating

func _process(_delta: float) -> void:
    inventory_control() # the control function


func inventory_control():
    if Input.is_action_just_pressed("ci_B"):
        get_tree().paused = false # unpause the game
        queue_free() # delete the inventory instance