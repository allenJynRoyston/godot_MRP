extends PanelContainer

@onready var BaseReadout = $BaseReadout
@onready var SimpleGUI = $SimpleGUI

var phases:Array = [base_phase, assign_phase, action_phase, event_phase, xp_phase, spend_phase]
var control_schemes:Array = [controls_gameplay, controls_change_level]

var current_phase:int = -1
var current_day:int = 0
var current_control:int = 0

var base_data:Dictionary = {
	0: [],
	1: [],
	2: [],
	3: []
} : 
	set(new_val):
		base_data = new_val
		BaseReadout.data = base_data
		
var build_on_floor:int = -1 : 
	set(new_val):
		if build_on_floor != new_val:
			build_on_floor = new_val
			BaseReadout.on_floor = build_on_floor

# -----------------------------------
func _ready() -> void:
	build_on_floor = 0
	update_gui("game_start", "")	
	update_controls()
# -----------------------------------
	
# -----------------------------------
#region SAVE/LOAD
func quicksave() -> void:
	var save_data = {
		"current_control": current_control,
		"current_phase": current_phase,
		"current_day": current_day,
		"build_on_floor": build_on_floor,
		"base_data": base_data
	}	
	var res = FileSys.save_file(FileSys.FILE.QUICK_SAVE, save_data)

func quickload() -> void:
	var res = FileSys.load_file(FileSys.FILE.QUICK_SAVE)		
	if res.success:
		restore_game(res.filedata.data)
		
func restore_game(restore_data:Dictionary) -> void:
	current_control = restore_data.current_control
	current_phase = restore_data.current_phase
	current_day = restore_data.current_day
	build_on_floor = restore_data.build_on_floor
	base_data = restore_data.base_data
	phases[current_phase].call()	
	update_controls()
	
#endregion		
# -----------------------------------			
	
# -----------------------------------
func next() -> void:
	current_phase = (current_phase + 1) % phases.size()
	if current_phase == 0:
		current_day += 1
	phases[current_phase].call()


func update_controls() -> void:
	for item in [BaseReadout, SimpleGUI]:
		item.is_active = false
	
	match current_control:
		0: 
			SimpleGUI.is_active = true
		1: 
			BaseReadout.is_active = true
# -----------------------------------

# -----------------------------------
func update_gui(phase:String, summary:String) -> void:
	SimpleGUI.day_text = "Day: %s:" % [current_day]
	SimpleGUI.phase_text = "Phase: %s (%s)" % [current_phase, phase]
	SimpleGUI.summary_text = "Summary: %s" % [summary]
# -----------------------------------

# -----------------------------------
#region BASE
func base_phase() -> void:
	var selected := "Barricks"
	
	base_data[build_on_floor].push_back(selected)
	base_data = base_data.duplicate()

	update_gui("base_phase", "You built %s on floor %s." % [selected, build_on_floor])	
#endregion
# -----------------------------------

# -----------------------------------
#region ASSIGN
func assign_phase() -> void:
	update_gui("assign_phase", "You assigned Dr. Maroon to Containment Cell 1")
#endregion
# -----------------------------------

# -----------------------------------
#region ACTION
func action_phase() -> void:
	update_gui("action_phase", "You used [POWER A] to speed up reseach on Item-01.")
#endregion
# -----------------------------------

# -----------------------------------
#region EVENT
func event_phase() -> void:
	update_gui("event_phase", "Item 01 reactived violently, killing 3 staff and 10 D-Class.")
#endregion
# -----------------------------------

# -----------------------------------
#region XP
func xp_phase() -> void:
	update_gui("xp_phase", "You gained 10xp from Item 01.")
#endregion
# -----------------------------------

# -----------------------------------
#region SPEND
func spend_phase() -> void:
	update_gui("spend_phase", "You unlocked [HISTORY] on Item 01.")
#endregion
# -----------------------------------

# -----------------------------------	
func controls_save_and_load(keycode:int) -> void:
	match keycode: 
		# tab
		4194306: 
			current_control = (current_control + 1) % control_schemes.size()
			update_controls()
		# 5 key
		53: quicksave() 
		# 8 key
		56: quickload()
# -----------------------------------	

# -----------------------------------	
func controls_gameplay(keycode:int) -> void:
	match keycode: 
		# space
		32: next() 
# -----------------------------------			

# -----------------------------------
func controls_change_level(keycode:int) -> void:
	match keycode: 
		# 0
		48: 
			build_on_floor = 0
		# 1
		49: 
			build_on_floor = 1
		# 2
		50: 
			build_on_floor = 2
		# 3
		51: 
			build_on_floor = 3
# -----------------------------------

# -----------------------------------	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		controls_save_and_load(event.keycode)
		control_schemes[current_control].call(event.keycode)		
# -----------------------------------		
