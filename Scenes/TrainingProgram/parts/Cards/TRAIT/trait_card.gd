@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var NameLabel:Label = $VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/HBoxContainer/NameLabel
@onready var IconBtn:BtnBase = $VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/HBoxContainer/IconBtn
@onready var DescriptionLabel:Label = $VBoxContainer/MarginContainer/VBoxContainer/MarginContainer/DescriptionLabel
@onready var OutputContainer:PanelContainer = $VBoxContainer/MarginContainer/VBoxContainer/OutputContainer
@onready var ResourceGrid:GridContainer = $VBoxContainer/MarginContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/ResourceGrid
@onready var MetricList:VBoxContainer = $VBoxContainer/MarginContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/MetricList

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

@export var show_output:bool = false : 
	set(val):
		show_output = val
		on_show_output_update()

@export var is_synergy:bool = false : 
	set(val):
		is_synergy = val
		on_is_synergy_update()
		
@export var is_highlighted: bool = false : 
	set(val):
		is_highlighted = val
		on_is_highlighted_update()
		
var ref:int = -1 : 
	set(val):
		ref = val
		on_ref_update()
		
var effect:Dictionary = {} : 
	set(val):
		effect = val
		on_effect_update()

func _ready() -> void:
	on_show_output_update()
	on_ref_update()
	on_effect_update()
	on_is_synergy_update()
	on_is_highlighted_update()
	

func on_show_output_update() -> void:
	if !is_node_ready():return
	OutputContainer.show() if show_output and !effect.is_empty() else OutputContainer.hide()
	

func on_is_synergy_update() -> void:
	if !is_node_ready():return
	var copy_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	copy_stylebox.bg_color = Color(1, 0.745, 0.381) if is_synergy else Color(0.316, 0.249, 0.37)

	IconBtn.show() if is_synergy else IconBtn.hide()
	RootPanel.add_theme_stylebox_override('panel', copy_stylebox)
	
func on_is_highlighted_update() -> void:
	if !is_node_ready():return
	var copy_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	copy_stylebox.border_color = Color.WHITE if is_highlighted else Color.BLACK
	copy_stylebox.bg_color = Color(0.0, 0.529, 1.0) if is_highlighted else Color(0.316, 0.249, 0.37)
	RootPanel.add_theme_stylebox_override('panel', copy_stylebox)
	
func on_effect_update() -> void:
	if !is_node_ready() or effect.is_empty():return

func on_ref_update() -> void:
	if !is_node_ready() or ref == -1:return
	var details:Dictionary = RESEARCHER_UTIL.return_synergy_trait_data(ref) if is_synergy else RESEARCHER_UTIL.return_trait_data(ref)
	NameLabel.text = details.name
	#DescriptionLabel.text = details.description
	
