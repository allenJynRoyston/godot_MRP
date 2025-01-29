extends HBoxContainer

@onready var TextBtn:BtnBase = $TextBtn
@onready var MoneyLabel:Label = $HBoxContainer/PanelContainer/HBoxContainer/MoneyLabel
@onready var EnergyLabel:Label = $HBoxContainer/PanelContainer2/HBoxContainer/EnergyLabel

var btn_title:String = "" : 
	set(val):
		btn_title = val
		on_btn_title_update()

var money_amount:int : 
	set(val):
		money_amount = val
		on_money_amount_update()
		
var energy_amount:int :
	set(val):
		energy_amount = val
		on_energy_amount_update()

var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

var index:int 
		
var onClick:Callable = func(_index:int) -> void:pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_btn_title_update()
	on_money_amount_update()
	on_energy_amount_update()
	on_is_selected_update()
	
	TextBtn.onClick = func() -> void:
		onClick.call(index)

func on_btn_title_update() -> void:
	if !is_node_ready():return
	TextBtn.title = btn_title
	
func on_money_amount_update() -> void:
	if !is_node_ready():return
	MoneyLabel.text = str(money_amount)

func on_energy_amount_update() -> void:
	if !is_node_ready():return
	EnergyLabel.text = str(energy_amount)
	
func on_is_selected_update() -> void:
	if !is_node_ready():return
