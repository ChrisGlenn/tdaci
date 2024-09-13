extends StaticBody2D
# WATER
# water tiles that animate with the Globals frame
func _process(_delta: float) -> void:
    $AnimatedSprite2D.frame = Globals.frame # sync the frame with the Globals frame