extends PanelContainer

@onready var Admin:PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/Admin
@onready var Researcher:PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/Researchers
@onready var Security:PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/Security
@onready var DClass:PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/DClass

# ----------------------------------------------
@export var admin_count:int :
	set(val):
		admin_count = val
		on_admin_update()
		
@export var researcher_count:int :
	set(val):
		researcher_count = val
		on_researcher_update()
		
@export var security_count:int :
	set(val):
		security_count = val
		on_security_update()
		
@export var dclass_count:int :
	set(val):
		dclass_count = val
		on_dclass_update()
		
@export var admin_max_count:int :
	set(val):
		admin_max_count = val
		on_admin_update()
		
@export var researcher_max_count:int :
	set(val):
		researcher_max_count = val
		on_researcher_update()
		
@export var security_max_count:int :
	set(val):
		security_max_count = val
		on_security_update()

@export var dclass_max_count:int :
	set(val):
		dclass_max_count = val
		on_dclass_update()
# ----------------------------------------------

# ----------------------------------------------
func _ready() -> void:
	on_admin_update()
	on_researcher_update()
	on_security_update()
	on_dclass_update()
# ----------------------------------------------

# ----------------------------------------------
func on_admin_update() -> void:
	if !is_node_ready():return
	Admin.value = admin_count
	Admin.max_val = admin_max_count
	
func on_researcher_update() -> void:
	if !is_node_ready():return
	Researcher.value = researcher_count
	Researcher.max_val = researcher_max_count
	
func on_security_update() -> void:
	if !is_node_ready():return
	Security.value = security_count
	Security.max_val = security_max_count	

func on_dclass_update() -> void:
	if !is_node_ready():return	
	DClass.value = dclass_count
	DClass.max_val = dclass_max_count	
# ----------------------------------------------
