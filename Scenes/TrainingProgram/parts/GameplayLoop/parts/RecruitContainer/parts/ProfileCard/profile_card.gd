extends PanelContainer

@onready var NameLabel:Label = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/NameLabel
@onready var SpecContainer:GridContainer = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer2/SpecContainer
@onready var NegTraitsList:VBoxContainer = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer2/HBoxContainer3/NegTraitsList
@onready var PosTraitsList:VBoxContainer = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer2/HBoxContainer3/PosTraitsList

@onready var HireBtn:BtnBase = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer/HireBtn
@onready var NoneAvailable:Control = $NoneAvailable

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
		
# ------------------------------------
func _ready() -> void:
	on_data_update()
	on_none_available_update()
	
	HireBtn.onClick = func() -> void:
		addHire.call(hire_cost)
# ------------------------------------

# ------------------------------------
func on_none_available_update() -> void:
	if !is_node_ready():return
	NoneAvailable.show() if none_available else NoneAvailable.hide()
# ------------------------------------

# ------------------------------------
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	
	for node in [PosTraitsList, SpecContainer, NegTraitsList]:
		for child in node.get_children():
			child.queue_free()
	
	
	
	NameLabel.text = data.name
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
