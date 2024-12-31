@tool
extends GameContainer

@onready var FacilityBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/HBoxContainer/FacilityBtn
@onready var BaseBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/HBoxContainer/BaseBtn
@onready var RDBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/HBoxContainer/RDBtn 
@onready var CloseBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/CloseBtn
@onready var GridItemContainer:GridContainer = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer
@onready var FocusDetails:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/FocusDetails
@onready var CategoryContainer:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/CategoryContainer

@onready var T0Btn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/T0Btn
@onready var T1Btn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/T1Btn
@onready var T2Btn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/T2Btn
@onready var T3Btn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/T3Btn
@onready var T4Btn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/T4Btn

@onready var TierUnlock:PanelContainer = $SubViewport/PanelContainer/TierUnlock
@onready var TierBtnContainer:HBoxContainer = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/TierBtnContainer

@onready var PaginationBack:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer2/PaginationBackBtn
@onready var PaginationMore:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer2/PaginationMoreBtn

const StoreItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/StoreContainer/parts/StoreItem/StoreItem.tscn")
const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

enum TAB { FACILITY, BASE_DEVELOPMENT, RESEARCH_AND_DEVELOPMENT }

var focus_data:Dictionary = {} : 
	set(val):
		focus_data = val
		on_focus_data_update()

var filters:Dictionary = {} : 
	set(val):
		filters = val
		on_filters_update()

var active_filters:Array = [] : 
	set(val):
		active_filters = val
		
var is_busy:bool = false
var pagination:int = 0 : 
	set(val):
		pagination = val
		on_pagination_update()

var current_tab:TAB = TAB.FACILITY : 
	set(val):
		current_tab = val
		on_current_tab_update()

var current_tier:TIER.VAL = TIER.VAL.ZERO : 
	set(val):
		current_tier = val
		on_current_tier_update()
		
var tier_unlock_data:Dictionary = {} : 
	set(val): 
		tier_unlock_data = val
		on_tier_unlock_data_update()
		
var limit:int = 6

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport

	CloseBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.BACK})
	
	PaginationBack.onClick = func() -> void:
		pagination = pagination - 1
	
	PaginationMore.onClick = func() -> void:
		pagination = pagination + 1
	
	FacilityBtn.onClick = func() -> void:
		current_tab = TAB.FACILITY
		
	BaseBtn.onClick = func() -> void:
		if ROOM_UTIL.get_count(ROOM.TYPE.CONSTRUCTION_YARD, purchased_facility_arr) > 0:
			current_tab = TAB.BASE_DEVELOPMENT
	
	RDBtn.onClick = func() -> void:
		if ROOM_UTIL.get_count(ROOM.TYPE.R_AND_D_LAB, purchased_facility_arr) > 0:
			current_tab = TAB.RESEARCH_AND_DEVELOPMENT
		
	TierUnlock.onConfirm = func(data:Dictionary) -> void:
		tier_unlock_data = {}
		user_response.emit({
			"action": ACTION.PURCHASE_TIER, 
			"selected": {
				"tier_data": data,
				"tier_type": current_tab
			}
		})
		
	on_focus_data_update()
	on_filters_update()
	on_current_tab_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func start() -> void:	
	build_list()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func end() -> void:
	for child in GridItemContainer.get_children():
		child.queue_free()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_purchased_facility_arr_update(new_val:Array) -> void:
	purchased_facility_arr = new_val
	if !is_node_ready():return
	var has_rd_prereq:bool = ROOM_UTIL.get_count(ROOM.TYPE.R_AND_D_LAB, purchased_facility_arr) > 0 
	var has_base_prereq:bool = ROOM_UTIL.get_count(ROOM.TYPE.CONSTRUCTION_YARD, purchased_facility_arr) > 0
	
	print(has_rd_prereq)
	
	RDBtn.is_disabled = !has_rd_prereq
	RDBtn.icon = SVGS.TYPE.DOT if has_rd_prereq else SVGS.TYPE.LOCK
	
	BaseBtn.is_disabled = !has_base_prereq
	BaseBtn.icon = SVGS.TYPE.DOT if has_base_prereq else SVGS.TYPE.LOCK	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------			
