@tool
extends CardDrawerClass

@onready var SpecLabel:Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/SpecLabel
@onready var SpecCheckbox:Control = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/SpecCheckBox

@onready var TraitLabel:Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/TraitLabel
@onready var TraitCheckBox:Control = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/TraitCheckBox

@export var outline_color:Color = Color(0.162, 0.162, 0.162) : 
	set(val):
		outline_color = val
		update_label_settings()

@export var spec_name:String = "Spec" :
	set(val):
		spec_name = val 
		on_spec_name_update()
		
@export var trait_name:String = "Trait" :
	set(val):
		trait_name = val 
		on_trait_name_update()

@export var has_spec:bool = false : 
	set(val):
		has_spec = val
		on_has_spec_update()
		
@export var has_trait:bool = false : 
	set(val):
		has_trait = val
		on_has_trait_update()

func _ready() -> void:
	super._ready()
	on_spec_name_update()
	on_trait_name_update()
	on_has_spec_update()
	on_has_trait_update()
	update_label_settings()

func clear() -> void:
	SpecLabel.text = "-"
	TraitLabel.text = "-"
	SpecCheckbox.is_checked = false
	TraitCheckBox.is_checked = false
	
func on_spec_name_update() -> void:
	if !is_node_ready():return
	SpecLabel.text = spec_name
	
func on_trait_name_update() -> void:
	if !is_node_ready():return
	TraitLabel.text = trait_name
	
func on_has_spec_update() -> void:
	if !is_node_ready():return
	SpecLabel.modulate = Color(1,1, 1, 1 if has_spec else 0.5) 
	SpecCheckbox.is_checked = has_spec

func on_has_trait_update() -> void:
	if !is_node_ready():return
	TraitLabel.modulate = Color(1,1, 1, 1 if has_trait else 0.5) 
	TraitCheckBox.is_checked = has_trait
	
func update_label_settings() -> void:
	if !is_node_ready():return
	#var label_settings_copy:LabelSettings = ContentLabel.label_settings.duplicate()
	#label_settings_copy.font_size = 16 if is_small else 32
	#label_settings_copy.outline_size = label_settings_copy.font_size/2
	#label_settings_copy.outline_color = outline_color
	#ContentLabel.label_settings = label_settings_copy
	
