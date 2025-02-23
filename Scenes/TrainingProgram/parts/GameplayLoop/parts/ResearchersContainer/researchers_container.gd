extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG

@onready var BtnPanelContainer:Control = $BtnControl/MarginContainer
@onready var LeftSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList
@onready var DetailsBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList/Details

@onready var RightSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var BackBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn
@onready var SelectBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/SelectBtn
@onready var ConfirmBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/ConfirmBtn

@onready var ResearcherPanel:Control = $ResearcherControl/PanelContainer
@onready var ResearcherScrollContainer:ScrollContainer = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/ScrollContainer
@onready var ResearcherList:HBoxContainer = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/ScrollContainer/ResearcherList
@onready var AvailableLabel:Label = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/AvailableLabel
@onready var LessBtn:BtnBase = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LessBtn
@onready var MoreBtn:BtnBase = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MoreBtn

@onready var SelectedPanel:Control = $SelectedControl/SelectedPanel
@onready var SelectedList:VBoxContainer = $SelectedControl/SelectedPanel/MarginContainer/VBoxContainer/SelectedContainer/SelectedList

@onready var TraitPanel:Control = $TraitControl/TraitPanel
@onready var TraitList:VBoxContainer = $TraitControl/TraitPanel/MarginContainer/VBoxContainer/TraitContainer/TraitList
@onready var SynergyContainer:VBoxContainer = $TraitControl/TraitPanel/MarginContainer/VBoxContainer/SynergyContainer
@onready var SynergyTraitList:VBoxContainer = $TraitControl/TraitPanel/MarginContainer/VBoxContainer/SynergyContainer/SynergyTraitList

enum MODE { SELECT_RESEARCHERS, DETAILS_ONLY, HIDE }

const ResearcherCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/RESEARCHER/ResearcherCard.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")
const ResearcherMiniCard:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ResearcherMiniCard/ResearcherMiniCard.tscn")
const cards_in_list:int = 3
		
var researcher_active_index:int = -1 : 
	set(val):
		researcher_active_index = val
		on_researcher_active_index_update()
		
var selected_researchers:Array = [] : 
	set(val):
		selected_researchers = val
		on_selected_researchers_update()
		
var current_mode:MODE = MODE.SELECT_RESEARCHERS : 
	set(val):
		current_mode = val
		on_current_mode_update()

var content_restore_pos:int
var selected_restore_pos:int
var trait_restore_pos:int
var btn_restore_pos:int
var scroll_pos:int 
var is_setup:bool = false
var details_only:bool = false 
var is_animating:bool = false
var custom_min_size:Vector2
var overflow_count:int


# -----------------------------------------------
func _ready() -> void:
	super._ready()
	on_researcher_active_index_update()
	
	SynergyContainer.hide() 
	
	SelectBtn.onClick = func() -> void:		
		match current_mode:
			MODE.SELECT_RESEARCHERS:
				if researcher_active_index not in selected_researchers:
					mark_researcher_as_selected()
				else:
					unmark_researcher(researcher_active_index)
	
	BackBtn.onClick = func() -> void:
		match current_mode:
			MODE.SELECT_RESEARCHERS:
				if selected_researchers.size() == 0:
					user_response.emit({"action": ACTION.RESEARCHERS.BACK})
				else:
					unmark_last_researcher()
			MODE.DETAILS_ONLY:
				user_response.emit({"action": ACTION.RESEARCHERS.BACK})

	ConfirmBtn.onClick = func() -> void:
		current_mode = MODE.HIDE
		var uids:Array = []
		for n in selected_researchers:
			var researcher_details:Dictionary = RESEARCHER_UTIL.get_user_object( hired_lead_researchers_arr[n] )		
			uids.push_back(researcher_details.uid)
		user_response.emit({"action": ACTION.RESEARCHERS.SELECT, "uids": uids})

	
	DetailsBtn.onClick = func() -> void:
		show_details()

	await U.set_timeout(1.0)	
	selected_restore_pos = SelectedPanel.position.x
	content_restore_pos = ResearcherPanel.position.x
	trait_restore_pos = TraitPanel.position.x
	btn_restore_pos = BtnPanelContainer.position.y
	
	is_setup = true
	on_is_showing_update()	
# -----------------------------------------------

# -----------------------------------------------
func start(mark_uids:Array = [], _details_only:bool = false) -> void:
	var selected := []
	details_only = _details_only
	
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if node.uid in mark_uids:
			node.is_selected = true
			selected.push_back(index)

	await U.tick()
	selected_researchers = selected
