extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG

@onready var BtnPanelContainer:Control = $BtnControl/MarginContainer
@onready var LeftSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList
@onready var DetailsBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList/Details

@onready var RightSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var BackBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn
@onready var SelectBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/SelectBtn
@onready var ConfirmBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/ConfirmBtn
@onready var PromoteBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/PromoteBtn

@onready var ResearcherPanel:Control = $ResearcherControl/PanelContainer
@onready var ResearcherLabel:Label = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Label
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

@onready var PromoteControlPanel:Control = $PromoteControl/MarginContainer
@onready var PromotionCard:Control = $PromoteControl/MarginContainer/HBoxContainer/ResearcherCardContainer/PromotionCard
@onready var PromotionLabel:Label = $PromoteControl/MarginContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PromotionLabel
@onready var NewTraitList:VBoxContainer = $PromoteControl/MarginContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/MarginContainer/NewTraitList

enum MODE { SELECT_RESEARCHERS, DETAILS_ONLY, PROMOTE, CONFIRM_PROMOTE, HIDE }

const ResearcherCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/RESEARCHER/ResearcherCard.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")
const ResearcherMiniCard:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ResearcherMiniCard/ResearcherMiniCard.tscn")
const TraitItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResearchersContainer/parts/TraitItem/TraitItem.tscn")
const cards_in_list:int = 3

var new_trait_arr:Array = []

var trait_selected_index:int = 0 : 
	set(val):
		trait_selected_index = val
		on_trait_selected_index_update()

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

var scroll_pos:int 

		
var is_setup:bool = false
var details_only:bool = false 
var promote_mode:bool = false
var is_animating:bool = false
var custom_min_size:Vector2
var overflow_count:int

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	on_researcher_active_index_update()
	
	for node in NewTraitList.get_children():
		node.queue_free()
	
	SelectBtn.onClick = func() -> void:		
		match current_mode:
			MODE.SELECT_RESEARCHERS:
				if researcher_active_index not in selected_researchers:
					mark_researcher_as_selected()
				else:
					unmark_researcher(researcher_active_index)
			MODE.PROMOTE:
				current_mode = MODE.CONFIRM_PROMOTE
	
	BackBtn.onClick = func() -> void:
		match current_mode:
			MODE.SELECT_RESEARCHERS:
				end({"action": ACTION.RESEARCHERS.BACK})
			MODE.CONFIRM_PROMOTE:
				await U.tick()
				current_mode = MODE.PROMOTE

	ConfirmBtn.onClick = func() -> void:
		match current_mode:
			MODE.SELECT_RESEARCHERS:		
				current_mode = MODE.HIDE
				var uids:Array = []
				for n in selected_researchers:
					var researcher_details:Dictionary = RESEARCHER_UTIL.get_user_object( hired_lead_researchers_arr[n] )		
					uids.push_back(researcher_details.uid)
				end({"action": ACTION.RESEARCHERS.SELECT, "uids": uids})
			MODE.CONFIRM_PROMOTE:
				# update promote researcher data
				var details:Dictionary = RESEARCHER_UTIL.get_user_object(hired_lead_researchers_arr[selected_researchers[0]])		
				RESEARCHER_UTIL.promote_researcher(details, new_trait_arr[trait_selected_index])
				
				await U.tween_node_property(PromoteControlPanel, "position:y", control_pos[PromoteControlPanel].hide)
				await U.set_timeout(0.2)
				await U.tween_node_property(ResearcherPanel, "position:x", control_pos[ResearcherPanel].hide) 
 
				end({"action": ACTION.RESEARCHERS.PROMOTED})
	
	PromoteBtn.onClick = func() -> void:
		match current_mode:
			MODE.SELECT_RESEARCHERS:	
				await setup_promotion_screen()
				await U.tick()
				current_mode = MODE.PROMOTE

	MoreBtn.onClick = func() -> void:
		if is_animating:return
		on_dec()
	LessBtn.onClick = func() -> void:
		if is_animating:return
		on_inc()	
		
	DetailsBtn.onClick = func() -> void:
		show_details()

	is_setup = true
	on_is_showing_update(true)	
