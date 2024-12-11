extends Control

@onready var BuildGUI = $BuildGUI
@onready var SimpleGUI = $SimpleGUI
@onready var ResourceGUI = $ResourceGUI
@onready var ContainmentGUI = $ContainmentGUI

# -----------------------------------
#region local vars
var control_arr:Array = []
var secondary_control_arr:Array = []

var phase_arr:Array = [
	story_phase, 
	build_phase, recruit_phase, contain_phase, assign_phase, 
	action_phase,  event_phase, 
	xp_phase, spend_phase, 
	calc_phase, next_phase
]

var permissions:Dictionary = {
	"enable_tabblable": true,
	"enable_floor_change": true,
	"enable_save_load": true
}
#endregion
# -----------------------------------

# -----------------------------------
#region savable data
var current:Dictionary = {
	"phase": 0,
	"day": 0,
	"control": 0,
	"secondary_control": 0,
	"on_floor": 0
} : 
	set(val): 
		current = val
		on_current_update()
		
@onready var window_offsets:Dictionary = {
	BuildGUI.name: Vector2(0, 0),
	SimpleGUI.name: Vector2(0, 0),
	ResourceGUI.name: Vector2(0, 0),
	ContainmentGUI.name: Vector2(0, 0),
} : 
	set(val):
		window_offsets = val
		on_window_offsets_update()

var resource_data:Dictionary = {
	RESOURCE.MONEY: {
		"total": 200,
	},
	RESOURCE.ENERGY: {
		"total": 0,		
	},
	RESOURCE.STAFF: {
		"total": 5,		
	},
	RESOURCE.MTF: {
		"total": 0,		
	},	
	RESOURCE.DCLASS: {
		"total": 0,		
	}	
} : 
	set(val):
		resource_data = val
		on_resource_data_update()
		
var base_data:Dictionary = {
	"built": {
		0: [
			{"type": BUILDING_TYPE.DORMITORY, "props": {}},
			{"type": BUILDING_TYPE.SOLAR_PANELS, "props": {}}
		],
		1: [],
		2: [],
		3: []
	},
	"purchase_list": []
} : 
	set(new_val):
		base_data = new_val
		on_base_data_update()
			
var containment_data:Dictionary = {
	"available": [		
		{"item": SCP.ONE, "expires_in": 3},
		{"item": SCP.TWO, "expires_in": 10}
	],
	"active": [
		#{
			#"item": C.ITEM.ONE,
			#"status": {
				#"is_contained": 'pending',
				#"days_in_containment": 0,
			#},
			#"placement": {
				#"on_floor": 0
			#},
			#"assigned": {
				#"staff": 0,
				#"dclass": 0
			#}
		#}
	]
} : 
	set (val):
		containment_data = val
		on_containment_data_update()

var logs:Array = []
#endregion
# -----------------------------------

# -----------------------------------
func _init() -> void:
	GBL.register_node(REFS.GAMEPLAY_LOOP, self)
# -----------------------------------	

# -----------------------------------
func _exit_tree() -> void:
	GBL.unregister_node(REFS.GAMEPLAY_LOOP)
# -----------------------------------	

# -----------------------------------
func _ready() -> void:
	control_arr = [SimpleGUI, BuildGUI, ResourceGUI, ContainmentGUI]
	secondary_control_arr = [SimpleGUI, ResourceGUI, ContainmentGUI]
	restore_game()
# -----------------------------------

# -----------------------------------
func on_resource_data_update() -> void:
	ResourceGUI.data = resource_data
	ContainmentGUI.resources = resource_data

func on_base_data_update() -> void:
	BuildGUI.data = base_data

func on_containment_data_update() -> void:
	ContainmentGUI.data = containment_data
	
func on_current_update() -> void:
	BuildGUI.on_floor = current.on_floor	

func on_window_offsets_update() -> void:
	for key in window_offsets:
		var window_offset:Vector2 = window_offsets[key]
		for node in [SimpleGUI, ContainmentGUI, ResourceGUI, ContainmentGUI]:
			if key == node.name:
				node.window_offset = window_offset
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
	logs.push_back("Day %s (%s): %s" % [current.day, phase, summary])
# -----------------------------------

# -----------------------------------
#region SAVE/LOAD
func quicksave() -> void:
	var save_data = {
		"current": current,
		"base_data": base_data,
		"resource_data": resource_data,
		"containment_data": containment_data,
		"window_offsets": window_offsets,
		"logs": logs
	}	
	var res = FS.save_file(FS.FILE.QUICK_SAVE, save_data)
	print("saved game!")

func quickload() -> void:
	var res = FS.load_file(FS.FILE.QUICK_SAVE)		
	if res.success:
		restore_game(res.filedata.data)
	print("quickload game!")
		
func restore_game(restore_data:Dictionary = {}) -> void:
	activate_controls_for()
	var no_save:bool = restore_data.is_empty()
	
	current = restore_data.current if !no_save else current
	base_data = restore_data.base_data if !no_save else base_data	
	containment_data = restore_data.containment_data if !no_save else containment_data
	logs = restore_data.logs if !no_save else logs
	# requires call to calculate properties after base_data is available
	resource_data = restore_data.resource_data if !no_save else U.calculate_resource_properties(resource_data, base_data.built, containment_data)
	window_offsets = restore_data.window_offsets if !no_save else window_offsets
	
	phase_arr[current.phase].call()	
#endregion		
# -----------------------------------

# -----------------------------------
#region STORY
func story_phase() -> void:	
	# set enable rules
	permissions.enable_tabblable = true
	
	# activate controls
	activate_controls_for(SimpleGUI)
	
	if current.day == 0:
		update_gui("story_phase", "Aquire new SCP")	
	
	else:
		update_gui("story_phase", "Story goes here.")	
