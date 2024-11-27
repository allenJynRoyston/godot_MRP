extends PanelContainer

@onready var BasePhase = $BasePhase
@onready var SimpleGUI = $SimpleGUI
@onready var ResourceGUI = $ResourceGUI

var phase_arr:Array = [story_phase, base_phase, assign_phase, action_phase, event_phase, xp_phase, spend_phase]
var control_arr:Array = []
var secondary_control_arr:Array = []

var current:Dictionary = {
	"phase": 0,
	"day": 0,
	"control": -1,
	"secondary_control": 0,
	"enable_tabblable": true,
	"enable_next": true,
	"enable_floor_change": true,
	"enable_save_load": true
}

var player_resources:Dictionary = {
	"money": {
		"balance": 200,
		"change_rate": 0
	},
	"energy": {
		"balance": 10,
		"change_rate": 0
	},
	"staff": {
		"total": 0,
		"assigned": 0,
		"capacity": 0
	},
	"dclass": {
		"total": 0,
		"capacity": 0,
		"assigned": 0,
	}
}

var base_phase_data:Dictionary = {
	"built": {
		0: [],
		1: [],
		2: [],
		3: []
	},
	"purchase_list": [],
	"floor_selection": 0
} : 
	set(new_val):
		base_phase_data = new_val
		BasePhase.data = new_val
		ResourceGUI.data = new_val
		

# -----------------------------------
func _ready() -> void:
	control_arr = [SimpleGUI, BasePhase, ResourceGUI]
	secondary_control_arr = [SimpleGUI, ResourceGUI]
	restore_game()
# -----------------------------------
	
# -----------------------------------
#region SAVE/LOAD
func quicksave() -> void:
	var save_data = {
		"current": current,
		"base_phase_data": base_phase_data,
		"player_resources": player_resources
	}	
	var res = FileSys.save_file(FileSys.FILE.QUICK_SAVE, save_data)
	print("saved game: ", res)

func quickload() -> void:
	var res = FileSys.load_file(FileSys.FILE.QUICK_SAVE)		
	if res.success:
		restore_game(res.filedata.data)
	print("quickload game: ", res.success)
		
func restore_game(restore_data:Dictionary = {}) -> void:
	activate_controls_for()
	current = restore_data.current if !restore_data.is_empty() else current
	base_phase_data = restore_data.base_phase_data if !restore_data.is_empty() else base_phase_data
	player_resources = restore_data.player_resources if !restore_data.is_empty() else player_resources
	
	# assign data to nodes
	ResourceGUI.player_resources = player_resources
	
	phase_arr[current.phase].call()	
	
	
#endregion		
# -----------------------------------			
	
# -----------------------------------
func next() -> void:
	current.phase = (current.phase + 1) % phase_arr.size()
	if current.phase == 0:
		current.day += 1
	phase_arr[current.phase].call()
# -----------------------------------

# -----------------------------------
func update_gui(phase:String, summary:String) -> void:
	SimpleGUI.data = {
		"day_text": "Day: %s:" % [current.day],
		"phase_text": "Phase: %s (%s)" % [current.phase, phase],
		"summary_text": "Summary: %s" % [summary]
	}
# -----------------------------------

# -----------------------------------
#region STORY
func story_phase() -> void:	
	# set enable rules
	current.enable_next = false
	current.enable_tabblable = true
	
	# activate controls
	activate_controls_for(SimpleGUI)
	
	#activate_controls_for(SimpleGUI)
	update_gui("story_phase", "Story goes here.")	
#endregion	
# -----------------------------------

# -----------------------------------
#region BASE
func base_phase() -> void:
	# set enable rules
	current.enable_next = false
	current.enable_tabblable = false
	
	# update GUI
	update_gui("base_phase", "Awaiting input...")
	
	# activate controls
	activate_controls_for(BasePhase)	
	await BasePhase.input_response
	
	# set enable rules / update GUI
	current.enable_next = true
	update_gui("base_phase", "You built %s on floor %s." % [5, base_phase_data.floor_selection])	
#endregion
# -----------------------------------

# -----------------------------------
#region ASSIGN
func assign_phase() -> void:
	# set enable rules
	current.enable_next = false
	current.enable_tabblable = true
	
	# update GUI
	activate_controls_for(SimpleGUI)
	
	# update GUI
	update_gui("assign_phase", "You assigned Dr. Maroon to Containment Cell 1")
#endregion
# -----------------------------------

# -----------------------------------
#region ACTION
func action_phase() -> void:
	# set enable rules
	current.enable_next = false
	current.enable_tabblable = true
	
	# update GUI
	activate_controls_for(SimpleGUI)
		
	update_gui("action_phase", "You used [POWER A] to speed up reseach on Item-01.")
#endregion
# -----------------------------------

# -----------------------------------
#region EVENT
func event_phase() -> void:
	# set enable rules
	current.enable_next = false
	current.enable_tabblable = true
	
	# update GUI
	activate_controls_for(SimpleGUI)
		
	update_gui("event_phase", "Item 01 reactived violently, killing 3 staff and 10 D-Class.")
#endregion
# -----------------------------------

# -----------------------------------
#region XP
func xp_phase() -> void:
	# set enable rules
	current.enable_next = false
	current.enable_tabblable = true
	
	# update GUI
	activate_controls_for(SimpleGUI)
		
	update_gui("xp_phase", "You gained 10xp from Item 01.")
#endregion
# -----------------------------------

# -----------------------------------
#region SPEND
func spend_phase() -> void:
	# set enable rules
	current.enable_next = false
	current.enable_tabblable = true
	
	# update GUI
	activate_controls_for(SimpleGUI)
		
	update_gui("spend_phase", "You unlocked [HISTORY] on Item 01.")
#endregion
# -----------------------------------

#region CONTROLS 
# -----------------------------------	
func activate_controls_for(val:Node = null) -> void:
	if val != null:
		var index = control_arr.find(val)
		current.control = index	
	
	for i in range(control_arr.size()):
		control_arr[i].is_active = i == current.control
# -----------------------------------	

# -----------------------------------	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		# --------------------------
		if current.control != -1 and "on_key_input" in control_arr[current.control]:
			control_arr[current.control].on_key_input(event.keycode)
		
		# --------------------------
		if current.enable_tabblable:
			match event.keycode: 
				# tab
				4194306:
					current.secondary_control = (current.secondary_control + 1) % secondary_control_arr.size()
					activate_controls_for(secondary_control_arr[current.secondary_control])
					
		# --------------------------
		if current.enable_floor_change:
			match event.keycode: 
				# 0
				48: 
					base_phase_data.floor_selection = 0
					base_phase_data = base_phase_data.duplicate()
				# 1
				49: 
					base_phase_data.floor_selection = 1
					base_phase_data = base_phase_data.duplicate()
				# 2
				50: 
					base_phase_data.floor_selection = 2
					base_phase_data = base_phase_data.duplicate()
				# 3
				51: 
					base_phase_data.floor_selection = 3
					base_phase_data = base_phase_data.duplicate()
					
		# --------------------------
		if current.enable_next:
			match event.keycode:
				# space
				32: next()
				
		# --------------------------
		if current.enable_save_load:
			match event.keycode:
				# 5
				53: quicksave() 
				# 8 key
				56: quickload()
# -----------------------------------		
#endregion
