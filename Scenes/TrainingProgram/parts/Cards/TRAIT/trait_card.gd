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
	

func on_show_output_update() -> void:
	if !is_node_ready():return
	OutputContainer.show() if show_output and !effect.is_empty() else OutputContainer.hide()
	

func on_is_synergy_update() -> void:
	if !is_node_ready():return
	var copy_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	copy_stylebox.bg_color = Color(1, 0.745, 0.381) if is_synergy else Color(0.316, 0.249, 0.37)

	IconBtn.show() if is_synergy else IconBtn.hide()
	RootPanel.add_theme_stylebox_override('panel', copy_stylebox)

func on_effect_update() -> void:
	if !is_node_ready() or effect.is_empty():return
	var resource_list:Array = effect.resource_list
	var metric_list:Array = effect.metric_list
	
	for node in [ResourceGrid, MetricList]:
		for child in node.get_children():
			child.queue_free()
	
	ResourceGrid.columns = U.min_max(resource_list.size(), 1, 2)
	for item in resource_list:
		var new_btn:Control = TextBtnPreload.instantiate()
		new_btn.is_hoverable = false
		new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_btn.icon = item.resource.icon
		new_btn.title = "%s%s" % ["+" if item.amount > 0 else "", item.amount]
		ResourceGrid.add_child(new_btn)
	ResourceGrid.hide() if resource_list.is_empty() else ResourceGrid.show()
	
	for item in metric_list:
		var new_btn:Control = TextBtnPreload.instantiate()		
		new_btn.is_hoverable = false
		new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_btn.icon = item.resource.icon
		new_btn.title = "%s%s %s" % ["+" if item.amount > 0 else "", item.amount, item.resource.name]
		MetricList.add_child(new_btn)
	MetricList.hide() if metric_list.is_empty() else MetricList.show()
	
	var dup_label_settings:LabelSettings = DescriptionLabel.label_settings.duplicate()
	dup_label_settings.font_color = Color.RED if resource_list.size() == 0 and metric_list.size() == 0 else Color.WHITE
	DescriptionLabel.label_settings = dup_label_settings
	
	if show_output:
		OutputContainer.hide() if resource_list.size() == 0 and metric_list.size() == 0 else OutputContainer.show()
	

func on_ref_update() -> void:
	if !is_node_ready() or ref == -1:return
	var details:Dictionary = RESEARCHER_UTIL.return_synergy_trait_data(ref) if is_synergy else RESEARCHER_UTIL.return_trait_data(ref)
	NameLabel.text = details.name
	DescriptionLabel.text = details.description
	
