extends PanelContainer

@onready var Portrait:TextureRect = $HBoxContainer/Portrait
@onready var TitleLabel:Label = $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/TitleLabel
@onready var OutputList:VBoxContainer = $HBoxContainer/VBoxContainer/MarginContainer/OutputList

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
	for child in OutputList.get_children():
		child.queue_free()
	for item in operating_costs:
		var new_btn:Control = TextBtnPreload.instantiate()
		new_btn.is_hoverable = false
		new_btn.icon = item.resource.icon
		new_btn.title = "%s%s" % ["+" if item.amount > 0 else "", item.amount]
		OutputList.add_child(new_btn)		

func on_details_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = details.name if !details.is_empty() else "EMPTY"
	Portrait.texture = CACHE.fetch_image("res://Media/images/redacted.png" if details.is_empty() else details.img_src)
