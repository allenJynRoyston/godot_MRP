extends PanelContainer

#@onready var Portrait:TextureRect = $HBoxContainer/Portrait
#@onready var TitleLabel:Label = $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/TitleLabel
#@onready var ResourceGrid:GridContainer = $HBoxContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/ResourceGrid
#@onready var MetricsList:VBoxContainer = $HBoxContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/MetricList
#@onready var NoBonusLabel:Label = $HBoxContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/NoBonusLabel
@onready var CardDrawerContainmentInfo:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerContainmentInfo

var ref:int = -1 : 
	set(val):
		ref = val
		on_ref_update()

#var details:Dictionary = {} : 
	#set(val):
		#details = val
		#on_details_update()
		
func _ready() -> void:
	on_ref_update()
	
func on_ref_update() -> void:
	if !is_node_ready() or ref == -1:return
	var scp_details:Dictionary = SCP_UTIL.return_data(ref)
	
	CardDrawerContainmentInfo.effects = scp_details.effects
	CardDrawerContainmentInfo.title = scp_details.name
	
	#var operating_costs:Array = SCP_UTIL.return_ongoing_containment_rewards(ref)	
	#for node in [ResourceGrid, MetricsList]:	
		#for child in node.get_children():
			#child.queue_free()
#
	#ResourceGrid.columns = U.min_max(operating_costs.size(), 1, 2)
	#
	#for item in operating_costs:
		#var new_btn:Control = TextBtnPreload.instantiate()
		#new_btn.is_hoverable = false
		#new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#new_btn.icon = item.resource.icon
		#new_btn.title = "%s%s" % ["+" if item.amount > 0 else "", item.amount]
		#ResourceGrid.add_child(new_btn)
		#
#
	#ResourceGrid.hide() if operating_costs.is_empty() else ResourceGrid.show()
	#NoBonusLabel.show() if operating_costs.is_empty() else NoBonusLabel.hide()

#func on_details_update() -> void:
	#if !is_node_ready():return
	#TitleLabel.text = details.name if !details.is_empty() else "EMPTY"
	#Portrait.texture = CACHE.fetch_image("res://Media/images/redacted.png" if details.is_empty() else details.img_src)