#endregion	
# -----------------------------------

# -----------------------------------
#region BUILD
func build_phase() -> void:
	# set enable rules
	permissions.enable_tabblable = false
	
	# update GUI
	update_gui("build_phase", "Awaiting input...")
	
	# activate controls
	activate_controls_for(BuildGUI)	
	var res:Dictionary = await BuildGUI.input_response

	if res.is_empty():
		activate_controls_for(SimpleGUI)
		update_gui("build_phase", "Phase skipped")	
		
	else:	
		var calc_res = U.calc_purchases(base_data, resource_data, containment_data, res)
		base_data = calc_res.base_data
		resource_data = calc_res.resources

		# set enable rules / update GUI
		activate_controls_for(SimpleGUI)
		update_gui("build_phase", "You built %s rooms." % [res.purchased.size(), "rooms" if res.purchased.size() > 1 else "room"])	
#endregion
# -----------------------------------

# -----------------------------------
#region RECRUIT
func recruit_phase() -> void:
	# set enable rules
	permissions.enable_tabblable = true
	
	# update GUI
	activate_controls_for(SimpleGUI)
	var changes = [[RESOURCE.MTF, 10], [RESOURCE.STAFF, 10], [RESOURCE.DCLASS, 10]]
	
	resource_data = U.adjust_resources(resource_data, changes)
	
	# update GUI
	update_gui("recruit_phase", "You recruited mtf, staff and dclass.")
#endregion
# -----------------------------------	

# -----------------------------------
#region CONTAIN
func contain_phase() -> void:
	# set enable rules
	permissions.enable_tabblable = false
	
	# update GUI
	update_gui("contain_phase", "Awaiting input...")
		
	# update GUI
	ContainmentGUI.inspect_mode = false
	activate_controls_for(ContainmentGUI)
	var res:Dictionary = await ContainmentGUI.input_response
	ContainmentGUI.inspect_mode = true
		
	# add selected from list to active style
	var u_res = U.containment_data_move_available_to_active(containment_data, resource_data, res.selected)
	resource_data = u_res.resource_data
	containment_data = u_res.containment_data

	# update GUI	
	activate_controls_for(SimpleGUI)
	if res.selected.size() > 0:
		update_gui("contain_phase", "You moved to contain %s %s." % [res.selected.size(), "items" if res.selected.size() > 1 else "item"])	
	else:
		update_gui("contain_phase", "Phase skipped")	
#endregion		
# -----------------------------------

# -----------------------------------
#region ASSIGN
func assign_phase() -> void:
	# set enable rules
	permissions.enable_tabblable = true
	
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
	permissions.enable_tabblable = true
	
	# update GUI
	activate_controls_for(SimpleGUI)
		
	update_gui("action_phase", "You used [POWER A] to speed up reseach on Item-01.")
#endregion
# -----------------------------------

# -----------------------------------
#region EVENT
func event_phase() -> void:
	# set enable rules	
	permissions.enable_tabblable = true
	
	# update GUI
	activate_controls_for(SimpleGUI)
		
	update_gui("event_phase", "Item 01 reactived violently, killing 3 staff and 10 D-Class.")
#endregion
# -----------------------------------

# -----------------------------------
#region XP
func xp_phase() -> void:
	# set enable rules	
	permissions.enable_tabblable = true
	
	# update GUI
	activate_controls_for(SimpleGUI)
		
	update_gui("xp_phase", "You gained 10xp from Item 01.")
#endregion
# -----------------------------------

# -----------------------------------
#region SPEND
func spend_phase() -> void:
	# set enable rules	
	permissions.enable_tabblable = true
	
	# update GUI
	activate_controls_for(SimpleGUI)
		
	update_gui("spend_phase", "You unlocked [HISTORY] on Item 01.")
#endregion
# -----------------------------------

# -----------------------------------
#region CALC
func calc_phase() -> void:	
	for i in containment_data.active:
		if i.status.is_contained:
			var scp_data = C.get_reference_data(i.item)
			if "containment_reward" in scp_data:
				resource_data = U.adjust_resources(resource_data, scp_data.containment_reward)
	
	resource_data = U.calculate_end_of_phase(resource_data, base_data.built)	
	update_gui("calc_phase", "Recalculated resources.")
#endregion
# -----------------------------------	

# -----------------------------------	
#region NEXT
func next_phase() -> void:
	var u_res = U.inc_containment(containment_data)
	containment_data = u_res.containment_data

	update_gui("next_phase", "%s SCP expired and removed from list." % u_res.availables_expired.size())
#endregion
# -----------------------------------	

# -----------------------------------	
#region CONTROLS 
func activate_controls_for(val:Node = null) -> void:
	if val != null:
		var index = control_arr.find(val)
		current.control = index	
	
	await get_tree().create_timer(0).timeout 

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
		if permissions.enable_tabblable:
			match event.keycode: 
				# tab
				4194306:
					current.secondary_control = (current.secondary_control + 1) % secondary_control_arr.size()
					activate_controls_for(secondary_control_arr[current.secondary_control])
					
		# --------------------------
		if permissions.enable_floor_change:
			match event.keycode: 
				# 0
				48: 
					current.on_floor = 0
					current = current.duplicate()
				# 1
				49: 
					current.on_floor = 1
					current = current.duplicate()
				# 2
				50: 
					current.on_floor = 2
					current = current.duplicate()
				# 3
				51: 
					current.on_floor = 3
					current = current.duplicate()

		# --------------------------
		if permissions.enable_save_load:
			match event.keycode:
				76:
					for log in logs:
						print(log)
				# 5
				53: quicksave() 
				# 8 key
				56: quickload()
# -----------------------------------		
#endregion
# -----------------------------------	
