extends MouseInteractions

@onready var MoneyDetails:Control = $MarginContainer/MoneyDetails
@onready var EnergyDetails:Control = $MarginContainer/EnergyDetails

var onFocus:Callable = func():pass
var onBlur:Callable = func():pass
var onClick:Callable = func():pass

var resources_data:Dictionary = {} : 
	set(val):
		resources_data = val	
		on_resources_data_update()

var facility_room_data:Array = [] : 
	set(val):
		facility_room_data = val
		on_facility_room_data_update()		

# ------------------------------------------------------------------------------
func _ready() -> void:
	hide()
	super._ready()
	
	on_resources_data_update()
	on_facility_room_data_update()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func show_details(type:RESOURCE.TYPE) -> void:
	for node in [MoneyDetails, EnergyDetails]:
		node.hide()
		
	match type:
		RESOURCE.TYPE.MONEY:
			MoneyDetails.show()
		RESOURCE.TYPE.ENERGY:
			EnergyDetails.show()
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
func on_resources_data_update() -> void:
	if !is_node_ready():return
	pass

func on_facility_room_data_update() -> void:
	if !is_node_ready():return
	for node in [MoneyDetails, EnergyDetails]:
		node.facility_room_data = facility_room_data
# ------------------------------------------------------------------------------	