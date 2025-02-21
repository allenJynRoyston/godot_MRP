extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG

@onready var LeftSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList
@onready var RightSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var ScpList:HBoxContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/ScpList

@onready var DetailsBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList/Details
@onready var BackBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn
@onready var SelectScp:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/SelectScp
@onready var ConfirmScp:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/ConfirmScp
@onready var SelectResearcher:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/SelectResearcher
@onready var ConfirmResearchers:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/ConfirmResearchers

@onready var ResearcherControlPanel:Control = $ResearcherControl/PanelContainer
@onready var ResearcherList:HBoxContainer = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/ResearcherList

@onready var ConfirmPanelContainer:Control = $ConfirmPanel/ConfirmPanel

@onready var ContentPanelContainer:Control = $ContentControl/PanelContainer
@onready var BtnPanelContainer:Control = $BtnControl/MarginContainer

enum MODE { SELECT_SCP, CONFIRM_SCP, SELECT_RESEARCHERS, CONFIRM_RESEARCHERS, FINALIZE }

const ScpCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/SCP/ScpCard.tscn")
const ResearcherCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/RESEARCHER/ResearcherCard.tscn")

var scp_active_index:int = -1 : 
	set(val):
		scp_active_index = val
		on_scp_active_index_update()
		
var researcher_active_index:int = -1 : 
	set(val):
		researcher_active_index = val
		on_researcher_active_index_update()
		
var selected_researchers:Array = []
var selected_scp:int = -1

var refs:Array = [] : 
	set(val):
		refs = val
		on_refs_update()
		
var current_mode:MODE = MODE.SELECT_SCP : 
	set(val):
		current_mode = val
		on_current_mode_update()

var content_restore_pos:int
var confirm_restore_pos:int
var btn_restore_pos:int
var is_setup:bool = false

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	on_refs_update()
	on_scp_active_index_update()
	on_researcher_active_index_update()

	SelectScp.onClick = func() -> void:
		if current_mode == MODE.SELECT_SCP:
			mark_scp_as_selected()

	ConfirmScp.onClick = func() -> void:
		if current_mode == MODE.CONFIRM_SCP:
			on_confirm_scp()
			
	SelectResearcher.onClick = func() -> void:
		if current_mode == MODE.SELECT_RESEARCHERS:
			mark_researcher_as_selected()
	
	DetailsBtn.onClick = func() -> void:
		show_details()

	BackBtn.onClick = func() -> void:
		match current_mode:
			MODE.SELECT_RESEARCHERS:
				current_mode = MODE.CONFIRM_SCP
			MODE.CONFIRM_SCP:
				mark_scp_as_selected(true)
			MODE.SELECT_RESEARCHERS:
				current_mode = MODE.CONFIRM_SCP
			MODE.CONFIRM_RESEARCHERS:
				revert_confirm()
				current_mode = MODE.SELECT_RESEARCHERS
	
	ConfirmResearchers.onClick = func() -> void:
		current_mode = MODE.FINALIZE

	await U.set_timeout(1.0)	
	content_restore_pos = ContentPanelContainer.position.y			
	btn_restore_pos = BtnPanelContainer.position.y
	confirm_restore_pos = ConfirmPanelContainer.position.x
	is_setup = true
	on_is_showing_update()	
# -----------------------------------------------

# -----------------------------------------------
func start(new_refs:Array) -> void:
	refs = new_refs
	current_mode = MODE.SELECT_SCP
# -----------------------------------------------

# -----------------------------------------------
func clear_list() -> void:
	for node in [ScpList, ResearcherList]:
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

	# fills in the 
	var recruit_data = []
	for researcher in researcher_hire_list:
		recruit_data.push_back(RESEARCHER_UTIL.get_user_object(researcher))
		
	for index in recruit_data.size():
		var data:Dictionary = recruit_data[index]
		var new_card:Control = ResearcherCardPreload.instantiate()
		#new_card.ref = ref
		new_card.index = index		
		new_card.onFocus = func(_node:Control):
			match current_mode:
				MODE.SELECT_RESEARCHERS:
					researcher_active_index = index
		ResearcherList.add_child(new_card)
		new_card.reveal = true
		
	scp_active_index = 0
	researcher_active_index = 0
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
			
	
	selected_scp = scp_active_index

	
	unflip_cards()
	await U.tick()
	if clear:
		current_mode = MODE.SELECT_SCP
	else:
		current_mode = MODE.CONFIRM_SCP
