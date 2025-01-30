extends PanelContainer

@onready var StaffSupport:Control = $HBoxContainer/StaffSupport
@onready var SecuritySupport:Control = $HBoxContainer/SecuritySupport
@onready var DClassSupport:Control = $HBoxContainer/DClassSupport

@onready var MissingPanel:Control = $MissingPanel


var addHire:Callable = func():pass
var purchased_facility_arr:Array = []
var allow_recruitment:bool = false : 
	set(val):
		allow_recruitment = val
		on_allow_recruitment_update()

func _init() -> void:
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)

# -----------------------------------------------------------------------------------------------
func _ready() -> void:
	StaffSupport.onHireClick = func(amount:int, cost:int) -> void:
		if allow_recruitment:
			addHire.call({"resource": RESOURCE.TYPE.STAFF, "amount": amount, "cost": cost})
		
	SecuritySupport.onHireClick = func(amount:int, cost:int) -> void:
		if allow_recruitment:	
			addHire.call({"resource": RESOURCE.TYPE.SECURITY, "amount": amount, "cost": cost})
		
	DClassSupport.onHireClick = func(amount:int, cost:int) -> void:
		if allow_recruitment:
			addHire.call({"resource": RESOURCE.TYPE.DCLASS, "amount": amount, "cost": cost})
		
	on_allow_recruitment_update()
# -----------------------------------------------------------------------------------------------

# ------------------------------------
func on_purchased_facility_arr_update(new_val:Array) -> void:
	if !is_node_ready():return
	purchased_facility_arr = new_val
	allow_recruitment = ROOM_UTIL.get_count(ROOM.TYPE.HR_DEPARTMENT, new_val) > 0 
# ------------------------------------

# ------------------------------------
func on_allow_recruitment_update() -> void:
	if !is_node_ready():return
	MissingPanel.show() if !allow_recruitment else MissingPanel.hide()
# ------------------------------------	
