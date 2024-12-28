extends MouseInteractions

@onready var RootNode:Control = $"."
@onready var MoneyDetails:Control = $MarginContainer/MoneyDetails
@onready var EnergyDetails:Control = $MarginContainer/EnergyDetails
@onready var LeadResearcherDetails:Control = $MarginContainer/LeadResearcherDetails
@onready var StaffDetails:Control = $MarginContainer/StaffDetails
@onready var DClassDetails:Control = $MarginContainer/DClassDetails
@onready var SecurityDetails:Control = $MarginContainer/SecurityDetails

var onFocus:Callable = func():pass
var onBlur:Callable = func():pass
var onClick:Callable = func():pass

var resources_data:Dictionary = {} 		
var hired_lead_researchers_arr:Array = []
var purchased_base_arr:Array = [] 

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_purchased_base_arr(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_base_arr(self)

func _ready() -> void:
	hide()
	super._ready()	
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func show_details(type:RESOURCE.TYPE) -> void:
	for node in [MoneyDetails, EnergyDetails, LeadResearcherDetails, StaffDetails, DClassDetails, SecurityDetails]:
		node.hide()
		
	match type:
		RESOURCE.TYPE.MONEY:
			MoneyDetails.show()
		RESOURCE.TYPE.ENERGY:
			EnergyDetails.show()
		RESOURCE.TYPE.LEAD_RESEARCHERS:
			LeadResearcherDetails.show()
		RESOURCE.TYPE.STAFF:
			StaffDetails.show()
		RESOURCE.TYPE.SECURITY:
			SecurityDetails.show()
		RESOURCE.TYPE.DCLASS:
			DClassDetails.show()
	
	RootNode.size = Vector2(0, 0)
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:	
	if !is_node_ready():return	
	is_focused = state
	onFocus.call() if state else onBlur.call()	
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT:
		onClick.call()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val

func on_purchased_base_arr_update(new_val:Array = purchased_base_arr) -> void:
	purchased_base_arr = new_val

func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers_arr) -> void:
	hired_lead_researchers_arr = new_val
# ------------------------------------------------------------------------------	
