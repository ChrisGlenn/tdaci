extends Area2D
# FIREPLACE
# this is where the player can start a fire and save their game while also
# resting and regaining HP back
# if there are status effects in this game this will NOT heal them
@onready var ANIM = $AnimatedSprite2D
@export_multiline var intro : String = "" # the text that will appear when the player enters the fireplace area
var STATE : String = "EMPTY" # EMPTY, or FIRE


func _ready() -> void:
	ANIM.visible = false # hide the fire/smoke
	ANIM.frame = Globals.frame # set the animation frame

func _process(_delta: float) -> void:
	if STATE == "EMPTY":
		if ANIM.visible != false: ANIM.visible = false # hide the sprite if state isn't FIRE
	elif STATE == "FIRE":
		if ANIM.visible != true: ANIM.visible = true # show the fire
		else:
			ANIM.frame = Globals.frame # animate the frame


func _on_body_exited(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		pass

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("PLAYER"):
		pass
