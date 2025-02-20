extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG

@onready var LeftSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList
@onready var RightSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var ScpList:HBoxContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/ScpList

@onready var DetailsBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList/Details
@onready var BackBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn
@onready var SelectResearcherBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/SelectResearcherBtn
@onready var FinalizeBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/FinalizeBtn

@onready var ResearcherControlPanel:Control = $ResearcherControl/PanelContainer
@onready var ResearcherList:HBoxContainer = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/ResearcherList

@onready var ConfirmPanelContainer:Control = $ConfirmPanel/ConfirmPanel

@onready var ContentPanelContainer:Control = $ContentControl/PanelContainer
@onready var BtnPanelContainer:Control = $BtnControl/MarginContainer

enum MODE { SELECT_SCP, SELECT_RESEARCHERS, CONFIRM }

const ScpCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/SCP/ScpCard.tscn")
const ResearcherCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/RESEARCHER/ResearcherCard.tscn")

var select_index:int = -1 : 
	set(val):
		select_index = val
		on_select_index_update()
		
var selected_scp:int = -1 : 
	set(val):
		selected_scp = val
		on_selected_scp_update()
		
var selected_researchers:Array = []

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
	on_select_index_update()

	SelectResearcherBtn.onClick = func() -> void:
		current_mode = MODE.SELECT_RESEARCHERS
	
	DetailsBtn.onClick = func() -> void:
		show_details()

	BackBtn.onClick = func() -> void:
		current_mode = MODE.SELECT_SCP

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
					select_index = index
		new_card.onClick = func():
			match current_mode:
				MODE.SELECT_SCP:
					selected_scp = index
				#MODE.CONFIRM:
					#finalize_confirm()
		ScpList.add_child(new_card)
		new_card.reveal = true

	# fills in the 
	var recruit_data = []
	for researcher in researcher_hire_list:
		recruit_data.push_back(RESEARCHER_UTIL.get_user_object(researcher))
		
	for index in recruit_data.size():
		var data:Dictionary = recruit_data[index]
		var card_node:Control = ResearcherCardPreload.instantiate()
		card_node.data = data
		var already_hired:bool = hired_lead_researchers_arr.filter(func(i):return i[0] == data.uid).size() > 0
		card_node.none_available = already_hired
		ResearcherList.add_child(card_node)
		
	select_index = 0
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
		if select_index == index:
			node.flip = !node.flip
# -----------------------------------------------	

# -----------------------------------------------
func on_select_index_update() -> void:
	if !is_node_ready() or refs.size() == 0:return		
	if select_index == -1:return
	var card_node:Control = ScpList.get_child(select_index)	
	
	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		node.is_selected = select_index == index
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
	SelectResearcherBtn.is_disabled = selected_scp == -1
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
			for btn in [SelectResearcherBtn, FinalizeBtn, DetailsBtn]:
				btn.is_disabled = false
				
			BackBtn.hide()
			SelectResearcherBtn.show()
			FinalizeBtn.hide()
			
			U.tween_node_property(ContentPanelContainer, "position:x", 0, 0.3)
			U.tween_node_property(ResearcherControlPanel, "position:x", ResearcherControlPanel.size.x, 0.3)
		MODE.SELECT_RESEARCHERS:
			BackBtn.is_disabled = false
			ResearcherControlPanel.show()
			
			BackBtn.show()
			SelectResearcherBtn.hide()
			FinalizeBtn.show()
			
			U.tween_node_property(ContentPanelContainer, "position:x", ContentPanelContainer.size.x, 0.3)
			U.tween_node_property(ResearcherControlPanel, "position:x", 0, 0.3)

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
				select_index = U.min_max(select_index - 1, 0, ScpList.get_child_count() - 1)
		"D":
			if current_mode == MODE.SELECT_SCP:
				unflip_cards()
				select_index = U.min_max(select_index + 1, 0, ScpList.get_child_count() - 1)
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
