@tool
extends PanelContainer

@onready var RootPanel:Control = $"."
@onready var ShortcutBtnGrid:GridContainer = $VBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer2/ShortcutBtnGrid

@onready var ShortcutToggleBtn:BtnBase = $VBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer2/HBoxContainer2/VBoxContainer2/ShortcutToggleBtn
@onready var ClearBtn:BtnBase = $VBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer2/HBoxContainer2/VBoxContainer2/ClearBtn
@onready var ShowToggleBtn:BtnBase = $VBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer2/HBoxContainer2/VBoxContainer2/ShowToggleBtn
#@onready var ShortcutLabelLeft:Label = $VBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/ShortcutLabelLeft
#@onready var ShortcutLabelRight:Label = $VBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/ShortcutLabelRight

enum BOOKMARK_TYPE {GLOBAL, RING}
enum CONTROL_MODE { BOOKMARK, CLEAR }

var current_bookmark_type:BOOKMARK_TYPE = BOOKMARK_TYPE.GLOBAL : 
	set(val):
		current_bookmark_type = val
		on_current_bookmark_type_update()
		
var current_control_mode:CONTROL_MODE = CONTROL_MODE.BOOKMARK 

var lock_btns:bool = false:
	set(val):
		lock_btns = val
		on_lock_btns_update()
		
var previous_designation:String		
var shotcut_data:Dictionary = {}
var base_states:Dictionary = {}
var room_config:Dictionary = {}
var camera_settings:Dictionary = {}
var current_location:Dictionary = {}
var enable_controls:bool = false
var show_hotkeys:bool = false : 
	set(val):
		show_hotkeys = val
		on_showkeys_update()

var endBookmark:Callable = func():pass
var onSetLock:Callable = func(state:bool):pass
var onBookmarkToggle:Callable
var action_func_lookup:Callable 
var ability_funcs:Callable
var passive_funcs:Callable

var selected_index:int = 0 : 
	set(val):
		selected_index = val
		on_selected_index_update()

