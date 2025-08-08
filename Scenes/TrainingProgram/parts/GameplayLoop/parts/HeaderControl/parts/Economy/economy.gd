extends PanelContainer

# --------------------------------------------
@onready var Header:PanelContainer = $VBoxContainer/Header

@onready var HeaderTitle:Label = $MarginContainer/VBoxContainer/Label

@onready var EcoMoney:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/Money
@onready var EcoMaterial:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/Material
@onready var EcoResearch:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/Research
@onready var EcoCore:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/Core

#@onready var IncomeMoney:Control = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/IncomeMoney
#@onready var IncomeResearch:Control = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/IncomeResearch
#@onready var IncomeMaterial:Control = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/IncomeMaterial
#@onready var IncomeCore:Control = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/IncomeCore
#
@onready var header_stylebox_copy:StyleBoxFlat = Header.get('theme_override_styles/panel').duplicate() 
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
func _init() -> void:
	GBL.subscribe_to_process(self)
	
func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)

func _ready() -> void:
	Header.set('theme_override_styles/panel', header_stylebox_copy)		
	
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
	#HeaderTitle.text = str(header)
	
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
	EcoMoney.bonus_amount = money_income
	
func on_researcher_income_update() -> void:
	if !is_node_ready():return	
	EcoResearch.bonus_amount = researcher_income
	
func on_material_income_update() -> void:
	if !is_node_ready():return	
	EcoMaterial.bonus_amount = material_income
	
func on_core_income_update() -> void:
	if !is_node_ready():return	
	EcoCore.bonus_amount = core_income
# --------------------------------------------

# -----------------------------------------------
func on_process_update(delta: float, time_passed:float) -> void:
	if !is_node_ready():
		return

	# Oscillates between 0 and 1
	var t:float = (sin(time_passed * 5.0) + 1.0) / 2.0
	var count:int = money_val + research_val + material_val + core_val
	
	# Blend between black and red
	header_stylebox_copy.bg_color = COLORS.primary_black.lerp(COLORS.disabled_color, t) if count < 3 else COLORS.primary_black
# -----------------------------------------------
