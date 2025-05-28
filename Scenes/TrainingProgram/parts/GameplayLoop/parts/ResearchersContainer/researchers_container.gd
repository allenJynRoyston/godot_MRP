extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls

@onready var GridSelect:Control = $GridSelect
@onready var DetailPanel:Control = $DetailPanel
@onready var TransitionScreen:Control = $TransistionScreen

@onready var SummaryPanel:Control = $SummaryControl/PanelContainer
@onready var SummaryMargin:MarginContainer = $SummaryControl/PanelContainer/MarginContainer
@onready var SummaryImage:TextureRect = $SummaryControl/PanelContainer/MarginContainer/VBoxContainer/TextureRect

const ResearcherMiniCard:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ResearcherMiniCard/ResearcherMiniCard.tscn")

var use_location:Dictionary = {}
var assigned_uids:Array = []
var check_for_compatability:bool = false
var check_for_promotions:bool = false

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	DetailPanel.cycle_to_reseacher(true)
	
	setup_gridselect()		

func setup_gridselect() -> void:
	# ---------------- GRID_SELECT CONFIG
	var tabs:Array = [
		{
			"title": "ALL",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return RESEARCHER_UTIL.get_specilization(-1, start_at, end_at),
		}
	]
	
	var available_specs:Array = RESEARCHER_UTIL.get_list_of_specilizations()
	for item in available_specs:
		tabs.push_back({
			"title": item.shortname,
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return RESEARCHER_UTIL.get_specilization(item.ref, start_at, end_at),
		})	
	
	GridSelect.tabs = tabs
	
	GridSelect.onModeTab = func() -> void:
		reveal_node(SummaryPanel, false)
		DetailPanel.reveal(false)
	
	GridSelect.onModeContent = func() -> void:
		reveal_node(SummaryPanel, true)
		DetailPanel.reveal(true)
	
	GridSelect.onUpdate = func(node:Control, data:Dictionary, index:int) -> void:
		var is_compatable:bool = true
		GridSelect.BtnControls.disable_active_btn = !is_compatable
			
	GridSelect.onUpdateEmptyNode = func(node:Control) -> void:
		node.uid = ""
		node.onHover = func() -> void: pass
		node.onClick = func() -> void: pass		
	
	GridSelect.onUpdateNode = func(node:Control, data:Dictionary, index:int) -> void:		
		node.index = index
		node.uid = data.uid
		node.is_hoverable = true
		node.check_for_promotions = check_for_promotions
		
		if check_for_compatability:
			var extract_data:Dictionary = GAME_UTIL.extract_room_details(use_location)
			var res:Dictionary = ROOM_UTIL.check_for_pairing(extract_data.room.details.ref, [data])
			node.spec_required = RESEARCHER_UTIL.return_specialization_data(extract_data.room.details.pairs_with.specilization)
			node.is_incompatable = !res.match_spec
			node.assigned_elsewhere_data = {} if data.props.assigned_to_room.is_empty() else GAME_UTIL.extract_room_details(data.props.assigned_to_room)
			node.is_assigned_elsewhere = !data.props.assigned_to_room.is_empty() and data.uid not in assigned_uids
			node.is_already_assigned = data.uid in assigned_uids
		else:
			node.is_incompatable = false
			node.is_assigned_elsewhere = false
			node.is_already_assigned = false
			node.can_be_promoted = RESEARCHER_UTIL.can_be_promoted(data.uid)

				
		node.onHover = func() -> void:
			if GridSelect.current_mode != GridSelect.MODE.CONTENT_SELECT:return
			GridSelect.grid_index = index
			DetailPanel.researcher_uid = data.uid
			SummaryImage.texture = CACHE.fetch_image(data.img_src)
			
		node.onClick = func() -> void:
			if GridSelect.current_mode != GridSelect.MODE.CONTENT_SELECT or !node.is_clickable:return
			GridSelect.grid_index = index
			
			if node.is_assigned_elsewhere:
				await GridSelect.freeze_and_disable(true, true)
				var confirm:bool = await GAME_UTIL.create_modal(str("Reassign researcher %s to this facility?" % [data.name]), "Will be removed from %s." % node.assigned_elsewhere_data.room.details.name , data.img_src, [], Color(0, 0, 0, 0.7))
				if !confirm:
					GridSelect.freeze_and_disable(false, true)
					return

			end(data.uid)
	
	GridSelect.onValidCheck = func(node:Control) -> bool:
		return node.uid != ""
	
	GridSelect.onAction = func():
		pass
		
	GridSelect.onEnd = func():
		end()	