# -----------------------------------------------

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()
	
	control_pos_default[BtnPanelContainer] = BtnPanelContainer.position
	control_pos_default[SelectedPanel] = SelectedPanel.position
	control_pos_default[ResearcherPanel] = ResearcherPanel.position
	control_pos_default[TraitPanel] = TraitPanel.position
	control_pos_default[PromoteControlPanel] = PromoteControlPanel.position
	
	update_control_pos()
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
	
	control_pos[BtnPanelContainer] = {
		"show": control_pos_default[BtnPanelContainer].y + y_diff, 
		"hide": control_pos_default[BtnPanelContainer].y + y_diff + BtnPanelContainer.size.y
	}
		
	control_pos[SelectedPanel] = {
		"show": control_pos_default[SelectedPanel].y, 
		"hide": control_pos_default[SelectedPanel].y - SelectedPanel.size.y
	}
	
	control_pos[ResearcherPanel] = {
		"show": control_pos_default[ResearcherPanel].x,
		"hide": control_pos_default[ResearcherPanel].x - ResearcherPanel.size.x
	}
	
	control_pos[TraitPanel] = {
		"show": control_pos_default[TraitPanel].y,
		"hide": control_pos_default[TraitPanel].y - TraitPanel.size.y
	}	
	
	control_pos[PromoteControlPanel] = {
		"show": control_pos_default[PromoteControlPanel].x,
		"hide": control_pos_default[PromoteControlPanel].x - PromoteControlPanel.size.x
	}	
	
	on_is_showing_update(true)
# --------------------------------------------------------------------------------------------------	


# -----------------------------------------------
func on_is_showing_update(skip_animation:bool = false) -> void:
	super.on_is_showing_update()
	if !is_setup or control_pos.is_empty():return

	for node in [RightSideBtnList, LeftSideBtnList]:
		for btn in node.get_children():
			btn.is_disabled = true
	
	PromotionCard.reveal = false
	
	U.tween_node_property(PromoteControlPanel, "position:y", control_pos[PromoteControlPanel].hide, 0 if skip_animation else 0.3) 
	U.tween_node_property(TraitPanel, "position:y", control_pos[TraitPanel].hide, 0 if skip_animation else 0.3) 
	U.tween_node_property(SelectedPanel, "position:x", control_pos[SelectedPanel].hide, 0 if skip_animation else 0.3 )
	
	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1 if is_showing else 0), 0 if skip_animation else 0.3)
	U.tween_node_property(ResearcherPanel, "modulate", Color(1, 1, 1, 1 if is_showing else 0), 0 if skip_animation else 0.3)

	U.tween_node_property(ResearcherPanel, "position:x", control_pos[ResearcherPanel].show if is_showing else control_pos[ResearcherPanel].hide, 0 if skip_animation else 0.3)
	await U.tween_node_property(BtnPanelContainer, "position:y", control_pos[BtnPanelContainer].show if is_showing else control_pos[BtnPanelContainer].hide, 0 if skip_animation else 0.3)
	
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
func start(mark_uids:Array = [], _details_only:bool = false) -> void:
	var selected := []
	details_only = _details_only	
	
	ResearcherLabel.text = "RESEARCHER DETAILS" if details_only else "SELECT RESEARCHER"
	
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		node.is_deselected = false
		if node.uid in mark_uids:
			node.is_selected = true
			selected.push_back(index)

	await U.tick()
	selected_researchers = selected
# -----------------------------------------------

# -----------------------------------------------
func promote(uids:Array) -> void:
	await U.tick()
	
	ResearcherLabel.text = "PROMOTE RESEARCHER"
	
	trait_selected_index = 0
	promote_mode = true
	ConfirmBtn.hide()
	selected_researchers = []
	new_trait_arr = []
