@tool
extends PanelContainer

@onready var StressAmountLabel:Label = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/StressAmount
@onready var SanityAmountLabel:Label = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/SanityAmount
@onready var StressProgressBar:ProgressBar = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/StressProgressBar
@onready var SanityProgressBar:ProgressBar = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/SanityProgressBar

var sanity:int = 0 : 
	set(val): 
		sanity = val
		on_sanity_update()

var stress:int = 0 : 
	set(val):
		stress = val 
		on_stress_update()
		
func _ready() -> void:
	on_sanity_update()
	on_stress_update()

func on_sanity_update() -> void:
	if !is_node_ready():return
	SanityProgressBar.value = sanity
	SanityAmountLabel.text = "%s/10" % [sanity]
	
func on_stress_update() -> void:
	if !is_node_ready():return
	StressProgressBar.value = stress
	StressAmountLabel.text = "%s/10" % [stress]