func activate() -> void:
	await U.tick()

	control_pos[SummaryPanel] = {
		"show": 0, 
		"hide": -SummaryMargin.size.x
	}	

	SummaryPanel.position.x = control_pos[SummaryPanel].hide

func start(_assigned_uids:Array = [], _use_location:Dictionary = {}) -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	TransitionScreen.start()	
	
	use_location = _use_location
	assigned_uids = _assigned_uids
	check_for_compatability = !use_location.is_empty()
	
	var init_func:Callable = func(node:Control) -> void:
		node.uid = ""
	GridSelect.start(ResearcherMiniCard, init_func)


func promote() -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	TransitionScreen.start()	
	
	check_for_promotions = true
	check_for_compatability = false
	
	var init_func:Callable = func(node:Control) -> void:
		node.uid = ""
	GridSelect.start(ResearcherMiniCard, init_func)
	
	
func end(uid:String = "") -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.3)	
	await TransitionScreen.end()
	user_response.emit(uid)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal_node(node:Control, state:bool, duration:float = 0.3) -> void:
	await U.tween_node_property(node, "position:x", control_pos[node].show if state else control_pos[node].hide, duration)	
# --------------------------------------------------------------------------------------------------


















#extends GameContainer
#
#@onready var ColorRectBG:ColorRect = $ColorRectBG
#@onready var BtnControls:Control = $BtnControls
#
#@onready var ResearcherPanel:Control = $ResearcherControl/PanelContainer
#@onready var ResearcherLabel:Label = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Label
#@onready var ResearcherList:HBoxContainer = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/ResearcherList
#
#@onready var MainPanel:PanelContainer = $MainControl/MainPanel
#@onready var LessBtn:BtnBase = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/LessBtn
#@onready var MoreBtn:BtnBase = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MoreBtn
#@onready var GridContent:GridContainer =$MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/GridContainer
#
#@onready var Tabs:HBoxContainer = $HeaderControl/HeaderPanel/MarginContainer/Categories/Tabs
#@onready var HeaderPanel:PanelContainer = $HeaderControl/HeaderPanel
#
#@onready var ActiveHeaderLabel:Label = $ActiveHeader/ActiveHeaderPanel/MarginContainer/HBoxContainer/ActiveHeaderLabel
#@onready var ActiveHeaderPanel:PanelContainer = $ActiveHeader/ActiveHeaderPanel
#@onready var ActiveHeaderMargin:MarginContainer = $ActiveHeader/ActiveHeaderPanel/MarginContainer
#
#
#@onready var AvailableLabel:Label = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/AvailableLabel
##@onready var LessBtn:BtnBase = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/LessBtn
##@onready var MoreBtn:BtnBase = $ResearcherControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/MoreBtn
#
#@onready var SelectedPanel:Control = $SelectedControl/SelectedPanel
#@onready var SelectedList:VBoxContainer = $SelectedControl/SelectedPanel/MarginContainer/VBoxContainer/SelectedContainer/SelectedList
#
#@onready var PromoteControlPanel:Control = $PromoteControl
#@onready var PromoteControlMargin:Control = $PromoteControl/MarginContainer
#@onready var PromotionCard:Control = $PromoteControl/MarginContainer/HBoxContainer/ResearcherCardContainer/PromotionCard
#@onready var PromotionLabel:Label = $PromoteControl/MarginContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PromotionLabel
#@onready var NewTraitList:VBoxContainer = $PromoteControl/MarginContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/MarginContainer/NewTraitList
#
#@onready var TransitionScreen:Control = $TransitionScreen
#
#enum MODE { SELECT_RESEARCHERS, DETAILS_ONLY, PROMOTE, CONFIRM_PROMOTE, HIDE }
#enum NEXT_ACTION { NOTHING, PROMOTE, RETURN }
#
#const ResearcherCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/RESEARCHER/ResearcherCard.tscn")
#const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")
#const ResearcherMiniCard:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ResearcherMiniCard/ResearcherMiniCard.tscn")
#const TraitItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResearchersContainer/parts/TraitItem/TraitItem.tscn")
#const cards_in_list:int = 3
#
#var new_trait_arr:Array = []
#
#var trait_selected_index:int = 0 : 
	#set(val):
		#trait_selected_index = val
		#on_trait_selected_index_update()
