extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var NameLabel:Label = $VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/HBoxContainer/NameLabel
@onready var IconBtn:BtnBase = $VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/HBoxContainer/IconBtn
@onready var DescriptionLabel:Label = $VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/DescriptionLabel

var ref:int = -1 : 
	set(val):
		ref = val
		on_ref_update()

var is_synergy:bool = false 
		
func _ready() -> void:
	on_ref_update()

func on_ref_update() -> void:
	if !is_node_ready() or ref == -1:return
	var details:Dictionary = RESEARCHER_UTIL.return_synergy_trait_data(ref) if is_synergy else RESEARCHER_UTIL.return_trait_data(ref)
	
	var copy_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	copy_stylebox.bg_color = Color(0.455, 0.002, 0.713) if is_synergy else Color(0, 0.255, 0.082)
	IconBtn.show() if is_synergy else IconBtn.hide()
	
	RootPanel.add_theme_stylebox_override('panel', copy_stylebox)
	NameLabel.text = details.name
	DescriptionLabel.text = details.description
	
