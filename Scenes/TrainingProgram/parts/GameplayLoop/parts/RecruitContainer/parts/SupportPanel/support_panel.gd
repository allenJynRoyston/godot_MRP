extends PanelContainer

@onready var StaffSupport:Control = $HBoxContainer/StaffSupport
@onready var SecuritySupport:Control = $HBoxContainer/SecuritySupport
@onready var DClassSupport:Control = $HBoxContainer/DClassSupport

var addHire:Callable = func():pass

# -----------------------------------------------------------------------------------------------
func _ready() -> void:
	StaffSupport.onHireClick = func(amount:int, cost:int) -> void:
		addHire.call({"resource": RESOURCE.TYPE.STAFF, "amount": amount, "cost": cost})
		
	SecuritySupport.onHireClick = func(amount:int, cost:int) -> void:
		addHire.call({"resource": RESOURCE.TYPE.SECURITY, "amount": amount, "cost": cost})
		
	DClassSupport.onHireClick = func(amount:int, cost:int) -> void:
		addHire.call({"resource": RESOURCE.TYPE.DCLASS, "amount": amount, "cost": cost})
# -----------------------------------------------------------------------------------------------
