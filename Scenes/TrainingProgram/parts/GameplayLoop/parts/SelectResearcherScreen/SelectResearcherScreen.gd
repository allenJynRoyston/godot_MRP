extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG

@onready var LeftSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList
@onready var RightSideBtnList:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList

@onready var BackBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn
@onready var DetailsBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList/Details
@onready var SelectResearcher:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/SelectResearcher
@onready var ConfirmResearchers:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/ConfirmResearchers

@onready var ResearcherControlPanel:Control = $ResearcherControl/PanelContainer
@onready var ResearcherList:HBoxContainer = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/ResearcherList

@onready var TraitPanel:Control = $TraitControl/TraitPanel
@onready var TraitList:VBoxContainer = $TraitControl/TraitPanel/MarginContainer/VBoxContainer/TraitContainer/TraitList
@onready var SynergyContainer:VBoxContainer = $TraitControl/TraitPanel/MarginContainer/VBoxContainer/SynergyContainer
@onready var SynergyTraitList:VBoxContainer = $TraitControl/TraitPanel/MarginContainer/VBoxContainer/SynergyContainer/SynergyTraitList

@onready var BtnControlPanel:Control = $BtnControl/MarginContainer

enum MODE { HIDE, SELECT_RESEARCHERS, CONFIRM_RESEARCHERS, FINALIZE }

const ResearcherCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/RESEARCHER/ResearcherCard.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")
		
var researcher_active_index:int = -1 : 
	set(val):
		researcher_active_index = val
		on_researcher_active_index_update()
		
var current_mode:MODE = MODE.HIDE : 
	set(val):
		current_mode = val
		on_current_mode_update()

var new_hire_list:Array 
var is_animating:bool = true
var total_options:int = 2


# -----------------------------------------------
func _ready() -> void:
	super._ready()	
	on_researcher_active_index_update()
	
	SynergyContainer.hide() 

	SelectResearcher.onClick = func() -> void:
		if is_animating:return
		if current_mode == MODE.SELECT_RESEARCHERS:
			mark_researcher_as_selected()

	DetailsBtn.onClick = func() -> void:
		if is_animating:return
		show_details()

	
	ConfirmResearchers.onClick = func() -> void:
		if is_animating:return
		if current_mode == MODE.CONFIRM_RESEARCHERS:
			await U.tick()		
			current_mode = MODE.FINALIZE
					
	
	BackBtn.onClick = func() -> void:
		match current_mode:
			MODE.SELECT_RESEARCHERS:
				end(false)
			MODE.CONFIRM_RESEARCHERS:
				revert_confirm()
				await U.tick()
				current_mode = MODE.SELECT_RESEARCHERS
	

# -----------------------------------------------

# -----------------------------------------------
func start() -> void:		
	researcher_active_index = -1
	current_mode = MODE.SELECT_RESEARCHERS
	create_researchers()
# -----------------------------------------------

# -----------------------------------------------
func end(response:bool) -> void:
	U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0))
	U.tween_node_property(ResearcherControlPanel, "position:y", control_pos[ResearcherControlPanel].hide)
	U.tween_node_property(TraitPanel, "position:y", control_pos[TraitPanel].hide)
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide)

	current_mode = MODE.HIDE	
	user_response.emit(response)
# -----------------------------------------------	

# -----------------------------------------------
func on_is_showing_update(skip_animation:bool = false) -> void:
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
# -----------------------------------------------	

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()
	
	control_pos_default[ResearcherControlPanel] = ResearcherControlPanel.position
	control_pos_default[TraitPanel] = TraitPanel.position
	control_pos_default[BtnControlPanel] = BtnControlPanel.position
	
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
	
	control_pos[ResearcherControlPanel] = {
		"show": control_pos_default[ResearcherControlPanel].y, 
		"hide": control_pos_default[ResearcherControlPanel].y - ResearcherControlPanel.size.y
	}
	
	control_pos[TraitPanel] = {
		"show": control_pos_default[TraitPanel].y,
		"hide": control_pos_default[TraitPanel].y - TraitPanel.size.y
	}
	
	control_pos[BtnControlPanel] = {
		"show": control_pos_default[BtnControlPanel].y + y_diff, 
		"hide": control_pos_default[BtnControlPanel].y + y_diff + BtnControlPanel.size.y
	}
	
	on_selected_researchers_update(true)
	on_current_mode_update(true)
# --------------------------------------------------------------------------------------------------	