func on_tier_unlocked_update(new_val:Dictionary) -> void:
	super.on_tier_unlocked_update(new_val)
	on_current_tab_update()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func on_current_tab_update() -> void:
	if tier_unlocked.is_empty():return
	pagination = 0
	current_tier = TIER.VAL.ZERO
	
	for child in TierBtnContainer.get_children():
		child.queue_free()	
	
	match current_tab:
		TAB.FACILITY:
			FocusDetails.tab = TIER.TYPE.FACILITY
			
			for item in ROOM_UTIL.get_tier_data().list:
				var btn_node:BtnBase = TextBtnPreload.instantiate()
				btn_node.title = item.details.name
				btn_node.is_disabled = !tier_unlocked[TIER.TYPE.FACILITY][item.id]
				btn_node.icon = SVGS.TYPE.DOT if tier_unlocked[TIER.TYPE.FACILITY][item.id] else SVGS.TYPE.LOCK
				btn_node.onClick = func() -> void:
					if btn_node.is_disabled:
						tier_unlock_data = ROOM_UTIL.get_tier_item(item.id)
					else:
						current_tier = item.id
				TierBtnContainer.add_child(btn_node)
								
		TAB.BASE_DEVELOPMENT:
			FocusDetails.tab = TIER.TYPE.BASE_DEVELOPMENT
			
			for item in BASE_UTIL.get_tier_data().list:
				var btn_node:BtnBase = TextBtnPreload.instantiate()
				btn_node.title = item.details.name
				btn_node.is_disabled = !tier_unlocked[TIER.TYPE.BASE_DEVELOPMENT][item.id]
				btn_node.onClick = func() -> void:
					if btn_node.is_disabled:
						tier_unlock_data = BASE_UTIL.get_tier_item(item.id)
					else:
						current_tier = item.id
				TierBtnContainer.add_child(btn_node)
							
		TAB.RESEARCH_AND_DEVELOPMENT:
			FocusDetails.tab = TIER.TYPE.RESEARCH_AND_DEVELOPMENT
			
			for item in RD_UTIL.get_tier_data().list:
				var btn_node:BtnBase = TextBtnPreload.instantiate()
				btn_node.title = item.details.name
				btn_node.is_disabled = !tier_unlocked[TIER.TYPE.RESEARCH_AND_DEVELOPMENT][item.id]
				btn_node.onClick = func() -> void:
					if btn_node.is_disabled:
						tier_unlock_data = RD_UTIL.get_tier_item(item.id)
					else:
						current_tier = item.id
				TierBtnContainer.add_child(btn_node)
	
	build_list()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func on_current_tier_update() -> void:
	build_list()	
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func on_pagination_update() -> void:
	build_list()
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------			
func on_tier_unlock_data_update() -> void:
	TierUnlock.data = tier_unlock_data
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func is_tier_unlocked() -> bool:
	return false
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func build_list() -> void:
	var start_at:int = pagination * limit
	var list_data:Dictionary = {}
		
	match current_tab:
		TAB.FACILITY:
			list_data = ROOM_UTIL.get_list(current_tier, start_at, limit)
		TAB.RESEARCH_AND_DEVELOPMENT:
			list_data = RD_UTIL.get_list(current_tier, start_at, limit)
		TAB.BASE_DEVELOPMENT:
			list_data = BASE_UTIL.get_list(current_tier, start_at, limit)
			
	PaginationBack.hide() if pagination == 0 else PaginationBack.show()
	PaginationMore.show() if list_data.has_more else PaginationMore.hide()
	
	for child in GridItemContainer.get_children():
		child.queue_free()

	for item in list_data.list:
		var new_node:Control = StoreItemPreload.instantiate()
		new_node.resources_data = resources_data
		new_node.data = item
		match current_tab:
			TAB.FACILITY:
				new_node.tab = TAB.FACILITY
			TAB.RESEARCH_AND_DEVELOPMENT:
				new_node.tab = TAB.RESEARCH_AND_DEVELOPMENT
			TAB.BASE_DEVELOPMENT:
				new_node.tab = TAB.BASE_DEVELOPMENT

		new_node.onClick = func() -> void:
			match current_tab:
				TAB.BASE_DEVELOPMENT:
					user_response.emit({
						"action": ACTION.PURCHASE_BASE_ITEM, 
						"selected": {
							"uid": U.generate_uid(),
							"id": item.id
						}
					})
				TAB.FACILITY:
					user_response.emit({
						"action": ACTION.PURCHASE_BUILD_ITEM, 
						"selected": {
							"uid": U.generate_uid(),
							"id": item.id
						}
					})
				TAB.RESEARCH_AND_DEVELOPMENT:
					user_response.emit({
						"action": ACTION.PURCHASE_RD_ITEM, 
						"selected": {
							"uid": U.generate_uid(),
							"id": item.id
						}
					})
		
		new_node.onFocus = func(node:Control) -> void:		
			update_focus_data.call_deferred(item)
		
		new_node.onBlur = func(node:Control) -> void:
			update_focus_data.call({})
			
		GridItemContainer.add_child(new_node)	
		
	await U.tick()
	is_busy = false		
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------		
func update_focus_data(new_state:Dictionary):
	focus_data = new_state
# --------------------------------------------------------------------------------------------------		
		
# --------------------------------------------------------------------------------------------------
func on_filters_update() -> void:
	var _active_filters = []
	for key in filters:
		var item:Dictionary = filters[key]
		item.node_ref.icon = SVGS.TYPE.PLUS if item.active else SVGS.TYPE.MINUS
		if item.active:
			_active_filters.push_back(key)
			
	active_filters = _active_filters
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------		
func on_focus_data_update() -> void:
	if !is_node_ready(): return
	FocusDetails.data = focus_data
# --------------------------------------------------------------------------------------------------			