#
#var researcher_active_index:int = -1 : 
	#set(val):
		#researcher_active_index = val
		#on_researcher_active_index_update()
		#
#var selected_researchers:Array = [] : 
	#set(val):
		#selected_researchers = val
		#on_selected_researchers_update()
		#
#var current_mode:MODE = MODE.HIDE : 
	#set(val):
		#current_mode = val
		#on_current_mode_update()
#
#var is_setup:bool = false
#var details_only:bool = false 
#var next_action:NEXT_ACTION = NEXT_ACTION.NOTHING
#var is_animating:bool = false
#var custom_min_size:Vector2
#var overflow_count:int
#var pagination_val:int = 0 : 
	#set(val):
		#pagination_val = val
		#on_pagination_val_update()
#var max_pagination:int
#var on_more_or_less_btns:bool = false
#
#var page_tracker:Dictionary = {
	#0:0,
	#1:0,
	#2:0
#}
#
#var grid_as_array:Array = [
	#[0, 1, 2],
	#[3, 4, 5],
	#[6, 7, 8],
#]
#
#
## -----------------------------------------------
#func _ready() -> void:
	#super._ready()
	#
	#self.modulate = Color(1, 1, 1, 0)
#
	#for node in NewTraitList.get_children():
		#node.queue_free()
		#
	#MoreBtn.onClick = func() -> void:
		#if pagination_val == max_pagination or is_animating:return
		#pagination_val = U.min_max(pagination_val + 1, 0, max_pagination)
		#
	#LessBtn.onClick = func() -> void:
		#if pagination_val == 0 or is_animating:return
		#pagination_val = U.min_max(pagination_val - 1, 0, max_pagination)
#
	#BtnControls.onDirectional = on_key_change
#
	##DetailsBtn.onClick = func() -> void:
		##show_details()
		#
#
	#is_setup = true
	#on_current_mode_update()	
## -----------------------------------------------
#
## --------------------------------------------------------------------------------------------------
#func activate() -> void:
	#show()
	#await U.tick()
	#
	#control_pos_default[SelectedPanel] = SelectedPanel.position
	#control_pos_default[ResearcherPanel] = ResearcherPanel.position
	#control_pos_default[PromoteControlPanel] = PromoteControlPanel.position
	#control_pos_default[MainPanel] = MainPanel.position
#
	## set pagination levels
	#max_pagination = floori( (hired_lead_researchers_arr.size() - 1)/cards_in_list) 
		#
	#BtnControls.freeze_and_disable(true)
	#update_control_pos()
## --------------------------------------------------------------------------------------------------	
#
## --------------------------------------------------------------------------------------------------	
#func on_fullscreen_update(state:bool) -> void:
	#update_control_pos()
## --------------------------------------------------------------------------------------------------	
#
## --------------------------------------------------------------------------------------------------		
#func update_control_pos() -> void:	
	#await U.tick()
#
	#control_pos[SelectedPanel] = {
		#"show": control_pos_default[SelectedPanel].x, 
		#"hide": control_pos_default[SelectedPanel].x - SelectedPanel.size.x
	#}
	#
	#control_pos[ResearcherPanel] = {
		#"show": control_pos_default[ResearcherPanel].x,
		#"hide": control_pos_default[ResearcherPanel].x - ResearcherPanel.size.x
	#}
	#
	#control_pos[PromoteControlPanel] = {
		#"show": control_pos_default[PromoteControlPanel].y,
		#"hide": control_pos_default[PromoteControlPanel].y - PromoteControlMargin.size.y
	#}	
	#
	#control_pos[MainPanel] = {
		#"show": control_pos_default[MainPanel].y, 
		#"hide": control_pos_default[MainPanel].y - MainPanel.size.y
	#}	
	#
	#on_current_mode_update(true)