# -----------------------------------------------		

# -----------------------------------------------
func mark_researcher_as_selected(clear:bool = false) -> void:
	if !is_node_ready() or refs.size() == 0:return	
	unflip_cards()
	
	selected_researchers = []
	
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if researcher_active_index == index:
			node.is_selected = !node.is_selected
		if node.is_selected:
			selected_researchers.push_back(index)
	
	
	
	var count:int = 0
	for node in ResearcherList.get_children():
		if node.is_selected:
			count += 1
	
	ConfirmResearchers.is_disabled = count == 0
	
	if count == 2:
		current_mode = MODE.CONFIRM_RESEARCHERS
		for index in ResearcherList.get_child_count():
			var node:Control = ResearcherList.get_child(index)
			if !node.is_selected:
				node.is_deselected = true
# -----------------------------------------------		

# -----------------------------------------------		
func revert_confirm() -> void:
	var revert_index:int = selected_researchers.pop_back()
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if index == revert_index:
			node.is_selected = false
		node.is_deselected = false
# -----------------------------------------------			

# -----------------------------------------------
func unflip_cards() -> void:
	if !is_node_ready() or refs.size() == 0:return	
	var ListNode:Control = ScpList if current_mode == MODE.SELECT_SCP else ResearcherList
	
	for index in ListNode.get_child_count():
		var node:Control = ListNode.get_child(index)
		if node.flip:
			node.flip = false
# -----------------------------------------------
		
# -----------------------------------------------
func show_details() -> void:
	if !is_node_ready() or refs.size() == 0:return	
	var ListNode:Control = ScpList if current_mode == MODE.SELECT_SCP else ResearcherList
	
	for index in ListNode.get_child_count():
		var node:Control = ListNode.get_child(index)
		var active_index:int = scp_active_index if current_mode == MODE.SELECT_SCP else researcher_active_index
		if active_index == index:
			node.flip = !node.flip
# -----------------------------------------------	

# -----------------------------------------------
func on_scp_active_index_update() -> void:
	if !is_node_ready() or refs.size() == 0:return		
	if scp_active_index == -1:return
	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		node.is_active = scp_active_index == index
# -----------------------------------------------	

# -----------------------------------------------	
func on_researcher_active_index_update() -> void:
	if !is_node_ready() or refs.size() == 0:return		
	if researcher_active_index == -1:return
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		node.is_active = researcher_active_index == index		
# -----------------------------------------------	

# -----------------------------------------------	
func clear_marked_researchers() -> void:
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		node.is_selected = false
		node.is_deselected = false
# -----------------------------------------------			

# -----------------------------------------------
func on_is_showing_update() -> void:
	super.on_is_showing_update()
	if !is_setup:return
	
	if !is_showing:
		for node in [RightSideBtnList, LeftSideBtnList]:
			for btn in node.get_children():
				btn.is_disabled = true

	# always hide this
	ResearcherControlPanel.hide()

	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1 if is_showing else 0))
	U.tween_node_property(ContentPanelContainer, "modulate", Color(1, 1, 1, 1 if is_showing else 0), 0.3)

	U.tween_node_property(ContentPanelContainer, "position:y", content_restore_pos if is_showing else content_restore_pos - 5, 0.3)
	await U.tween_node_property(BtnPanelContainer, "position:y", btn_restore_pos if is_showing else BtnPanelContainer.size.y + 20, 0.3)
	
	U.tween_node_property(ConfirmPanelContainer, "position:x", confirm_restore_pos if is_showing else -ConfirmPanelContainer.size.x, 0.3)
	

# -----------------------------------------------

# -----------------------------------------------
func on_selected_scp_update() -> void:
	if !is_node_ready():return
# -----------------------------------------------	

# -----------------------------------------------	
func on_confirm_scp() -> void:
	await U.tick()
	current_mode = MODE.SELECT_RESEARCHERS
	selected_scp 
# -----------------------------------------------		

## -----------------------------------------------
#func revert_confirm() -> void:
	#current_mode = MODE.SELECT
	#
	#for index in List.get_child_count():
		#var node:Control = List.get_child(index)
		#node.reveal = true
		#node.is_selected = select_index == index	
