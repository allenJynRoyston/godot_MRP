extends PanelContainer

@onready var Portrait:TextureRect = $HBoxContainer/Portrait
@onready var TitleLabel:Label = $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/TitleLabel
@onready var ResourceGrid:GridContainer = $HBoxContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/ResourceGrid
@onready var MetricsList:VBoxContainer = $HBoxContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/MetricList
@onready var NoBonusLabel:Label = $HBoxContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/NoBonusLabel

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var ref:int = -1 : 
	set(val):
		ref = val
		on_ref_update()

var details:Dictionary = {} : 
	set(val):
		details = val
		on_details_update()
		
func _ready() -> void:
	on_ref_update()
	
func on_ref_update() -> void:
	if !is_node_ready() or ref == -1:return
	details = SCP_UTIL.return_data(ref)
	
	var operating_costs:Array = SCP_UTIL.return_ongoing_containment_rewards(ref)	
	for node in [ResourceGrid, MetricsList]:	
		for child in node.get_children():
			child.queue_free()
	
	var resource_list:Array = operating_costs.filter(func(i):return i.type == "amount")
	var metric_list:Array = operating_costs.filter(func(i):return i.type == "metrics")
	
	ResourceGrid.columns = U.min_max(resource_list.size(), 1, 2)
	
	for item in resource_list:
		var new_btn:Control = TextBtnPreload.instantiate()
		new_btn.is_hoverable = false
		new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_btn.icon = item.resource.icon
		new_btn.title = "%s%s" % ["+" if item.amount > 0 else "", item.amount]
		ResourceGrid.add_child(new_btn)
		
	for item in metric_list:
		if item.type == "metrics":
			var new_btn:Control = TextBtnPreload.instantiate()
			new_btn.is_hoverable = false
			new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			new_btn.icon = item.resource.icon
			new_btn.title = "%s%s %s" % ["+" if item.amount > 0 else "", item.amount, item.resource.name]
			MetricsList.add_child(new_btn)
			
	ResourceGrid.hide() if resource_list.is_empty() else ResourceGrid.show()
	MetricsList.hide() if metric_list.is_empty() else MetricsList.show()
	NoBonusLabel.show() if resource_list.is_empty() and metric_list.is_empty() else NoBonusLabel.hide()

func on_details_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = details.name if !details.is_empty() else "EMPTY"
	Portrait.texture = CACHE.fetch_image("res://Media/images/redacted.png" if details.is_empty() else details.img_src)