## --------------------------------------------------------------------------------------------------	
#
## -----------------------------------------------
#func assign(mark_uids:Array = [], _details_only:bool = false) -> void:
	#await U.tick()
	#
	#ResearcherLabel.text = "ASSIGN RESEARCHER"
#
	#trait_selected_index = 0
	#next_action = NEXT_ACTION.RETURN
	#selected_researchers = []
	#new_trait_arr = []
	#
	#update_cards()
	#
	#await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1) )	
	#current_mode = MODE.SELECT_RESEARCHERS
## -----------------------------------------------
#
## -----------------------------------------------
#func promote(uids:Array) -> void:
	#await U.tick()
	#
	#ResearcherLabel.text = "SELECT RESEARCHER"
#
	#trait_selected_index = 0
	#next_action = NEXT_ACTION.PROMOTE
	#selected_researchers = []
	#new_trait_arr = []
	#
	#update_cards()
	#U.tween_node_property(self, "modulate", Color(1, 1, 1, 1) )	
	#current_mode = MODE.SELECT_RESEARCHERS
## -----------------------------------------------
#
## -----------------------------------------------
#func end(response:Dictionary) -> void:
	#current_mode = MODE.HIDE
	#await hide_complete
	#await TransitionScreen.end()
	#user_response.emit(response)
## -----------------------------------------------
#
## -----------------------------------------------
#func on_pagination_val_update() -> void:
	#update_cards()
## -----------------------------------------------
	#
## -----------------------------------------------
#func update_cards() -> void:
	#is_animating = true
	#
	#for node in [ResearcherList]:
		#for child in node.get_children():
			#child.queue_free()
			#
	#var list:Array = []
	#var start_at:int = pagination_val * cards_in_list
	#var end_at:int = U.min_max(start_at + cards_in_list, 0, hired_lead_researchers_arr.size())
#
	#for n in range(start_at, end_at):
		#list.push_back(hired_lead_researchers_arr[n])
			#
	#for index in list.size():
		#var researcher:Array = list[index]
		#var details:Dictionary = RESEARCHER_UTIL.get_user_object(researcher)		
		#var new_card:Control = ResearcherCardPreload.instantiate()
#
		#new_card.uid = details.uid
		#new_card.index = index
		#new_card.show_checkbox = true
		#
		#new_card.onFocus = func(_node:Control) -> void:
			#if current_mode == MODE.SELECT_RESEARCHERS:
				#new_card.is_active = true
				#if index not in selected_researchers:
					#selected_researchers.push_back(index)
				#selected_researchers = selected_researchers
				#researcher_active_index = index
		#
		#new_card.onBlur = func(_node:Control) -> void:
			#if current_mode == MODE.SELECT_RESEARCHERS:
				#new_card.is_active = false
				#selected_researchers.erase(index)
				#selected_researchers = selected_researchers
			#
		#new_card.onClick = func() -> void:
			#new_card.is_selected = true
			#match next_action:
				#NEXT_ACTION.PROMOTE:
					#current_mode = MODE.CONFIRM_PROMOTE
				#NEXT_ACTION.RETURN:
					#BtnControls.itemlist = []
					#BtnControls.freeze_and_disable(true)
					#await U.set_timeout(0.3)
					#end({"action": ACTION.RESEARCHERS.SELECT, "uid": details.uid})
			#
		#ResearcherList.add_child(new_card)
		#
		#await U.tick()
		#if index < cards_in_list:
			#custom_min_size = ResearcherList.size
	#
	#AvailableLabel.text = "AVAILABLE: %s/%s" % [pagination_val, max_pagination]
	#
	#researcher_active_index = 0
	#is_animating = false
## -----------------------------------------------
#
#
## -----------------------------------------------
#func unflip_cards() -> void:
	#if !is_node_ready():return	
	#
	#for index in ResearcherList.get_child_count():
		#var node:Control = ResearcherList.get_child(index)
		#if node.flip:
			#node.flip = false
