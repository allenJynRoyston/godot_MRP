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

@onready var ConfirmPanelContainer:Control = $ConfirmControl/ConfirmPanel
@onready var ScpCheckbox:BtnBase = $ConfirmControl/ConfirmPanel/MarginContainer/VBoxContainer/VBoxContainer/ScpCheckbox
@onready var R1Checkbox:BtnBase = $ConfirmControl/ConfirmPanel/MarginContainer/VBoxContainer/VBoxContainer/R1Checkbox
@onready var R2Checkbox:BtnBase = $ConfirmControl/ConfirmPanel/MarginContainer/VBoxContainer/VBoxContainer/R2Checkbox

@onready var TraitPanel:Control = $TraitControl/TraitPanel
@onready var TraitList:VBoxContainer = $TraitControl/TraitPanel/MarginContainer/VBoxContainer/TraitContainer/TraitList
@onready var SynergyContainer:VBoxContainer = $TraitControl/TraitPanel/MarginContainer/VBoxContainer/SynergyContainer
@onready var SynergyTraitList:VBoxContainer = $TraitControl/TraitPanel/MarginContainer/VBoxContainer/SynergyContainer/SynergyTraitList

@onready var ContentPanelContainer:Control = $ContentControl/PanelContainer
@onready var BtnPanelContainer:Control = $BtnControl/MarginContainer

enum MODE { SELECT_SCP, CONFIRM_SCP, SELECT_RESEARCHERS, CONFIRM_RESEARCHERS, FINALIZE }

const ScpCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/SCP/ScpCard.tscn")
const ResearcherCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/RESEARCHER/ResearcherCard.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")

var scp_active_index:int = -1 : 
	set(val):
		scp_active_index = val
		on_scp_active_index_update()
		
var researcher_active_index:int = -1 : 
	set(val):
		researcher_active_index = val
		on_researcher_active_index_update()
		
var selected_researchers:Array = [] : 
	set(val):
		selected_researchers = val
		on_selected_researchers_update()
		
var selected_scp:int = -1 : 
	set(val):
		selected_scp = val
		on_selected_scp_update()		
			

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
var trait_restore_pos:int
var btn_restore_pos:int
var is_setup:bool = false
var new_hire_list:Array 

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	on_refs_update()
	on_scp_active_index_update()
	on_researcher_active_index_update()
	
	SynergyContainer.hide() 

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
			MODE.CONFIRM_SCP:
				mark_scp_as_selected(true)
			MODE.SELECT_RESEARCHERS:
				mark_scp_as_selected(true)
				current_mode = MODE.SELECT_SCP
			MODE.CONFIRM_RESEARCHERS:
				revert_confirm()
				current_mode = MODE.SELECT_RESEARCHERS
	
	ConfirmResearchers.onClick = func() -> void:
		current_mode = MODE.FINALIZE
		
	await U.set_timeout(1.0)	
	content_restore_pos = ContentPanelContainer.position.y			
	trait_restore_pos = TraitPanel.position.x
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
	new_hire_list = RESEARCHER_UTIL.generate_new_researcher_hires()
	
	# recruit data
	var recruit_data := []
	for researcher in new_hire_list:
		recruit_data.push_back(RESEARCHER_UTIL.get_user_object(researcher))
		
	for index in recruit_data.size():
		var new_card:Control = ResearcherCardPreload.instantiate()
		new_card.researcher_details = recruit_data[index]
		new_card.index = index		
		new_card.onFocus = func(_node:Control):
			match current_mode:
				MODE.SELECT_RESEARCHERS:
					researcher_active_index = index
		new_card.onClick = func() -> void:
			match current_mode:
				MODE.SELECT_RESEARCHERS:			
					mark_researcher_as_selected()
				MODE.CONFIRM_RESEARCHERS:
					unmark_researcher(index)
			
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
			ScpCheckbox.is_checked = false
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
func revert_confirm() -> void:
	var revert_index:int = selected_researchers.pop_back()
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if index == revert_index:
			selected_researchers.erase(revert_index)
			node.is_selected = false
		node.is_deselected = false
	
	check_researcher_complete()
# -----------------------------------------------			

# -----------------------------------------------		
func unmark_researcher(marked_index:int) -> void:
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if marked_index == index:
			selected_researchers.erase(marked_index)
			node.is_selected = false
			
	check_researcher_complete()
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

	check_researcher_complete()
# -----------------------------------------------		

