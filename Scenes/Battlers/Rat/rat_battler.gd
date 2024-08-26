extends Node2D
# THE RAT!!
# a rat enemy that just does basic attacks and blocks some incoming attacks
# this is the first enemy of the game and does minimal damage
@onready var RAT_ANIM = $Animation_Rat
@onready var RNG = RandomNumberGenerator.new()
@export var hit_points : int = 50 # rat's hit points
@export var defense : int = 20 # rat's defense points
@export var attack_chance : int = 4 # 1 to 10 if it's lower than this number incrementer goes up
@export var rat_incrementer : int = 10 # how much the temperment rises
@export var rat_state_timer : int = 60 # every time this hits zero the rat will check and see it's next move
var RAT_STATE : String = "IDLE" # IDLE, ATTACK, DEAD, BLOCK
var rat_temperment : int = 0 # when it reaches 100 the rat will attack
var rat_defense : int = 0 # when it reaches a set point the rat will defend against a hit
var rat_attack_dir : int = 0 # 0 is left 1 is right
var is_hit : bool = false # if the rat is hit
var hit_timer : int = 10 # 


func _ready():
	RNG.randomize() # seed random

func _process(delta):
	rat_ai(delta)


func rat_ai(clock):
	# THE BRAINS OF THE RAT
	# The rat_state_timer will count down to 0 and the rat will then decide, based on a series of variables,
	# what the next best move is. The rat will also respond, possibly, to the player's attacks based on whether they
	# were just hit. The rat is a 'dumb' enemy so it's blocking isn't really refined.
	# check the rat state 
	if RAT_STATE == "IDLE":
		# the rat is idle meaning it's waiting for the player to move
		RAT_ANIM.play("idle") # play the idle animation
		if rat_state_timer > 0: rat_state_timer -= clock * Globals.timer_ctrl # decrement timer
		else:
			# run through some checks to get next action
			if !hit_points < 5:
				if rat_temperment < 100:
					var random_increment = RNG.randi_range(1,10)
					if random_increment <= attack_chance:
						rat_temperment += rat_incrementer
						rat_state_timer = 60 # reset the timer
					else:
						rat_state_timer = 60 # reset the timer
				else:
					var attack_direction = RNG.randi_range(0,1)
					rat_attack_dir = attack_direction # set the attack direction based off random
					RAT_STATE = "ATTACK"
	elif RAT_STATE == "ATTACK":
		rat_state_timer = 60 # reset the timer
		if rat_attack_dir == 0: RAT_ANIM.play("attack_left")
		elif rat_attack_dir == 1: RAT_ANIM.play("attack_right")
	elif RAT_STATE == "DEAD":
		# the rat has died
		RAT_ANIM.play("die") # play the death animation and wait until it ends
	# CHECK IF THE RAT IS HIT AND MODULATE THE COLOR TO RED
	if is_hit:
		pass


func _on_animation_rat_animation_finished(anim_name):
	if anim_name == "attack_left" or anim_name == "attack_right":
		rat_temperment = 0 # reset the temperment
		RAT_STATE = "IDLE" # return to IDLE after ATTACKING
	elif anim_name == "hit":
		RAT_STATE = "IDLE" # return to IDLE after HIT


func _on_rat_head_area_entered(area):
	if area.is_in_group("PLAYER"):
		# the rat is HIT
		pass