## -----------------------------------------------
#
## -----------------------------------------------
#func reset_cards() -> void:
	#for index in ResearcherList.get_child_count():
		#var node:Control = ResearcherList.get_child(index)		
		#node.is_selected = false
		#node.is_deselected = false
## -----------------------------------------------	
#
## -----------------------------------------------
#func show_details() -> void:
	#if !is_node_ready():return	
	#
	#for index in ResearcherList.get_child_count():
		#var node:Control = ResearcherList.get_child(index)		
		#if researcher_active_index == index:
			#node.flip = !node.flip
## -----------------------------------------------	
#
## -----------------------------------------------	
#func on_selected_researchers_update() -> void:
	#if !is_node_ready() or on_more_or_less_btns:return		
	#BtnControls.disable_active_btn = selected_researchers.is_empty()
## -----------------------------------------------	
#
## -----------------------------------------------	
#func on_researcher_active_index_update() -> void:
	#if !is_node_ready():return		
	#update_trait_cards()
## -----------------------------------------------	
#
## -----------------------------------------------	
#func clear_marked_researchers() -> void:
	#for index in ResearcherList.get_child_count():
		#var node:Control = ResearcherList.get_child(index)
		#node.is_selected = false
		#node.is_deselected = false
## -----------------------------------------------			
#
## -----------------------------------------------	
#func setup_promotion_screen() -> void:
	#var FreeControl:Control 
##
	#if new_trait_arr.is_empty():
		#var details:Dictionary = RESEARCHER_UTIL.get_user_object(hired_lead_researchers_arr[researcher_active_index])
		#new_trait_arr = RESEARCHER_UTIL.get_randomized_traits(3, details.traits)
						#
	#var researcher_details:Dictionary = RESEARCHER_UTIL.get_user_object( hired_lead_researchers_arr[selected_researchers[0]]  )
	#PromotionLabel.text = "RESEARCHER %s IS PROMOTED TO LEVEL %s!" % [researcher_details.name, researcher_details.level + 1]
	#PromotionCard.uid = researcher_details.uid
	#PromotionCard.reveal = true
	#
	#for node in NewTraitList.get_children():
		#node.free()
	#
	#for index in new_trait_arr.size():
		#var trait_item:Control = TraitItemPreload.instantiate()
		#var trait_ref:int = new_trait_arr[index]
		#trait_item.trait_ref = trait_ref
		#trait_item.is_selected = index == trait_selected_index
		#
		#trait_item.onFocus = func(_node:Control) -> void:
			#if current_mode != MODE.PROMOTE:return
			#trait_selected_index = index
		#
		#trait_item.onClick = func() -> void:
			## update promote researcher data
			#var details:Dictionary = RESEARCHER_UTIL.get_user_object(hired_lead_researchers_arr[researcher_active_index])		
			#RESEARCHER_UTIL.promote_researcher(details, new_trait_arr[trait_selected_index])
			#end({"action": ACTION.RESEARCHERS.PROMOTED})			
			#
		#NewTraitList.add_child(trait_item)	
	#
	#await U.tick()
	#BtnControls.itemlist = NewTraitList.get_children()	
## -----------------------------------------------	
#
## -----------------------------------------------	
#func update_trait_cards() -> void:
	#if !is_node_ready():return
	#
	#for child in [SelectedList]:
		#for item in child.get_children():
			#item.queue_free()
			#
	#if researcher_active_index == -1:return
				#
	#var total_traits_list := []
	#var synergy_traits := []
	#var dup_list := []
#
	#var researcher_details:Dictionary = RESEARCHER_UTIL.get_user_object( hired_lead_researchers_arr[researcher_active_index] )
	#var mini_card:Control = ResearcherMiniCard.instantiate()
	#mini_card.uid = researcher_details.uid
	#SelectedList.add_child(mini_card)
	#
	## add selected to selected list	
	#total_traits_list.push_back(researcher_details.traits)
