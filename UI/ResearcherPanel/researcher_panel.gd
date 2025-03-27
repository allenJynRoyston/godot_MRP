extends SubscribeWrapper

@onready var FreeLabeL:Label = $MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/VBoxContainer/FreeLabel
@onready var TotalLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/VBoxContainer/HBoxContainer/TotalLabel

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	super.on_hired_lead_researchers_arr_update(new_val)
	if !is_node_ready():return
	var unassigned_count:int = new_val.map(func(x):return x[9]).filter(func(x): return x.assigned_to_room.is_empty()).size()
	TotalLabel.text = "x%s" % [new_val.size()]
	FreeLabeL.text = "AVAIL (%s)" % [unassigned_count]
