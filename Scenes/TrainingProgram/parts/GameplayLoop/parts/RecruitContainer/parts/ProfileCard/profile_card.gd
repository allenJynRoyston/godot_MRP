@tool
extends PanelContainer

@onready var NameLabel:Label = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/NameLabel
@onready var SpecContainer:GridContainer = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer2/SpecContainer
@onready var NegTraitsList:VBoxContainer = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer2/HBoxContainer3/NegTraitsList
@onready var PosTraitsList:VBoxContainer = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer2/HBoxContainer3/PosTraitsList

@onready var HireBtn:BtnBase = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/HireSection/HireBtn
@onready var NoneAvailable:Control = $NoneAvailable

@onready var HireSection:Control = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/HireSection
@onready var VitalsPanel:PanelContainer = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer2/VitalsPanel

@export var hide_hire_section:bool = false : 
	set(val):
		hide_hire_section = val
		on_hide_hire_section_update()

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		
var none_available:bool = false : 
	set(val):
		none_available = val
		on_none_available_update()
		
var addHire:Callable = func():pass

var hire_cost:int = 0

var show_hire_section:bool = false

# ------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_resources_data(self)		
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_resources_data(self)
# ------------------------------------

# ------------------------------------
func _ready() -> void:
	on_data_update()
	on_none_available_update()
	on_hide_hire_section_update()
	
	HireBtn.onClick = func() -> void:
		addHire.call(hire_cost)
# ------------------------------------

# ------------------------------------
func on_none_available_update() -> void:
	if !is_node_ready():return
	NoneAvailable.show() if none_available else NoneAvailable.hide()
# ------------------------------------

# ------------------------------------
func on_hide_hire_section_update() -> void:
	if !is_node_ready():return
	HireSection.hide() if hide_hire_section else HireSection.show()
# ------------------------------------


# ------------------------------------
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	
	for node in [PosTraitsList, SpecContainer, NegTraitsList]:
		for child in node.get_children():
			child.queue_free()
	
	NameLabel.text = data.name
	VitalsPanel.stress = data.stress
	VitalsPanel.sanity = data.sanity
	
	for key in data.specializations:
		var btn_node:BtnBase = TextBtnPreload.instantiate()
		var details:Dictionary = RESEARCHER_UTIL.return_specialization_data(key) 
		btn_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_node.title = details.name
		btn_node.icon = details.icon
		hire_cost += details.hire_cost.call()
		SpecContainer.add_child(btn_node)
	
	for key in data.traits:
		var btn_node:BtnBase = TextBtnPreload.instantiate()
		var details:Dictionary = RESEARCHER_UTIL.return_trait_data(key) 
		btn_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_node.title = details.name
		btn_node.icon = details.icon
		hire_cost += details.hire_cost.call()
		if details.type == 0:
			PosTraitsList.add_child(btn_node)
		else:
			NegTraitsList.add_child(btn_node)
			
	HireBtn.title = str(hire_cost)
# ------------------------------------