# -----------------------------------------------		
func check_researcher_complete() -> void:
	var count:int = 0
	for node in ResearcherList.get_children():
		if node.is_selected:
			count += 1
	
	ConfirmResearchers.is_disabled = count == 0
	selected_researchers = selected_researchers
	
	match current_mode:
		MODE.CONFIRM_RESEARCHERS:
			if count < 2:				
				for index in ResearcherList.get_child_count():
					var node:Control = ResearcherList.get_child(index)
					node.is_deselected = false
				await U.tick()
				current_mode = MODE.SELECT_RESEARCHERS					
		MODE.SELECT_RESEARCHERS:
			if count == 2:				
				for index in ResearcherList.get_child_count():
					var node:Control = ResearcherList.get_child(index)
					if !node.is_selected:
						node.is_deselected = true	
				await U.tick()
				current_mode = MODE.CONFIRM_RESEARCHERS
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
	U.tween_node_property(TraitPanel, "position:x", trait_restore_pos + TraitPanel.size.x + 20) 

	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1 if is_showing else 0))
	U.tween_node_property(ContentPanelContainer, "modulate", Color(1, 1, 1, 1 if is_showing else 0))

	U.tween_node_property(ContentPanelContainer, "position:y", content_restore_pos if is_showing else content_restore_pos - 5)
	await U.tween_node_property(BtnPanelContainer, "position:y", btn_restore_pos if is_showing else BtnPanelContainer.size.y + 20)
	
	U.tween_node_property(ConfirmPanelContainer, "position:x", confirm_restore_pos if is_showing else -ConfirmPanelContainer.size.x)
# -----------------------------------------------

# -----------------------------------------------
func on_selected_scp_update() -> void:
	if !is_node_ready():return
	ScpCheckbox.is_checked = selected_scp != -1	
# -----------------------------------------------	

# -----------------------------------------------	
func on_selected_researchers_update() -> void:
	if !is_node_ready():return
	R1Checkbox.is_checked = selected_researchers.size() >= 1
	R2Checkbox.is_checked = selected_researchers.size() == 2

	for child in [TraitList, SynergyTraitList]:
		for item in child.get_children():
			item.queue_free()
		
	var total_traits_list := []
	var synergy_traits := []
	var dup_list := []
	
	# get traits from selected researchers
	for n in selected_researchers:
		var researcher_details:Dictionary = RESEARCHER_UTIL.get_user_object( new_hire_list[n] )
		total_traits_list.push_back(researcher_details.traits)

	# presents as list
	for traits in total_traits_list:
		for t in traits:
			if t not in dup_list:
				dup_list.push_back(t)
				var traits_detail:Dictionary = RESEARCHER_UTIL.return_trait_data(t)				
				var card:Control = TraitCardPreload.instantiate()
				card.ref = traits_detail.ref
				TraitList.add_child(card)
			
	# then if there's two researchers, compares there traits and looks for combos
	if total_traits_list.size() == 2:
		var synergy_traits_list:Array = RESEARCHER_UTIL.return_trait_synergy(total_traits_list[0], total_traits_list[1])
		SynergyContainer.hide() if synergy_traits_list.is_empty() else SynergyContainer.show()
		for item in synergy_traits_list:
			var card:Control = TraitCardPreload.instantiate()
			card.ref = item.ref
			card.is_synergy = true
			SynergyTraitList.add_child(card)			
	else:
		SynergyContainer.hide()
		
	if total_traits_list.size() > 0:
		U.tween_node_property(TraitPanel, "position:x", trait_restore_pos)
	else:
		U.tween_node_property(TraitPanel, "position:x", trait_restore_pos + TraitPanel.size.x + 20)
# -----------------------------------------------		

# -----------------------------------------------	
func on_confirm_scp() -> void:
	await U.tick()
	current_mode = MODE.SELECT_RESEARCHERS
# -----------------------------------------------		

# -----------------------------------------------
func on_current_mode_update() -> void:
	if !is_node_ready():return
	match current_mode:
		MODE.SELECT_SCP:
			selected_researchers = []
			
			for btn in [SelectScp, ConfirmScp, SelectResearcher, ConfirmResearchers, DetailsBtn]:
				btn.is_disabled = false
				
			BackBtn.hide()
			SelectScp.show()
			ConfirmScp.hide()
			ConfirmResearchers.hide()
			SelectResearcher.hide()
			
			for index in ScpList.get_child_count():
				var node:Control = ScpList.get_child(index)
				node.is_deselected = false
			
			await U.tween_node_property(TraitPanel, "position:x", trait_restore_pos + TraitPanel.size.x + 20) 			
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
			ConfirmResearchers.hide()
						
			U.tween_node_property(ContentPanelContainer, "position:x", ContentPanelContainer.size.x, 0.3)
			U.tween_node_property(ResearcherControlPanel, "position:x", 0, 0.3)

		MODE.CONFIRM_RESEARCHERS:
			ConfirmResearchers.show()
			SelectResearcher.hide()
		MODE.FINALIZE:
			await U.tween_node_property(BtnPanelContainer, "position:y", btn_restore_pos if is_showing else BtnPanelContainer.size.y + 20)
			U.tween_node_property(TraitPanel, "position:x", trait_restore_pos + TraitPanel.size.x + 20) 			
			await U.tween_node_property(ResearcherControlPanel, "position:x", ResearcherControlPanel.size.x, 0.3)
			
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
			
			# add to selected researchers
			for n in selected_researchers:
				hired_lead_researchers_arr.push_back(new_hire_list[n])
			
			# subscribe
			SUBSCRIBE.scp_data = scp_data
			SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
			
			print(SUBSCRIBE.hired_lead_researchers_arr)
			user_response.emit()
# -----------------------------------------------

# -----------------------------------	
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
#  -----------------------------------		
