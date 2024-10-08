extends Area2D
# STAIRS
# the stairs the player will use to go up or down in level in the castle
@onready var ANIM_SPRITE = $Stairs_Sprite
@export_enum("Up", "Down") var stair_type : String = "Up" # defaults to up
@export var level_choice : bool = false # if true the player will be given a choice of what floor to go to


func _ready():
	# set the animation based on the stair_type
	if stair_type == "Up": ANIM_SPRITE.play("stairs_up")
	elif stair_type == "Down": ANIM_SPRITE.play("stairs_down")

func _process(_delta: float) -> void:
	ANIM_SPRITE.frame = Globals.frame # timed animation


func _on_area_entered(area):
	if area.is_in_group("PLAYER"):
		# the player is in the stairs so check which way they are going
		# then make the player non-visible and load the next level
		pass