# -----------------------------------------------


# -----------------------------------------------
func end(response:Dictionary) -> void:
	current_mode = MODE.HIDE	
	trait_selected_index = 0
	promote_mode = false
	
	U.tween_node_property(PromoteControlPanel, "position:y", control_pos[PromoteControlPanel].hide) 
	U.tween_node_property(TraitPanel, "position:y", control_pos[TraitPanel].hide) 
	U.tween_node_property(SelectedPanel, "position:x", control_pos[SelectedPanel].hide) 
	U.tween_node_property(ResearcherPanel, "position:x", control_pos[ResearcherPanel].hide) 
	await U.tween_node_property(BtnPanelContainer, "position:y", control_pos[BtnPanelContainer].hide) 	
	
	for node in NewTraitList.get_children():
		node.queue_free()	
	
	user_response.emit(response)
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
					if promote_mode:
						if selected_researchers.is_empty():	
							mark_researcher_as_selected()
						else:
							unmark_researcher(researcher_active_index)
					else:
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

	if relative_index > 2:
		if researcher_active_index >= cards_in_list:
			overflow_count += 1
			next_set()
	
	if relative_index < 0:
		if overflow_count > 0:
			overflow_count -= 1
			back_set()
			
	await U.tick()
	
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		node.is_hoverable = index >= overflow_count and index < overflow_count + cards_in_list
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
func setup_promotion_screen() -> void:
	var FreeControl:Control 
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		node.reveal = false
		node.flip = false
	
	if new_trait_arr.is_empty():
		var details:Dictionary = RESEARCHER_UTIL.get_user_object(hired_lead_researchers_arr[selected_researchers[0]])
		new_trait_arr = RESEARCHER_UTIL.get_randomized_traits(3, details.traits)
	
						
	var researcher_details:Dictionary = RESEARCHER_UTIL.get_user_object( hired_lead_researchers_arr[selected_researchers[0]]  )
	PromotionLabel.text = "RESEARCHER %s HAS PROMOTED TO LEVEL %s!" % [researcher_details.name, researcher_details.level + 1]
	PromotionCard.uid = researcher_details.uid
	PromotionCard.reveal = true
	
	for node in NewTraitList.get_children():
		node.free()
	
	for index in new_trait_arr.size():
		var trait_item:Control = TraitItemPreload.instantiate()
		var trait_ref:int = new_trait_arr[index]
		trait_item.trait_ref = trait_ref
		trait_item.is_selected = index == trait_selected_index
		trait_item.onFocus = func(_node:Control) -> void:
			if current_mode != MODE.PROMOTE:return
			trait_selected_index = index
		NewTraitList.add_child(trait_item)	
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
	for n in selected_researchers.size():
		# add to selected list
		var researcher_details:Dictionary = RESEARCHER_UTIL.get_user_object( hired_lead_researchers_arr[n] )
		var mini_card:Control = ResearcherMiniCard.instantiate()
		mini_card.uid = researcher_details.uid
		#mini_card.room_extract = GAME_UTIL.extract_room_details(current_location)
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
		U.tween_node_property(SelectedPanel, "position:x", control_pos[SelectedPanel].show if total_traits_list.size() > 0 else control_pos[SelectedPanel].hide)
		U.tween_node_property(TraitPanel, "position:y", control_pos[TraitPanel].show if total_traits_list.size() > 0 else control_pos[TraitPanel].hide)


	# add deselected (black/white filter) when at capacity
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if selected_researchers.size() == (1 if promote_mode else 2):
			if index not in selected_researchers:
				node.is_deselected = true
		else:
			node.is_deselected = false	
			
	# show/hide button
	await U.tick()	
	
	if promote_mode:
		PromoteBtn.hide() if selected_researchers.is_empty() else PromoteBtn.show()	
	
	else:
		if !details_only:
			ConfirmBtn.hide() if selected_researchers.is_empty() else ConfirmBtn.show()			
