@tool
extends PanelContainer

# --------------------------------------------
@onready var HeaderTitle:Label = $MarginContainer/VBoxContainer/Label

@onready var Morale:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/Morale
@onready var Safety:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/Safety
@onready var Readiness:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/Readiness

@onready var MoraleTag:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/MoraleTag
@onready var SafetyTag:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/SafetyTag
@onready var ReadinessTag:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/ReadinessTag
# --------------------------------------------

# --------------------------------------------
@export var header:String  = "" : 
	set(val):
		header = val
		on_header_update()
		
@export var morale_val:int : 
	set(val):
		morale_val = val
		on_morale_val_update()
		
@export var safety_val:int : 
	set(val):
		safety_val = val
		on_safety_val_update()
		
@export var readiness_val:int : 
	set(val):
		readiness_val = val
		on_readiness_val_update()
		
@export var morale_tag_val:int : 
	set(val):
		morale_tag_val = val
		on_morale_tag_val_update()
		
@export var safety_tag_val:int : 
	set(val):
		safety_tag_val = val
		on_safety_tag_val_update()		
		
@export var readiness_tag_val:int : 
	set(val):
		readiness_tag_val = val
		on_readiness_tag_val_update()
# --------------------------------------------

# --------------------------------------------
func _ready() -> void:
	on_header_update()
	
	on_morale_val_update()
	on_safety_val_update()
	on_readiness_val_update()
	
	on_morale_tag_val_update()
	on_safety_tag_val_update()
	on_readiness_tag_val_update()
# --------------------------------------------


# --------------------------------------------
func on_header_update() -> void:
	if !is_node_ready():return
	HeaderTitle.text = str(header)
	
func on_morale_val_update() -> void:
	if !is_node_ready():return
	Morale.value = morale_val
	
func on_safety_val_update() -> void:
	if !is_node_ready():return
	Safety.value = safety_val
	
func on_readiness_val_update() -> void:
	if !is_node_ready():return
	Readiness.value = readiness_val
	
func on_morale_tag_val_update() -> void:
	if !is_node_ready():return
	MoraleTag.val = morale_tag_val
	
func on_safety_tag_val_update() -> void:
	if !is_node_ready():return
	SafetyTag.val = safety_tag_val
	
func on_readiness_tag_val_update() -> void:
	if !is_node_ready():return
	ReadinessTag.val = readiness_tag_val
# --------------------------------------------
