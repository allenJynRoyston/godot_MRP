extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var TitleLabel:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/TitleLabel

@onready var LeftSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList
@onready var RightSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList

@onready var ListScrollContainer:ScrollContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/ScrollContainer
@onready var ScpList:HBoxContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/ScrollContainer/ScpList
@onready var AvailableLabel:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/AvailableLabel
@onready var LessBtn:BtnBase = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LessBtn
@onready var MoreBtn:BtnBase = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MoreBtn

@onready var DetailsBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList/Details
@onready var BackBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn
@onready var SelectScp:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/SelectScp
@onready var ConfirmScp:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/ConfirmScp

@onready var ContentPanelContainer:Control = $ContentControl/PanelContainer
@onready var BtnPanelContainer:Control = $BtnControl/MarginContainer

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
var control_pos:Dictionary
var is_animating:bool = true
var custom_min_size:Vector2
var overflow_count:int
var read_only:bool = false

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	on_refs_update()
	on_scp_active_index_update()

	SelectScp.onClick = func() -> void:
		if is_animating or read_only:return
		if current_mode == MODE.SELECT_SCP:
			mark_scp_as_selected()

	ConfirmScp.onClick = func() -> void:
		if is_animating or read_only:return
		if current_mode == MODE.CONFIRM_SCP:
			on_confirm_scp()
			
	DetailsBtn.onClick = func() -> void:
		if is_animating:return
		show_details()

	BackBtn.onClick = func() -> void:
		if is_animating:return
		match current_mode:
			MODE.SELECT_SCP:
				end(false)
				
			MODE.CONFIRM_SCP:
				mark_scp_as_selected(true)

	await U.set_timeout(1.0)	
	control_pos[ContentPanelContainer] = {"show": ContentPanelContainer.position.x, "hide": ContentPanelContainer.position.x - ContentPanelContainer.size.x}
	control_pos[BtnPanelContainer] = {"show": BtnPanelContainer.position.y, "hide": BtnPanelContainer.position.y + BtnPanelContainer.size.y}

	on_current_mode_update()
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
func end(made_selection:bool) -> void:	
	for btn in [SelectScp, ConfirmScp, DetailsBtn, BackBtn]:
		btn.is_disabled = true
					
	U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0))
	U.tween_node_property(ContentPanelContainer, "position:x", control_pos[ContentPanelContainer].hide)
	await U.tween_node_property(BtnPanelContainer, "position:y", control_pos[BtnPanelContainer].hide)
	
	current_mode = MODE.HIDE	
	user_response.emit(made_selection)
# -----------------------------------------------	

# -----------------------------------------------
func clear_list() -> void:
	for node in [ScpList]:
		for child in node.get_children():
			child.queue_free()
# -----------------------------------------------		

# -----------------------------------------------
func on_refs_update() -> void:
	if !is_node_ready():return
	clear_list()
	
	# fills in the scp cards
	for index in refs.size():
		var ref:int = refs[index]
		var new_card:Control = ScpCardPreload.instantiate()
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

# -----------------------------------------------
func on_current_mode_update() -> void:
	if !is_node_ready() or control_pos.is_empty():return
	is_animating = true

	match current_mode:
		# --------------
		MODE.HIDE:
			for btn in [SelectScp, ConfirmScp, DetailsBtn]:
				btn.is_disabled = true
							
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0))
			U.tween_node_property(ContentPanelContainer, "position:x", control_pos[ContentPanelContainer].hide, 0)
			U.tween_node_property(BtnPanelContainer, "position:y", control_pos[BtnPanelContainer].hide, 0)
		# --------------
		MODE.SELECT_SCP:
			for btn in [SelectScp, ConfirmScp, DetailsBtn, BackBtn]:
				btn.is_disabled = false

			for index in ScpList.get_child_count():
				var node:Control = ScpList.get_child(index)
				node.is_deselected = false
			
			
			SelectScp.show() if !read_only else SelectScp.hide()
			ConfirmScp.hide()			
							
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1))
			U.tween_node_property(BtnPanelContainer, "position:y", control_pos[BtnPanelContainer].show )
			U.tween_node_property(ContentPanelContainer, "position:x", control_pos[ContentPanelContainer].show)
		# --------------
		MODE.CONFIRM_SCP:
			SelectScp.hide()
			ConfirmScp.show()
			
			for index in ScpList.get_child_count():
				var node:Control = ScpList.get_child(index)
				node.is_deselected = scp_active_index != index			

		# --------------
		MODE.FINALIZE:
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0))
			await U.tween_node_property(ContentPanelContainer, "position:x", control_pos[ContentPanelContainer].hide)			

			# update scp data
			scp_data.available_list.push_back({
				"ref": selected_scp, 
				"is_new": true,
				"transfer_status": {
					"state": false, 
					"days_till_complete": -1,
					"location": {}
				}
			})

			# subscribe
			SUBSCRIBE.scp_data = scp_data
			end(true)
	
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

# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs or is_animating: 
		return

	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"A":
			if current_mode == MODE.SELECT_SCP:
				on_inc()
		"D":
			if current_mode == MODE.SELECT_SCP:
				on_dec()
#  -----------------------------------		
