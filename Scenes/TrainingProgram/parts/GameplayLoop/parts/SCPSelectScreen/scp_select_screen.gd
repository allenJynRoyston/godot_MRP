extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls

@onready var TitleLabel:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/TitleLabel
#@onready var LeftSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList
#@onready var RightSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList

@onready var ListScrollContainer:ScrollContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/ScrollContainer
@onready var ScpList:HBoxContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/ScrollContainer/ScpList
@onready var AvailableLabel:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/AvailableLabel
@onready var LessBtn:BtnBase = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LessBtn
@onready var MoreBtn:BtnBase = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MoreBtn

#@onready var DetailsBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList/Details
#@onready var BackBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn
#@onready var SelectScp:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/SelectScp
#@onready var ConfirmScp:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/ConfirmScp

@onready var ContentPanelContainer:Control = $ContentControl/PanelContainer
#@onready var BtnControlPanel:Control = $BtnControl/MarginContainer

enum MODE { HIDE, SELECT_SCP, CONFIRM_SCP, FINALIZE }

const ScpCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/SCP/ScpCard.tscn")
const cards_in_list:int = 3

var scp_active_index:int = -1 : 
	set(val):
		scp_active_index = val
		on_scp_active_index_update()
		
var selected_scp:int = -1 : 
	set(val):
		selected_scp = val
		on_selected_scp_update()		
			
var refs:Array = [] : 
	set(val):
		refs = val
		on_refs_update()
		
var current_mode:MODE = MODE.HIDE : 
	set(val):
		current_mode = val
		on_current_mode_update()

var btn_restore_pos:int
var is_animating:bool = true
var custom_min_size:Vector2
var overflow_count:int
var read_only:bool = false

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	on_refs_update()
	on_scp_active_index_update()
	
	self.modulate = Color(1, 1, 1, 0)
	
	BtnControls.onDirectional = on_key_input

# -----------------------------------------------

# -----------------------------------------------
func start_selection(new_refs:Array) -> void:
	# TODO:  add soemthing here to determine the next set of available SCPs
	refs = new_refs
	TitleLabel.text = "SELECT AN SCP"
	current_mode = MODE.SELECT_SCP
	read_only = false
# -----------------------------------------------

# -----------------------------------------------
func start_read_only(new_refs:Array) -> void:	
	refs = new_refs 
	TitleLabel.text = "DETAILS"
	current_mode = MODE.SELECT_SCP
	read_only = true
# -----------------------------------------------	

# -----------------------------------------------
func end(made_selection:bool, selected_scp:int = -1) -> void:			
	U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0))
	await U.tween_node_property(ContentPanelContainer, "position:x", control_pos[ContentPanelContainer].hide)
	
	await BtnControls.reveal(false)
	
	user_response.emit({"made_selection": made_selection, "selected_scp": selected_scp})
# -----------------------------------------------	

# -----------------------------------------------
func clear_list() -> void:
	for node in [ScpList]:
		for child in node.get_children():
			child.queue_free()
# -----------------------------------------------		

# -----------------------------------------------
func on_refs_update() -> void:
	if !is_node_ready() or current_location.is_empty():return
	clear_list()
	
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
	var wing_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
	
	# fills in the scp cards
	for index in refs.size():
		var ref:int = refs[index]
		var new_card:Control = ScpCardPreload.instantiate()
		new_card.use_location = current_location.duplicate(true)
		new_card.current_metrics = wing_data.metrics	
		new_card.ref = ref
		new_card.index = index
		new_card.onFocus = func(_node:Control):			
			match current_mode:
				MODE.SELECT_SCP:
					scp_active_index = index
		new_card.onClick = func():
			if is_animating or read_only:return
			match current_mode:
				MODE.SELECT_SCP:
					mark_scp_as_selected()
				MODE.CONFIRM_SCP:
					if index == selected_scp:
						on_confirm_scp()
					else:
						mark_scp_as_selected(true)
						scp_active_index = index
		ScpList.add_child(new_card)
		new_card.reveal = true
		
		await U.tick()
		if index < cards_in_list:
			custom_min_size = ScpList.size + Vector2(10, 0)
	
	LessBtn.show() if refs.size() > cards_in_list else LessBtn.hide()
	MoreBtn.show() if refs.size() > cards_in_list else MoreBtn.hide()
	AvailableLabel.text = "Entries available: %s" % [refs.size()]
		
	ListScrollContainer.custom_minimum_size = custom_min_size
	scp_active_index = 0
	BtnControls.itemlist = ScpList.get_children()
# -----------------------------------------------

# -----------------------------------------------
func mark_scp_as_selected(clear:bool = false) -> void:
	if !is_node_ready() or refs.size() == 0:return	
	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		if clear:
			node.is_selected = false
		else:
			node.is_selected = scp_active_index == index
				
	selected_scp = -1 if clear else scp_active_index

	unflip_cards()
	await U.tick()
	if clear:
		current_mode = MODE.SELECT_SCP
	else:
		current_mode = MODE.CONFIRM_SCP
# -----------------------------------------------		

# -----------------------------------------------
func unflip_cards() -> void:
	if !is_node_ready() or refs.size() == 0:return	

	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		if node.flip:
			node.flip = false
# -----------------------------------------------
		