# -----------------------------------------------

# -----------------------------------------------
func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	hired_lead_researchers_arr = new_val
	if !is_node_ready():return
	
	for node in [ResearcherList]:
		for child in node.get_children():
			child.queue_free()
	
	for index in hired_lead_researchers_arr.size():
		var researcher:Array = hired_lead_researchers_arr[index]
		var details:Dictionary = RESEARCHER_UTIL.get_user_object(researcher)		
		var new_card:Control = ResearcherCardPreload.instantiate()
		new_card.uid = details.uid
		new_card.index = index		
		new_card.onFocus = func(_node:Control):
			if is_animating:return
			match current_mode:
				MODE.SELECT_RESEARCHERS:
					researcher_active_index = index
		new_card.onClick = func() -> void:
			match current_mode:
				MODE.SELECT_RESEARCHERS:
					if researcher_active_index not in selected_researchers:
						mark_researcher_as_selected()
					else:
						unmark_researcher(researcher_active_index)
			
		ResearcherList.add_child(new_card)
		new_card.reveal = true
		
		await U.tick()
		if index < cards_in_list:
			custom_min_size = ResearcherList.size
	
	LessBtn.show() if hired_lead_researchers_arr.size() > cards_in_list else LessBtn.hide()
	MoreBtn.show() if hired_lead_researchers_arr.size() > cards_in_list else MoreBtn.hide()
	AvailableLabel.text = "Researchers available: %s" % [hired_lead_researchers_arr.size()]
		
	ResearcherScrollContainer.custom_minimum_size = custom_min_size
	researcher_active_index = 0
# -----------------------------------------------

# -----------------------------------------------		
func unmark_researcher(marked_index:int) -> void:
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if marked_index == index:
			selected_researchers.erase(marked_index)
			node.is_selected = false
	
	on_selected_researchers_update()
# -----------------------------------------------			

# -----------------------------------------------
func mark_researcher_as_selected(clear:bool = false) -> void:
	if !is_node_ready() or selected_researchers.size() >= 2:return	
	unflip_cards()
	
	var selected_researchers_arr := []

	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if researcher_active_index == index:
			node.is_selected = !node.is_selected
		if node.is_selected:
			selected_researchers_arr.push_back(index)
	
	selected_researchers = selected_researchers_arr		
# -----------------------------------------------		

# -----------------------------------------------
func unflip_cards() -> void:
	if !is_node_ready():return	
	
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if node.flip:
			node.flip = false
# -----------------------------------------------

# -----------------------------------------------
func reset_cards() -> void:
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)		
		node.is_selected = false
		node.is_deselected = false
# -----------------------------------------------	

# -----------------------------------------------
func show_details() -> void:
	if !is_node_ready():return	
	
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)		
		if researcher_active_index == index:
			node.flip = !node.flip
# -----------------------------------------------	

# -----------------------------------------------	
func on_researcher_active_index_update() -> void:
	if !is_node_ready() or researcher_active_index == -1:return		

	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		node.is_active = researcher_active_index == index
	
	var relative_index:int = researcher_active_index - overflow_count
	print('cards in range: ', researcher_active_index, relative_index + cards_in_list)

	if relative_index > 2:
		if researcher_active_index >= cards_in_list:
			overflow_count += 1
			next_set()
	
	if relative_index < 0:
		if overflow_count > 0:
			overflow_count -= 1
			back_set()

# -----------------------------------------------	


# -----------------------------------------------		
func unmark_last_researcher() -> void:
	var revert_index:int = selected_researchers.pop_back()
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if index == revert_index:
			selected_researchers.erase(revert_index)
			node.is_selected = false
		node.is_deselected = false
	
	on_selected_researchers_update()
# -----------------------------------------------			

# -----------------------------------------------
func next_set() -> void:
	is_animating = true
	var current_scroll:int = ResearcherScrollContainer.scroll_horizontal
	await U.tween_range(current_scroll, current_scroll + custom_min_size.x/cards_in_list, 0.2, func(val:float) -> void:
		ResearcherScrollContainer.scroll_horizontal = val		
	).finished  
	is_animating = false
# -----------------------------------------------	

