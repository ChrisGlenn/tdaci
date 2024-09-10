extends CanvasLayer
# SCENE TRANSITION
# this transition will go into the battleground
@onready var ANIM_PLAYER = $AnimationPlayer
var scene_to : String = "res://Scenes/Battleground/battleground.tscn"


func _ready() -> void:
	ANIM_PLAYER.play("battle_start")

func _on_animation_player_animation_finished(_anim_name:StringName) -> void:
	var _change_scene = get_tree().change_scene_to_file(scene_to) # change the scene once the animation finishes
	queue_free() # delete self
