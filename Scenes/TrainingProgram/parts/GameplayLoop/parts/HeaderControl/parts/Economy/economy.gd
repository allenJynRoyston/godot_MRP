@tool
extends PanelContainer

# --------------------------------------------
@onready var HeaderTitle:Label = $MarginContainer/VBoxContainer/Label

@onready var EcoMoney:Control = $MarginContainer/VBoxContainer/HBoxContainer/Money
@onready var EcoMaterial:Control = $MarginContainer/VBoxContainer/HBoxContainer/Material
@onready var EcoResearch:Control = $MarginContainer/VBoxContainer/HBoxContainer/Research
@onready var EcoCore:Control = $MarginContainer/VBoxContainer/HBoxContainer/Core

@onready var IncomeMoney:Control = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/IncomeMoney
@onready var IncomeResearch:Control = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/IncomeResearch
@onready var IncomeMaterial:Control = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/IncomeMaterial
@onready var IncomeCore:Control = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/IncomeCore
# --------------------------------------------

# --------------------------------------------
@export var header:String  = "" : 
	set(val):
		header = val
		on_header_update()
		
@export var money_val:int : 
	set(val):
		money_val = val
		on_money_val_update()
@export var research_val:int: 
	set(val):
		research_val = val
		on_research_val_update()
@export var material_val:int: 
	set(val):
		material_val = val
		on_material_val_update()
@export var core_val:int: 
	set(val):
		core_val = val
		on_core_val_update()

@export var money_income:int: 
	set(val):
		money_income = val
		on_money_income_update()
@export var researcher_income:int: 
	set(val):
		researcher_income = val
		on_researcher_income_update()
@export var material_income:int: 
	set(val):
		material_income = val
		on_material_income_update()
@export var core_income:int: 
	set(val):
		core_income = val
		on_core_income_update()
# --------------------------------------------

# --------------------------------------------
func _ready() -> void:
	on_header_update()
	
	on_money_val_update()
	on_research_val_update()
	on_material_val_update()
	on_core_val_update()
	
	on_money_income_update()
	on_researcher_income_update()
	on_material_income_update()
	on_core_income_update()
# --------------------------------------------

# --------------------------------------------
func on_header_update() -> void:
	if !is_node_ready():return
	HeaderTitle.text = str(header)
	
func on_money_val_update() -> void:
	if !is_node_ready():return
	EcoMoney.amount = money_val
	
func on_research_val_update() -> void:
	if !is_node_ready():return
	EcoResearch.amount = research_val
	
func on_material_val_update() -> void:
	if !is_node_ready():return
	EcoMaterial.amount = material_val
	
func on_core_val_update() -> void:
	if !is_node_ready():return	
	EcoCore.amount = core_val
	
func on_money_income_update() -> void:
	if !is_node_ready():return	
	IncomeMoney.val = money_income
	
func on_researcher_income_update() -> void:
	if !is_node_ready():return	
	IncomeResearch.val = researcher_income
	
func on_material_income_update() -> void:
	if !is_node_ready():return	
	IncomeMaterial.val = material_income
	
func on_core_income_update() -> void:
	if !is_node_ready():return	
	IncomeCore.val = core_income
# --------------------------------------------