## -----------------------------------------------		
#
## -----------------------------------------------
#func on_current_mode_update(skip_animation:bool = false) -> void:
	#if !is_node_ready() or control_pos.is_empty():return
	#
	#var duration:float = 0 if skip_animation else 0.3
	#
	#match current_mode:
		## ---------------
		#MODE.HIDE:
			#U.tween_node_property(PromoteControlPanel, "position:y", control_pos[PromoteControlPanel].hide, duration)
			#await BtnControls.reveal(false)	
			#hide_complete.emit()
		## ---------------
		#MODE.SELECT_RESEARCHERS:
			#U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))
			#await TransitionScreen.start()
						#
			#BtnControls.a_btn_title = "SELECT"
			#BtnControls.b_btn_title = "BACK"		
			#
			#BtnControls.onBack = func() -> void:
				#end({"action": ACTION.RESEARCHERS.BACK})	
			#BtnControls.onAction = func() -> void:pass	
#
			##GBL.find_node(REFS.ROOM_NODES).is_active = true
			#U.tween_node_property(SelectedPanel, "position:x", control_pos[SelectedPanel].show, duration)			
			#reset_cards()
	#
			#await U.tick()
			#BtnControls.itemlist = ResearcherList.get_children()			
			#await U.tick()
			#BtnControls.item_index = researcher_active_index
			#BtnControls.reveal(true)
		## ---------------
		#MODE.CONFIRM_PROMOTE:
			#BtnControls.itemlist = []
			#BtnControls.a_btn_title = "PROMOTE"
			#BtnControls.b_btn_title = "CANCEL"		
#
			#BtnControls.onBack = func() -> void:
				#current_mode = MODE.SELECT_RESEARCHERS
			#
			#BtnControls.onAction = func() -> void:
				#current_mode = MODE.PROMOTE
				#
				#
			#for index in ResearcherList.get_child_count():
				#var node:Control = ResearcherList.get_child(index)
				#node.is_deselected = index != researcher_active_index				
		## ---------------
		#MODE.PROMOTE:
			#BtnControls.disable_back_btn = true
			#BtnControls.freeze_and_disable(true)
			#BtnControls.a_btn_title = "PROMOTE"
			#BtnControls.directional_pref = "UD"	
			#BtnControls.onAction = func() -> void:pass
			#BtnControls.onBack = func() -> void:pass
			#
#
			#U.tween_node_property(SelectedPanel, "position:x", control_pos[SelectedPanel].hide, duration) 
			#await U.tween_node_property(ResearcherPanel, "position:x", control_pos[ResearcherPanel].hide, duration) 
			#await U.tween_node_property(PromoteControlPanel, "position:y", control_pos[PromoteControlPanel].show, duration) 	
			#
			#setup_promotion_screen()
#
			#BtnControls.freeze_and_disable(false)
#
## -----------------------------------------------
#
## -----------------------------------------------
#func on_trait_selected_index_update() -> void:
	#if !is_node_ready():return
	#for index in NewTraitList.get_child_count():
		#var trait_item:Control = NewTraitList.get_child(index)
		#trait_item.is_selected = index == trait_selected_index
	#
#func on_inc() -> void:
	#unflip_cards()
	#researcher_active_index = U.min_max(researcher_active_index - 1, 0, ResearcherList.get_child_count() - 1)	
#
#func on_dec() -> void:
	#unflip_cards()
	#researcher_active_index = U.min_max(researcher_active_index + 1, 0, ResearcherList.get_child_count() - 1)
## -----------------------------------------------
#
## -----------------------------------------------
#func on_key_change(key:String) -> void:
	#if current_mode != MODE.SELECT_RESEARCHERS:return
	#match key:
		## ---------
		#"W":
			#on_more_or_less_btns = false
			#BtnControls.itemlist = ResearcherList.get_children()	
			#await U.tick()
			#BtnControls.item_index = researcher_active_index
			#on_selected_researchers_update()
		## ---------
		#"S":
			#on_more_or_less_btns = true
			#BtnControls.itemlist = [LessBtn, MoreBtn]
			#await U.tick()
			#BtnControls.item_index = 0
			#BtnControls.disable_active_btn = false
## -----------------------------------------------
			#
