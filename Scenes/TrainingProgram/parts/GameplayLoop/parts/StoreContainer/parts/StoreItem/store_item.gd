@tool
extends BtnBase

@onready var NameLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/NameLabel
@onready var ContainIcon:Control = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ContainIcon
@onready var ImageTextureRect:TextureRect = $MarginContainer/VBoxContainer/PanelContainer/TextureRect
@onready var CostContainer:Control = $MarginContainer/VBoxContainer/CostContainer
@onready var Duration:Control = $MarginContainer/VBoxContainer/HBoxContainer/Duration
@onready var AlreadyOwned:PanelContainer = $AlreadyOwned
@onready var InProgress:PanelContainer = $InProgress
@onready var MaxOwned:PanelContainer = $MaxOwned

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

@export var active_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE) if !Engine.is_editor_hint() else Color.WHITE :
	set(val): 
		active_color = val
		on_focus()
		
@export var inactive_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.INACTIVE) if !Engine.is_editor_hint() else Color.WHITE  :
	set(val): 
		inactive_color = val
		on_focus()

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var tab:TIER.TYPE = TIER.TYPE.FACILITY

var resources_data:Dictionary = {}
var purchased_facility_arr:Array = []
var purchased_research_arr:Array = []
var purchased_base_arr:Array = []
#var action_queue_data:Array = []

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_purchased_base_arr(self)
	SUBSCRIBE.subscribe_to_purchased_research_arr(self)
	#SUBSCRIBE.subscribe_to_action_queue_data(self)
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_base_arr(self)
	SUBSCRIBE.unsubscribe_to_purchased_research_arr(self)
	#SUBSCRIBE.unsubscribe_to_action_queue_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)

func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)
	
	on_data_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_purchased_facility_arr_update(new_val:Array = purchased_facility_arr) -> void:
	purchased_facility_arr = new_val
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_purchased_base_arr_update(new_val:Array = purchased_base_arr) -> void:
	purchased_base_arr = new_val
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_purchased_research_arr_update(new_val:Array = purchased_research_arr) -> void:
	purchased_research_arr = new_val
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_data_update() -> void:
	if is_node_ready() and !data.is_empty() and !resources_data.is_empty():
		NameLabel.text = data.details.name		
		var can_contain:bool = data.details.can_contain if "can_contain" in data.details else false	
		ContainIcon.show() if can_contain else ContainIcon.hide()
		Duration.title = str(data.details.get_build_time.call()) if "get_build_time" in data.details else "N/A"
		ImageTextureRect.texture = CACHE.fetch_image(data.details.img_src if "img_src" in data.details else "")
		
		var can_afford:bool = true
		var item_data:Array = []
		var already_owned:bool = false
		var at_own_limit:bool = false
		var in_progress:bool = false
		
		match(tab):
			TIER.TYPE.BASE_DEVELOPMENT:
				var purchased_ids:Array = purchased_base_arr.map(func(i): return i.data.ref)
				var in_progress_ids:Array = [] #action_queue_data.filter(func(i): return i.action == ACTION.BASE_ITEM).map(func(i): return i.data.ref)
				
				already_owned = data.ref in purchased_ids
				in_progress = data.ref in in_progress_ids

				InProgress.show() if in_progress else InProgress.hide()
				AlreadyOwned.show() if already_owned else AlreadyOwned.hide()
				MaxOwned.hide()
				
				item_data = BASE_UTIL.return_purchase_cost(data.ref)
							
			TIER.TYPE.RESEARCH_AND_DEVELOPMENT:
				var purchased_ids:Array = purchased_research_arr.map(func(i): return i.data.ref)
				var in_progress_ids:Array = [] #action_queue_data.filter(func(i): return i.action == ACTION.AQ.RESEARCH_ITEM).map(func(i): return i.data.ref)
				
				already_owned = data.ref in purchased_ids
				in_progress = data.ref in in_progress_ids

				InProgress.show() if in_progress else InProgress.hide()
				AlreadyOwned.show() if already_owned else AlreadyOwned.hide()
				MaxOwned.hide()
				
				item_data = RD_UTIL.return_purchase_cost(data.ref)
			TIER.TYPE.FACILITY:
				at_own_limit = ROOM_UTIL.at_own_limit(data.ref)
				item_data = ROOM_UTIL.return_purchase_cost(data.ref)

				AlreadyOwned.hide()
				InProgress.hide()
				MaxOwned.show() if at_own_limit else MaxOwned.hide()
		
		for item in item_data:
			var amount:int = abs(item.amount)
			var resource:Dictionary = item.resource
			var new_node:Control = TextBtnPreload.instantiate()
			new_node.is_hoverable = false
			new_node.icon = resource.icon
			new_node.title = str(amount)
			CostContainer.add_child(new_node)

			if already_owned or in_progress:
				new_node.is_disabled = true
				
			if resources_data[resource.ref].amount < amount:
				new_node.is_disabled = true
				can_afford = false
		
		if already_owned or in_progress or at_own_limit or !can_afford:
			onClick = func() -> void:
				pass
# ------------------------------------------------------------------------------	
	

## ------------------------------------------------------------------------------
#func on_focus(state:bool = is_focused) -> void:
	#super.on_focus(state)
#
#func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	#super.on_mouse_click(node, btn, on_hover)
## ------------------------------------------------------------------------------
#
