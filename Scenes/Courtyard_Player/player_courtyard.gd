extends AnimatedSprite2D
# COURTYARD PLAYER
# the player avatar when the player is in the courtyard
# this character just moves to selected spaces
var courtyard_position : int = 0 # 0 is the gate


func _ready() -> void:
    frame = Globals.frame # sync the frame with the Global frame

func _process(_delta: float) -> void:
    frame = Globals.frame # sync the fram with the Global frame


func movement():
    match courtyard_position:
        0:
            # main gate
            pass