# -----------------------------------------------
func back_set() -> void:
	is_animating = true
	var current_scroll:int = ResearcherScrollContainer.scroll_horizontal
	await U.tween_range(current_scroll, current_scroll - custom_min_size.x/cards_in_list, 0.2, func(val:float) -> void:
		ResearcherScrollContainer.scroll_horizontal = val
	).finished  
	is_animating = false
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
	
	for node in [RightSideBtnList, LeftSideBtnList]:
		for btn in node.get_children():
			btn.is_disabled = true
	
	U.tween_node_property(TraitPanel, "position:x", trait_restore_pos + TraitPanel.size.x + 20) 
	U.tween_node_property(SelectedPanel, "position:x", selected_restore_pos - SelectedPanel.size.x )
	
	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1 if is_showing else 0))
	U.tween_node_property(ResearcherPanel, "modulate", Color(1, 1, 1, 1 if is_showing else 0))

	U.tween_node_property(ResearcherPanel, "position:x", content_restore_pos if is_showing else ResearcherPanel.size.x + 20)
	await U.tween_node_property(BtnPanelContainer, "position:y", btn_restore_pos if is_showing else BtnPanelContainer.size.y + 20)
	
	# clear and reset

	# reset scroll
	ResearcherScrollContainer.scroll_horizontal = 0
	
	await U.tick()
	
	# reset selected	
	researcher_active_index = -1 if hired_lead_researchers_arr.is_empty() else 0
	overflow_count = 0
	
	if is_showing:
		current_mode = MODE.DETAILS_ONLY if details_only else MODE.SELECT_RESEARCHERS
	else:
		reset_cards()
		selected_researchers = []
# -----------------------------------------------

# -----------------------------------------------	
func on_selected_researchers_update() -> void:
	if !is_node_ready():return

	for child in [TraitList, SynergyTraitList, SelectedList]:
		for item in child.get_children():
			item.queue_free()
		
	var total_traits_list := []
	var synergy_traits := []
	var dup_list := []
	
	# get traits from selected researchers and add to mini list
	for n in selected_researchers:
		# add to selected list
		var researcher_details:Dictionary = RESEARCHER_UTIL.get_user_object( hired_lead_researchers_arr[n] )
		var mini_card:Control = ResearcherMiniCard.instantiate()
		mini_card.uid = researcher_details.uid
		SelectedList.add_child(mini_card)
		
		# add selected to selected list	
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
	
	# hide/show Trait Panel
	if current_mode == MODE.SELECT_RESEARCHERS:
		if total_traits_list.size() > 0:
			U.tween_node_property(SelectedPanel, "position:x", selected_restore_pos)
			U.tween_node_property(TraitPanel, "position:x", trait_restore_pos)
		else:
			U.tween_node_property(SelectedPanel, "position:x", selected_restore_pos - SelectedPanel.size.x )
			U.tween_node_property(TraitPanel, "position:x", trait_restore_pos + TraitPanel.size.x + 20)
	
	# show/hide button
	if current_mode == MODE.SELECT_RESEARCHERS:				
		ConfirmBtn.show() if selected_researchers.size() >= 1 else ConfirmBtn.hide()
	
	# add deselected (black/white filter) when at capacity
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if selected_researchers.size() == 2:
			if index not in selected_researchers:
				node.is_deselected = true
		else:
			node.is_deselected = false	
# -----------------------------------------------		

# -----------------------------------------------
func on_current_mode_update() -> void:
	if !is_node_ready():return
	match current_mode:
		# ---------------
		MODE.SELECT_RESEARCHERS:
			for btn in [DetailsBtn, BackBtn, SelectBtn, ConfirmBtn]:
				btn.is_disabled = false
			SelectBtn.show()
		# ---------------
		MODE.DETAILS_ONLY:
			for btn in [DetailsBtn, BackBtn, SelectBtn, ConfirmBtn]:
				btn.is_disabled = false
			SelectBtn.hide()
			ConfirmBtn.hide()
		# ---------------
		MODE.HIDE:
			for node in [RightSideBtnList, LeftSideBtnList]:
				for btn in node.get_children():
					btn.is_disabled = true
# -----------------------------------------------

# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs or is_animating: 
		return

	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"A":
			unflip_cards()
			researcher_active_index = U.min_max(researcher_active_index - 1, 0, ResearcherList.get_child_count() - 1)
		"D":
			unflip_cards()
			researcher_active_index = U.min_max(researcher_active_index + 1, 0, ResearcherList.get_child_count() - 1)
	
	if current_mode == MODE.DETAILS_ONLY:
		selected_researchers = [researcher_active_index]
#  -----------------------------------		