# -----------------------------------------------
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	is_animating = true
	
	match current_mode:
		# ---------------------
		MODE.HIDE:
			for btn in [SelectResearcher, ConfirmResearchers]:
				btn.is_disabled = true
							
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0), 0 if skip_animation else 0.3)
			U.tween_node_property(ResearcherControlPanel, "position:y", control_pos[ResearcherControlPanel].hide, 0 if skip_animation else 0.3)
			U.tween_node_property(TraitPanel, "position:y", control_pos[TraitPanel].hide, 0 if skip_animation else 0.3)
			U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide, 0 if skip_animation else 0.3)
		# ---------------------
		MODE.SELECT_RESEARCHERS:
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1), 0 if skip_animation else 0.3)
			
			for btn in [SelectResearcher, ConfirmResearchers]:
				btn.is_disabled = false

			for index in ResearcherList.get_child_count():
				var node:Control = ResearcherList.get_child(index)
				node.is_deselected = false
							
			SelectResearcher.show()
			ConfirmResearchers.hide()
			
			U.tween_node_property(ResearcherControlPanel, "position:y", control_pos[ResearcherControlPanel].show, 0 if skip_animation else 0.3)			
			U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show, 0 if skip_animation else 0.3)
		# ---------------------
		MODE.CONFIRM_RESEARCHERS:
			ConfirmResearchers.show()
			SelectResearcher.hide()

			for index in ResearcherList.get_child_count():
				var node:Control = ResearcherList.get_child(index)
				node.is_deselected = researcher_active_index != index
			
		# ---------------------
		MODE.FINALIZE:
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0), 0 if skip_animation else 0.3)
			await U.tween_node_property(ResearcherControlPanel, "position:y", control_pos[ResearcherControlPanel].hide, 0 if skip_animation else 0.3)	

			# add to selected researchers
			hired_lead_researchers_arr.push_back(new_hire_list[researcher_active_index])

			# subscribe
			SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr
			
			end(true)
			
	await U.set_timeout(0.3)
	is_animating = false
# -----------------------------------------------

# -----------------------------------------------
func clear_list() -> void:
	for node in [ResearcherList]:
		for child in node.get_children():
			child.queue_free()
# -----------------------------------------------		

# -----------------------------------------------
func create_researchers() -> void:
	if !is_node_ready():return
	clear_list()
	
	# fills in the 
	new_hire_list = RESEARCHER_UTIL.generate_new_researcher_hires(total_options)
	
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
			if is_animating:return
			match current_mode:
				MODE.SELECT_RESEARCHERS:						
					mark_researcher_as_selected()
				MODE.CONFIRM_RESEARCHERS:
					unmark_researcher(index)
					current_mode = MODE.SELECT_RESEARCHERS
			
		ResearcherList.add_child(new_card)
		new_card.reveal = true

# -----------------------------------------------

# -----------------------------------------------		
func revert_confirm() -> void:
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		node.is_selected = false
# -----------------------------------------------			

# -----------------------------------------------		
func unmark_researcher(marked_index:int) -> void:
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if marked_index == index:
			node.is_selected = false
# -----------------------------------------------			

# -----------------------------------------------
func mark_researcher_as_selected(clear:bool = false) -> void:
	if !is_node_ready():return	
	unflip_cards()

	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)		
		if researcher_active_index == index:
			node.is_selected = !node.is_selected
			if node.is_selected:
				current_mode = MODE.CONFIRM_RESEARCHERS
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
func show_details() -> void:
	if !is_node_ready():return	
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		if researcher_active_index == index:
			node.flip = !node.flip
# -----------------------------------------------		

# -----------------------------------------------	
func on_researcher_active_index_update() -> void:
	if !is_node_ready():return		
	for index in ResearcherList.get_child_count():
		var node:Control = ResearcherList.get_child(index)
		node.is_active = researcher_active_index == index

	on_selected_researchers_update()
# -----------------------------------------------	

# -----------------------------------------------	
func on_selected_researchers_update(force_check:bool = false) -> void:
	if !is_node_ready():return

	for child in [TraitList, SynergyTraitList]:
		for item in child.get_children():
			item.queue_free()
		
	var total_traits_list := []
	var synergy_traits := []
	var dup_list := []
	

	if researcher_active_index != -1 and !new_hire_list.is_empty():
		
		# get traits from selected researchers	
		var researcher_details:Dictionary = RESEARCHER_UTIL.get_user_object( new_hire_list[researcher_active_index] )
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
	
	if control_pos.is_empty():return
	if total_traits_list.size() > 0:
		U.tween_node_property(TraitPanel, "position:y", control_pos[TraitPanel].show)
	else:
		U.tween_node_property(TraitPanel, "position:y", control_pos[TraitPanel].hide)
# -----------------------------------------------		

# -----------------------------------------------	
func on_confirm_scp() -> void:
	await U.tick()
	current_mode = MODE.SELECT_RESEARCHERS
# -----------------------------------------------		

# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs: 
		return

	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"A":
			if current_mode == MODE.SELECT_RESEARCHERS:
				unflip_cards()
				researcher_active_index = U.min_max(researcher_active_index - 1, 0, ResearcherList.get_child_count() - 1)
		"D":
			if current_mode == MODE.SELECT_RESEARCHERS:
				unflip_cards()
				researcher_active_index = U.min_max(researcher_active_index + 1, 0, ResearcherList.get_child_count() - 1)
#  -----------------------------------		
