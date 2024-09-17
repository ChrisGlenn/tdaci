extends Node2D
# FIGHTER BATTLER SCRIPT
# if the player is the fighter class then this is the battler for them!
@onready var FIGHTER_ANIM = $Animation_Fighter
@onready var RNG = RandomNumberGenerator.new()
@export var cool_down : int = 60 # cool down period between movements
@export var stamina_regen : int = 4 # period in between stamina regen
var FIGHTER_STATE : String = "IDLE" # IDLE, HIT, ATTACK, BLOCK, DEAD, DODGE_LEFT, DODGE_RIGHT, DODGE_BACK, FATIGUED, CASTING, ITEM, CHARGED, CHARGING
var detect_input : bool = true # used to control input detection
var attack_build : int = 0 # when it gets to 100 the player can attack
var cool_down_rec # keeps track of cool_down
var stamina_regen_rec # holds the stamina_regen setting
var is_blocking : bool = false # true if the player is blocking


func _ready():
	RNG.randomize() # seed random
	cool_down_rec = cool_down # record the cool_down setting
	stamina_regen_rec = stamina_regen # record the stamina_regen setting
	FIGHTER_ANIM.play("idle")

func _physics_process(delta):
	fighter_control(delta) # fighter control function


func fighter_control(clock):
	# the fighter ai is totally dependent on the player's input so there IS no ai
	# the fighter will stay idle until player input is detected or the player is hit or killed
	if Globals.player_hp > 0:
		# MOVEMENT/INPUT
		# movement cool down
		if cool_down > 0:
			cool_down -= clock * Globals.timer_ctrl # decrement cool_down
		else:
			if detect_input:
				# check for input from the player and then check from there
				# DODGE LEFT
				if Input.is_action_just_pressed("ci_LEFT"):
					FIGHTER_ANIM.play("dodge_left") # play the animation
					# decrement stamina check
					detect_input = false # stop input detection
					Globals.stamina_points -= 30
				# DODGE RIGHT
				if Input.is_action_just_pressed("ci_RIGHT"):
					FIGHTER_ANIM.play("dodge_right") # play the animation
					# decrement stamina check
					detect_input = false # stop input detection
					Globals.stamina_points -= 30
				# DODGE BACK
				if Input.is_action_just_pressed("ci_DOWN"):
					FIGHTER_ANIM.play("dodge_back") # play the animation
					# decrement stamina check
					detect_input = false # stop input detection
				# ATTACK
				if Input.is_action_just_pressed("ci_A"):
					Globals.player_attack = true # the player is attacking
					FIGHTER_ANIM.play("attack") # play the animation
					# decrement stamina
					Globals.stamina_points -= 60 # DEBUG
					detect_input = false # stop input detection
				# BLOCK
				if Input.is_action_just_pressed("ci_B"):
					FIGHTER_ANIM.play("block") # play the animation
					# decrement stamina if hit

		# STAMINA REGENERATION
		if Globals.stamina_points > 0:
			# if the player's stamina is above 0 (not fatigued)
			# then the stamina will slowly regenerate
			if Globals.stamina_points < Globals.stamina_max_points:
				if stamina_regen > 0:
					stamina_regen -= clock * Globals.timer_ctrl # decrement
				else:
					Globals.stamina_points += 1 # increment player stamina
					stamina_regen = stamina_regen_rec # reset the stamina regen
			else:
				Globals.stamina_points = Globals.stamina_max_points # stop it from going OVER 100
		else:
			# the player is fatigued
			# the player will stay fatigued until stamina is regenerated back to 100
			FIGHTER_ANIM.play("fatigued") # play the fatigued animation
			if Globals.stamina_points < Globals.stamina_max_points:
				if stamina_regen > 0:
					stamina_regen -= clock * Globals.timer_ctrl # decrement
				else:
					Globals.stamina_points += 1 # increment player stamina
					stamina_regen = stamina_regen_rec # reset the stamina regen
			else:
				FIGHTER_ANIM.play("idle")
				detect_input = true
				Globals.stamina_points = Globals.stamina_max_points # stop it from going OVER 100
	else:
		# PLAYER IS DEAD
		pass


func _on_animation_fighter_animation_finished(anim_name):
	# this function plays when the animation player is done playing
	if anim_name == "dodge_left" or anim_name == "dodge_right" or anim_name == "dodge_back":
		cool_down = cool_down_rec # reset the cool_down period
		detect_input = true # hand back control to the player
		FIGHTER_ANIM.play("idle") # play the idle animation
	elif anim_name == "attack":
		Globals.player_attack = false # player is no longer attacking...
		cool_down = cool_down_rec # reset the cool_down period
		detect_input = true # hand back control to the player
		FIGHTER_ANIM.play("idle") # play the idle animation

func _on_fighter_body_area_entered(area):
	# this detects when another area has entered the 'fighter_body' area
	if area.is_in_group("ENEMY"):
		# if the player state is block then decrement stamina otherwise
		# do damage to the player based on the
		print("HIT!!") # DEBUG