# -----------------------------------------------		

# -----------------------------------------------
func on_current_mode_update() -> void:
	if !is_node_ready():return
	match current_mode:
		# ---------------
		MODE.HIDE:
			for node in [RightSideBtnList, LeftSideBtnList]:
				for btn in node.get_children():
					btn.is_disabled = true
		# ---------------
		MODE.SELECT_RESEARCHERS:
			for btn in [DetailsBtn, BackBtn, SelectBtn, ConfirmBtn, PromoteBtn]:
				btn.is_disabled = false
			SelectBtn.show()
			PromoteBtn.hide()
		# ---------------
		MODE.DETAILS_ONLY:
			for btn in [DetailsBtn, BackBtn, SelectBtn, ConfirmBtn]:
				btn.is_disabled = false
			SelectBtn.hide()
			ConfirmBtn.hide()
		# ---------------
		MODE.PROMOTE:
			for btn in [DetailsBtn, BackBtn, SelectBtn, ConfirmBtn, PromoteBtn]:
				btn.is_disabled = false	
				
			for index in NewTraitList.get_child_count():
				var trait_item:Control = NewTraitList.get_child(index)
				trait_item.is_highlighted = false
			
			DetailsBtn.hide()
			BackBtn.hide()
			ConfirmBtn.hide()
			PromoteBtn.hide()
			SelectBtn.show()
			
			U.tween_node_property(TraitPanel, "position:y", control_pos[TraitPanel].hide) 
			U.tween_node_property(SelectedPanel, "position:x", control_pos[SelectedPanel].hide) 
			await U.tween_node_property(ResearcherPanel, "position:x", control_pos[ResearcherPanel].hide) 
			U.tween_node_property(PromoteControlPanel, "position:y", control_pos[PromoteControlPanel].show) 
		# ---------------
		MODE.CONFIRM_PROMOTE:
			for index in NewTraitList.get_child_count():
				var trait_item:Control = NewTraitList.get_child(index)
				trait_item.is_highlighted = index == trait_selected_index
			
			SelectBtn.hide()
			BackBtn.show()
			ConfirmBtn.show()
			
# -----------------------------------------------

# -----------------------------------------------
func on_trait_selected_index_update() -> void:
	if !is_node_ready():return
	for index in NewTraitList.get_child_count():
		var trait_item:Control = NewTraitList.get_child(index)
		trait_item.is_selected = index == trait_selected_index
	
func on_inc() -> void:
	unflip_cards()
	researcher_active_index = U.min_max(researcher_active_index - 1, 0, ResearcherList.get_child_count() - 1)	

func on_dec() -> void:
	unflip_cards()
	researcher_active_index = U.min_max(researcher_active_index + 1, 0, ResearcherList.get_child_count() - 1)
# -----------------------------------------------

# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs or is_animating: 
		return

	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"W":
			if current_mode != MODE.PROMOTE:return
			trait_selected_index = U.min_max(trait_selected_index - 1, 0, NewTraitList.get_child_count() - 1, true )
		"S":
			if current_mode != MODE.PROMOTE:return
			trait_selected_index = U.min_max(trait_selected_index + 1, 0, NewTraitList.get_child_count() - 1, true )
		"A":
			if current_mode == MODE.PROMOTE or current_mode == MODE.CONFIRM_PROMOTE:return			
			if promote_mode:
				if selected_researchers.is_empty():
					on_inc()
			else:
				on_inc()
		"D":
			if current_mode == MODE.PROMOTE or current_mode == MODE.CONFIRM_PROMOTE:return
			if promote_mode:
				if selected_researchers.is_empty():
					on_dec()
			else:
				on_dec()
	
	if current_mode == MODE.DETAILS_ONLY:
		selected_researchers = [researcher_active_index]
#  -----------------------------------		