func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_progress_data(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	GBL.subscribe_to_control_input(self)
	GBL.register_node(REFS.HOTKEY_CONTAINER, self)
	

	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_progress_data(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	GBL.unsubscribe_to_control_input(self)
	GBL.unregister_node(REFS.HOTKEY_CONTAINER)

# --------------------------------------------------------------------------------------------------	
func _ready() -> void:
	for node in ShortcutBtnGrid.get_children():
		node.onFocus = func(node:Control) -> void:
			pass
			#ShortcutLabelLeft.text = node.title 
			#ShortcutLabelRight.text = node.hint_description
		node.onBlur = func(node:Control) -> void:
			pass
			#ShortcutLabelLeft.text = ""
			#ShortcutLabelRight.text = ""	
				#
	
	ShowToggleBtn.onClick = func() -> void:
		print('here?')
		show_hotkeys = !show_hotkeys
	
	ShortcutToggleBtn.onClick = func() -> void:
		onBookmarkToggle.call()
	
	ClearBtn.onClick = func() -> void:
		for btn in ShortcutBtnGrid.get_children():
			btn.is_disabled = true
		current_control_mode = CONTROL_MODE.CLEAR
		GBL.find_node(REFS.ACTION_CONTAINER).freeze_inputs = true
		onSetLock.call(true)
		enable_controls = true
		selected_index = 0	
		highlight_container()		

	on_current_bookmark_type_update()
	highlight_container()
	on_showkeys_update()
# --------------------------------------------------------------------------------------------------	
			
# --------------------------------------------------------------------------------------------------	
func on_current_bookmark_type_update() -> void:
	if !is_node_ready():return
	
	match current_bookmark_type:
		BOOKMARK_TYPE.GLOBAL:	
			ShortcutToggleBtn.icon = SVGS.TYPE.GLOBAL
			ShortcutToggleBtn.title = "GLOBAL"			
			
		BOOKMARK_TYPE.RING:				
			ShortcutToggleBtn.icon = SVGS.TYPE.RING
			ShortcutToggleBtn.title = "RING"			

	build_shortcuts()
# --------------------------------------------------------------------------------------------------					

# --------------------------------------------------------------------------------------------------		
func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
	U.debounce("build_shortcuts", build_shortcuts)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	U.debounce("build_shortcuts", build_shortcuts)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	U.debounce("build_shortcuts", build_shortcuts)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if current_location.is_empty():return
	var designation:String = str(current_location.floor, current_location.ring)

	if previous_designation != designation:
		previous_designation = designation
		U.debounce("build_shortcuts", build_shortcuts)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_showkeys_update() -> void:
	if !is_node_ready():return
	ShowToggleBtn.title = "SHOW" if !show_hotkeys else "HIDE"
	ShowToggleBtn.icon = SVGS.TYPE.CHECKBOX if show_hotkeys else SVGS.TYPE.EMPTY_CHECKBOX
	
	ClearBtn.show() if show_hotkeys else ClearBtn.hide()
	ShortcutToggleBtn.show() if show_hotkeys else ShortcutToggleBtn.hide()
	ShortcutBtnGrid.show() if show_hotkeys else ShortcutBtnGrid.hide()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_selected_index_update() -> void:
	for index in ShortcutBtnGrid.get_child_count():
		var btn:Control = ShortcutBtnGrid.get_child(index)
		btn.is_selected = index == selected_index
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func start_bookmark(_shotcut_data:Dictionary) -> void:
	current_control_mode = CONTROL_MODE.BOOKMARK
	shotcut_data = _shotcut_data
	enable_controls = true
	selected_index = 0	
	highlight_container()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func end_bookmark(confirm:bool) -> void:
	var dict_ref:Dictionary
	enable_controls = false
	endBookmark.call()
	for btn in ShortcutBtnGrid.get_children():
		btn.is_selected = false
	highlight_container()
	
	match current_bookmark_type:
		BOOKMARK_TYPE.GLOBAL:
			dict_ref = base_states.global_hotkeys
		BOOKMARK_TYPE.RING:
			dict_ref = base_states.ring[str(current_location.floor, current_location.ring)].hotkeys
			
	if selected_index not in dict_ref:
		dict_ref[selected_index] = {}
		
	if dict_ref[selected_index].is_empty():
		dict_ref[selected_index] = shotcut_data
	
	dict_ref[selected_index] = shotcut_data
	
	match current_bookmark_type:
		BOOKMARK_TYPE.GLOBAL:
			base_states.global_hotkeys = dict_ref
		BOOKMARK_TYPE.RING:
			base_states.ring[str(current_location.floor, current_location.ring)].hotkeys = dict_ref
			
	SUBSCRIBE.base_states = base_states	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func clear_btn() -> void:
	var dict_ref:Dictionary

	match current_bookmark_type:
		BOOKMARK_TYPE.GLOBAL:
			dict_ref = base_states.global_hotkeys
		BOOKMARK_TYPE.RING:
			dict_ref = base_states.ring[str(current_location.floor, current_location.ring)].hotkeys
			
	if selected_index not in dict_ref:
		dict_ref[selected_index] = {}
	dict_ref[selected_index] = {}
	
	match current_bookmark_type:
		BOOKMARK_TYPE.GLOBAL:
			base_states.global_hotkeys = dict_ref
		BOOKMARK_TYPE.RING:
			base_states.ring[str(current_location.floor, current_location.ring)].hotkeys = dict_ref
	
	var btn:Control = ShortcutBtnGrid.get_child(selected_index)
	btn.reset()
	
	SUBSCRIBE.base_states = base_states	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func end_clear() -> void:
	onSetLock.call(false)
	enable_controls = false
	selected_index = 0	
	highlight_container()
	for btn in ShortcutBtnGrid.get_children():
		btn.is_selected = false	
	GBL.find_node(REFS.ACTION_CONTAINER).freeze_inputs = false
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------		
func highlight_container() -> void:
	pass
	#var new_stylebox:StyleBoxFlat = RootPanel.get('theme_override_styles/panel').duplicate()
	#new_stylebox.border_color = Color.WHITE if enable_controls else Color.BLACK
	#RootPanel.add_theme_stylebox_override("panel", new_stylebox)	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func on_lock_btns_update() -> void:
	for node in [ShortcutBtnGrid]:
		for child in node.get_children():
			child.is_disabled = lock_btns	
	
	for btn in [ClearBtn, ShowToggleBtn]:
		btn.is_disabled = lock_btns
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func build_shortcuts() -> void:
	if current_location.is_empty():return
	var designation:String = str(current_location.floor, current_location.ring)
#
	var use_dict:Dictionary = {} 
	match current_bookmark_type:
		BOOKMARK_TYPE.GLOBAL:
			use_dict = base_states.global_hotkeys
		BOOKMARK_TYPE.RING:
			use_dict = base_states.ring[str(current_location.floor, current_location.ring)].hotkeys
	
	for index in ShortcutBtnGrid.get_child_count():		
		var btn:Control = ShortcutBtnGrid.get_child(index)

		#----------------------------
		if index in use_dict:			
			var shortcut_data:Dictionary = use_dict[index]
			if !shortcut_data.is_empty():
				match shortcut_data.type:
					0:
						var action_data:Dictionary = action_func_lookup.call(shortcut_data.lookup_ref)
						btn.get_icon_func = func() -> SVGS.TYPE:
							return SVGS.TYPE.MEDIA_PLAY
						btn.get_not_ready_func = func() -> bool:
							return false
						btn.title = action_data.title
						btn.hint_description = "ACTION DESCRIPTION"
					1:
						var ability:Dictionary = ROOM_UTIL.return_ability(shortcut_data.room_ref, shortcut_data.ability_level)
						var funcs:Dictionary = ability_funcs.call(ability, shortcut_data.use_location)
						btn.get_icon_func = funcs.get_icon_func	
						btn.get_not_ready_func = funcs.get_not_ready_func
						btn.get_invalid_func = funcs.get_invalid_func
						btn.title = ability.name
						btn.hint_description = "ABILITY DESCRIPTION"
					2:
						var ability:Dictionary = ROOM_UTIL.return_passive_ability(shortcut_data.room_ref, shortcut_data.ability_level)
						var funcs:Dictionary = passive_funcs.call(shortcut_data.room_ref, shortcut_data.ability_level, shortcut_data.use_location)
						btn.get_icon_func = funcs.get_icon_func	
						btn.get_not_ready_func = funcs.get_not_ready_func
						btn.get_invalid_func = funcs.get_invalid_func
						btn.title = ability.name
						
						btn.hint_description = "PASSIVE DESCRIPTION"
				
				btn.onReset = func() -> void:
					use_dict.erase(index)
					
				btn.onClick = func() -> void:
					match shortcut_data.type:
						0:
							var action_data:Dictionary = action_func_lookup.call(shortcut_data.lookup_ref)
							action_data.onSelect.call(-1) # number passed doesn't matter
						1:
							#await lock_btns(true)
							var ability:Dictionary = ROOM_UTIL.return_ability(shortcut_data.room_ref, shortcut_data.ability_level)
							await GAME_UTIL.use_active_ability(ability)
							#lock_btns(false)
						2:
							GAME_UTIL.toggle_passive_ability(shortcut_data.room_ref, shortcut_data.ability_level)
				
				btn.update_self()
		#----------------------------
		else:
			btn.reset()
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or !enable_controls:return
	var key:String = input_data.key
	
	match key:
		# ----------------------------
		"E":
			match current_control_mode:
				CONTROL_MODE.BOOKMARK:
					end_bookmark(true)
				CONTROL_MODE.CLEAR:
					clear_btn()					
		"ENTER":
			match current_control_mode:
				CONTROL_MODE.BOOKMARK:
					end_bookmark(true)
				CONTROL_MODE.CLEAR:
					clear_btn()					
		"B":
			match current_control_mode:
				CONTROL_MODE.BOOKMARK:
					end_bookmark(false)
				CONTROL_MODE.CLEAR:
					end_clear()
		# ----------------------------
		"D":
			selected_index = U.min_max(selected_index + 1, 0, 5, true)
		# ----------------------------
		"A":
			selected_index = U.min_max(selected_index - 1, 0, 5, true)
# --------------------------------------------------------------------------------------------------	
