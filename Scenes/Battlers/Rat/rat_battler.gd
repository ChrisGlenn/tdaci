extends Node2D
# THE RAT!!
# a rat enemy that just does basic attacks and blocks some incoming attacks
# this is the first enemy of the game and does minimal damage
@onready var RAT_ANIM = $Animation_Rat
@onready var RNG = RandomNumberGenerator.new()
@export var enemy_name : String = "RAT" # name of the enemy
@export var xp_gained : int = 100 # the experience points given to the player after defeat
@export var hit_points : int = 30 # rat's hit points
@export var attack_chance : int = 4 # 1 to 10 if it's lower than this number incrementer goes up
@export var rat_incrementer : int = 10 # how much the temperment rises
@export var rat_block_incrementer : int = 50 # defaults to 50
@export var block_cooldown : int = 100 # this cool down period has the rat ALWAYS blocking
@export var rat_state_timer : int = 60 # every time this hits zero the rat will check and see it's next move
@export var death_timer : int = 200 # the amount of countdown time after the rat dies to end the battle
var RAT_STATE : String = "IDLE" # IDLE, ATTACK, DEAD, BLOCK
var rat_temperment : int = 0 # when it reaches 100 the rat will attack
var rat_block : int = 0 # when it reaches a set point the rat will defend against a hit
var rat_attack_dir : int = 0 # 0 is left 1 is right
var is_hit : bool = false # if the rat is hit
var will_block : bool = false # if the rat will block the next hit
var block_cooldown_rec # records the block_cooldown setting


func _ready():
	RNG.randomize() # seed random
	block_cooldown_rec = block_cooldown # record the block_cooldown setting

func _process(delta):
	rat_ai(delta)


func rat_ai(clock):
	# THE BRAINS OF THE RAT
	# The rat_state_timer will count down to 0 and the rat will then decide, based on a series of variables,
	# what the next best move is. The rat will also respond, possibly, to the player's attacks based on whether they
	# were just hit. The rat is a 'dumb' enemy so it's blocking isn't really refined.
	# check the rat state 
	if hit_points > 0:
		if RAT_STATE == "IDLE":
			# the rat is idle meaning it's waiting for the player to move
			RAT_ANIM.play("idle") # play the idle animation
			if rat_state_timer > 0: 
				rat_state_timer -= clock * Globals.timer_ctrl # decrement timer
				if will_block:
					# the rat has been set to block the next attack
					if Globals.player_attack:
						RAT_STATE = "BLOCK" # set the rat to block
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
		elif RAT_STATE == "BLOCK":
			RAT_ANIM.play("block") # play the block animation
		elif RAT_STATE == "DEAD":
			# the rat has died
			RAT_ANIM.play("die") # play the death animation and wait until it ends
		# CHECK IF THE RAT IS HIT AND MODULATE THE COLOR TO RED
		if is_hit and RAT_STATE != "BLOCK":
			# if the rat is not blocking and gets hit
			# make the rat flash with the set red color
			# decrement the rat's health and reset the rat_defense to 0
			RAT_STATE = "IDLE" # return the RAT_STATE back to idle
			# block defense settings
			rat_temperment += 50 # half of 100 increase
			rat_block += rat_block_incrementer # increse the rat_defense
			if rat_block >= 100:
				will_block = true # the rat WILL block the next attack
			is_hit = false # hit is done
		# BLOCK COOLDOWN CONTROL
		if will_block:
			if block_cooldown > 0:
				block_cooldown -= clock * Globals.timer_ctrl # decrement the timer
			else:
				will_block = false # the rat will no longer block all attacks
	else:
		# THE RAT IS DEAD
		RAT_ANIM.play("die") # play the dead animation
		self.visible = !self.visible # flash the rat!


func _on_animation_rat_animation_finished(anim_name):
	if anim_name == "attack_left" or anim_name == "attack_right":
		rat_temperment = 0 # reset the temperment
		RAT_STATE = "IDLE" # return to IDLE after ATTACKING
	elif anim_name == "hit":
		RAT_STATE = "IDLE" # return to IDLE after HIT
	elif anim_name == "block":
		rat_block = 0 # reset the rat_defense (used for blocking)
		# will_block = false # rat will NOT block next round
		block_cooldown = block_cooldown_rec # reset the block cooldown
		rat_state_timer = 60 # reset the timer
		RAT_STATE = "IDLE"

func _on_rat_head_area_entered(area):
	if area.is_in_group("PLAYER_SWORD"):
		# the rat is HIT
		if RAT_STATE != "BLOCK":
			is_hit = true
			$Rat_Head/RH_Sprite.modulate = Color(0.424,0.161,0.251) # module hit color
			var damage = Functions.melee_hit(Globals.player_strength, Globals.sword_attack) # calculate damage
			hit_points -= damage # apply damage to RAT
			print("RAT BLOCKED!!!")
		else:
			print("RAT HIT!!!", hit_points) # DEBUG

func _on_rat_head_area_exited(area):
	if area.is_in_group("PLAYER_SWORD"):
		$Rat_Head/RH_Sprite.modulate = Color(1,1,1) # make sure the color is reset on area exit