## -----------------------------------------------
#
## -----------------------------------------------
#func confirm_selection() -> void:
	#current_mode = MODE.CONFIRM
	#
	#for index in List.get_child_count():
		#var node:Control = List.get_child(index)
		#if select_index != index:
			#node.reveal = false
## -----------------------------------------------


# -----------------------------------------------
func on_current_mode_update() -> void:
	if !is_node_ready():return
	match current_mode:
		MODE.SELECT_SCP:
			for btn in [SelectScp, ConfirmScp, SelectResearcher, ConfirmResearchers, DetailsBtn]:
				btn.is_disabled = false
				
			BackBtn.hide()
			SelectScp.show()
			ConfirmScp.hide()
			ConfirmResearchers.hide()
			
			for index in ScpList.get_child_count():
				var node:Control = ScpList.get_child(index)
				node.is_deselected = false
			
			U.tween_node_property(ContentPanelContainer, "position:x", 0, 0.3)
			U.tween_node_property(ResearcherControlPanel, "position:x", ResearcherControlPanel.size.x, 0.3)
		MODE.CONFIRM_SCP:
			BackBtn.is_disabled = false
			BackBtn.show()
			SelectScp.hide()
			ConfirmScp.show()
			ConfirmResearchers.hide()
			
			for index in ScpList.get_child_count():
				var node:Control = ScpList.get_child(index)
				node.is_deselected = scp_active_index != index			
			
			U.tween_node_property(ContentPanelContainer, "position:x", 0, 0.3)
			U.tween_node_property(ResearcherControlPanel, "position:x", ResearcherControlPanel.size.x, 0.3)			
			clear_marked_researchers()
			
		MODE.SELECT_RESEARCHERS:
			ConfirmResearchers.is_disabled = true
			ResearcherControlPanel.show()
			
			SelectResearcher.show()
			ConfirmScp.hide()
			SelectScp.hide()
			ConfirmResearchers.show()
			
			U.tween_node_property(ContentPanelContainer, "position:x", ContentPanelContainer.size.x, 0.3)
			U.tween_node_property(ResearcherControlPanel, "position:x", 0, 0.3)
		MODE.CONFIRM_RESEARCHERS:
			print('confirm researchers')
		MODE.FINALIZE:
			print('confirm all')
			print("selected_scp: ", selected_scp, "   selected researchers: ", selected_researchers)
# -----------------------------------------------

## -----------------------------------------------
#func finalize_confirm() -> void:
	#freeze_inputs = true
#
	#for index in List.get_child_count():
		#var node:Control = List.get_child(index)
		#node.reveal = false
		#
	#await U.set_timeout(1.0)
	#
	#scp_data.available_list.push_back({
		#"ref": refs[select_index], 
		#"days_until_expire": 14, 
		#"is_new": true,
		#"transfer_status": {
			#"state": false, 
			#"days_till_complete": -1,
			#"location": {}
		#}
	#})
	#SUBSCRIBE.scp_data = scp_data	
	#
	#user_response.emit()
## -----------------------------------------------	

# -----------------------------------	
pass
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs: 
		return

	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"A":
			if current_mode == MODE.SELECT_SCP:
				unflip_cards()
				scp_active_index = U.min_max(scp_active_index - 1, 0, ScpList.get_child_count() - 1)
			if current_mode == MODE.SELECT_RESEARCHERS:
				unflip_cards()
				researcher_active_index = U.min_max(researcher_active_index - 1, 0, ResearcherList.get_child_count() - 1)
		"D":
			if current_mode == MODE.SELECT_SCP:
				unflip_cards()
				scp_active_index = U.min_max(scp_active_index + 1, 0, ScpList.get_child_count() - 1)
			if current_mode == MODE.SELECT_RESEARCHERS:
				unflip_cards()
				researcher_active_index = U.min_max(researcher_active_index + 1, 0, ResearcherList.get_child_count() - 1)
		#"R":
			#if current_mode == MODE.SELECT:
				#show_details()
		#"E":
			#match current_mode:
				#MODE.SELECT:
					#confirm_selection()
				#MODE.CONFIRM:
					#finalize_confirm()
		#"B":
			#if current_mode == MODE.CONFIRM:
				#revert_confirm()
#  -----------------------------------		
