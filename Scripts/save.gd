extends Node
# Save Script
# saves the game to one of four slots
var slot_one = "user://save_one.ci"
var slot_two = "user://save_two.ci"
var slot_three = "user://save_three.ci"
var slot_four = "user://save_four.ci"

# save function
# the numbers for the data labels are just random to stop anyone from reading the .ci files
# and editing their own saves (128 to 256)
func save_data(save_slot : int):
	# set the dictionary that holds the variables to save
	var _save_data = {
		"158": Globals.player["name"],
		"156": Globals.player["class"],
		"199": Globals.player["level"],
		"216": Globals.player["hp"],
		"150": Globals.player["max_hp"],
		"134": Globals.player["mp"],
		"185": Globals.player["max_mp"],
		"226": Globals.player["xp"],
		"230": Globals.player["xp_to"],
		"212": Globals.player["current_status"],
		"137": Globals.player["current_weight"],
		"145": Globals.player["carry_capacity"],
		"166": Globals.player["encumbered"]
	}
	# save to the chosen save slots
	if save_slot == 1:
		# save to slot one
		# var file = File.new()
		# file.open(slot_one, file.WRITE)
		# file.store_var(save_data)
		# print("Game Saved to Slot One!!!")
		# file.close()
		pass
	elif save_slot == 2:
		# save to slot two
		# var file = File.new()
		# file.open(slot_two, file.WRITE)
		# file.store_var(save_data)
		# print("Game Saved to Slot Two!!!")
		# file.close()
		pass
	elif save_slot == 3:
		# save to slot three
		# var file = File.new()
		# file.open(slot_three, file.WRITE)
		# file.store_var(save_data)
		# print("Game Saved to Slot Three!!!")
		# file.close()
		pass
	elif save_slot == 4:
		# save to slot four
		# var file = File.new()
		# file.open(slot_four, file.WRITE)
		# file.store_var(save_data)
		# print("Game Saved to Slot Four!!!")
		# file.close()
		pass