# -----------------------------------------------
func show_details() -> void:
	if !is_node_ready() or refs.size() == 0:return	
	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		if scp_active_index == index:
			node.flip = !node.flip
# -----------------------------------------------	

# -----------------------------------------------
func on_scp_active_index_update() -> void:
	if !is_node_ready() or refs.size() == 0 or scp_active_index == -1:return		

	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		node.is_active = scp_active_index == index
		
	var relative_index:int = scp_active_index - overflow_count		
	
	if relative_index > 2:
		if scp_active_index >= cards_in_list:
			overflow_count += 1
			next_set()
	
	if relative_index < 0:
		if overflow_count > 0:
			overflow_count -= 1
			back_set()
					
	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		node.is_hoverable = index >= overflow_count and index < overflow_count + cards_in_list
# -----------------------------------------------	

# -----------------------------------------------
func next_set() -> void:
	is_animating = true
	var current_scroll:int = ListScrollContainer.scroll_horizontal
	await U.tween_range(current_scroll, current_scroll + custom_min_size.x/cards_in_list, 0.2, func(val:float) -> void:
		ListScrollContainer.scroll_horizontal = val		
	).finished  
	is_animating = false
# -----------------------------------------------	

# -----------------------------------------------
func back_set() -> void:
	is_animating = true
	var current_scroll:int = ListScrollContainer.scroll_horizontal
	await U.tween_range(current_scroll, current_scroll - custom_min_size.x/cards_in_list, 0.2, func(val:float) -> void:
		ListScrollContainer.scroll_horizontal = val
	).finished  
	is_animating = false
# -----------------------------------------------	

# -----------------------------------------------
func on_selected_scp_update() -> void:
	if !is_node_ready():return
	pass
# -----------------------------------------------	

# -----------------------------------------------	
func on_confirm_scp() -> void:
	await U.tick()
	current_mode = MODE.FINALIZE
# -----------------------------------------------		

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()

	control_pos_default[ContentPanelContainer] = ContentPanelContainer.position
	#control_pos_default[BtnControlPanel] = BtnControlPanel.position

	update_control_pos()
	on_is_showing_update()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func update_control_pos() -> void:
	await U.tick()
	var h_diff:int = (1080 - 720) # difference between 1080 and 720 resolution - gives you 360
	var y_diff =  (0 if !GBL.is_fullscreen else h_diff) if !initalized_at_fullscreen else (0 if GBL.is_fullscreen else -h_diff)

	control_pos[ContentPanelContainer] = {
		"show": control_pos_default[ContentPanelContainer].x, 
		"hide": control_pos_default[ContentPanelContainer].x - ContentPanelContainer.size.x
	}
	
	# for elements in the bottom left corner
	#control_pos[BtnControlPanel] = {
		#"show": control_pos_default[BtnControlPanel].y + y_diff, 
		#"hide": control_pos_default[BtnControlPanel].y + y_diff + BtnControlPanel.size.y
	#}

	
	on_current_mode_update(true)
# --------------------------------------------------------------------------------------------------		

# -----------------------------------------------
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	is_animating = true

	match current_mode:
		# --------------
		MODE.HIDE:
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0), 0 if skip_animation else 0.3)
			U.tween_node_property(ContentPanelContainer, "position:x", control_pos[ContentPanelContainer].hide, 0 if skip_animation else 0.3)
		# --------------
		MODE.SELECT_SCP:
			BtnControls.reveal(false)

			U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))
			
			for index in ScpList.get_child_count():
				var node:Control = ScpList.get_child(index)
				node.is_deselected = false
							
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1), 0 if skip_animation else 0.3)
			await U.tween_node_property(ContentPanelContainer, "position:x", control_pos[ContentPanelContainer].show, 0 if skip_animation else 0.3)
			
			BtnControls.a_btn_title = "SELECT"	
			BtnControls.b_btn_title = "CANCEL"				
			
			BtnControls.reveal(true)
			
			BtnControls.onBack = func() -> void:
				end(false)
		# --------------
		MODE.CONFIRM_SCP:
			BtnControls.a_btn_title = "CONFIRM"
			BtnControls.b_btn_title = "BACK"	
			
			BtnControls.onBack = func() -> void:
				mark_scp_as_selected(true)
			
			for index in ScpList.get_child_count():
				var node:Control = ScpList.get_child(index)
				node.is_deselected = scp_active_index != index			

		# --------------
		MODE.FINALIZE:
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0), 0 if skip_animation else 0.3)
			await U.tween_node_property(ContentPanelContainer, "position:x", control_pos[ContentPanelContainer].hide, 0 if skip_animation else 0.3)			
			end(true, selected_scp)
	
	await U.set_timeout(0.3)
	is_animating = false
# -----------------------------------------------

# -----------------------------------------------
func on_inc() -> void:
	unflip_cards()
	scp_active_index = U.min_max(scp_active_index - 1, 0, ScpList.get_child_count() - 1)

func on_dec() -> void:
	unflip_cards()
	scp_active_index = U.min_max(scp_active_index + 1, 0, ScpList.get_child_count() - 1)
# -----------------------------------------------

# -----------------------------------------------
func on_key_input(key:String) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs or is_animating: 
		return

	match key:
		"A":
			if current_mode == MODE.SELECT_SCP:
				on_inc()
		"D":
			if current_mode == MODE.SELECT_SCP:
				on_dec()
# -----------------------------------------------
