extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var AniPlayer:AnimationPlayer = $AnimationPlayer
@onready var Portrait:TextureRect = $VBoxContainer/PanelContainer/HBoxContainer/PanelContainer/Portrait
@onready var TitleLabel:Label = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/TitleLabel
@onready var SpecLabel:Label = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/SpecLabel
@onready var ResourceGrid:GridContainer = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/ResourceGrid
@onready var MetricsList:VBoxContainer = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/MetricList
@onready var NoBonusLabel:Label = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/NoBonusLabel
@onready var SelectedIcon:BtnBase = $Control/IconBtn
const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var uid:String = "" : 
	set(val):
		uid = val
		on_uid_update()

var researcher:Dictionary = {} : 
	set(val):
		researcher = val
		on_researcher_update()
		
var room_extract:Dictionary = {} : 
	set(val):
		room_extract = val
		on_room_extract_update()
		
var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
func _ready() -> void:
	on_uid_update()
	on_researcher_update()
	on_room_extract_update()
	on_is_selected_update()
	
func on_uid_update() -> void:
	if !is_node_ready() or uid.is_empty():return
	researcher = RESEARCHER_UTIL.return_data_with_uid(uid)

func on_researcher_update() -> void:
	if !is_node_ready():return
	if researcher.is_empty():
		hide()
		return
	
	show()
	TitleLabel.text = researcher.name
	Portrait.texture = CACHE.fetch_image("res://Media/images/redacted.png" if researcher.is_empty() else researcher.img_src)
	SpecLabel.text = "" if researcher.is_empty() else RESEARCHER_UTIL.return_specialization_data(researcher.specializations[0]).name

func on_is_selected_update() -> void:
	if !is_node_ready():return
	SelectedIcon.show() if is_selected else SelectedIcon.hide()
	
	if is_selected:
		AniPlayer.active = true
		AniPlayer.play("SELECTED")
	else:
		AniPlayer.stop()
		
		

func on_room_extract_update() -> void:
	if !is_node_ready() or room_extract.is_empty() or researcher.is_empty():return
	
	for node in [ResourceGrid, MetricsList]:	
		for child in node.get_children():
			child.queue_free()
			
	if !room_extract.is_room_empty:
		var spec_bonus:Array = ROOM_UTIL.return_specilization_bonus(room_extract.room.details.ref, researcher.specializations)

		var resource_list:Array = spec_bonus.filter(func(i):return i.type == "amount")
		var metric_list:Array = spec_bonus.filter(func(i):return i.type == "metrics")
		var ap_list:Array = spec_bonus.filter(func(i):return i.type == "ap")

		ResourceGrid.columns = U.min_max(resource_list.size(), 1, 2)
		
		for item in resource_list:
			var new_btn:Control = TextBtnPreload.instantiate()
			new_btn.is_hoverable = false
			new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			new_btn.icon = item.resource.icon
			new_btn.title = "%s%s" % ["+" if item.amount > 0 else "", item.amount]
			ResourceGrid.add_child(new_btn)
			
		for item in metric_list:
			var new_btn:Control = TextBtnPreload.instantiate()
			new_btn.is_hoverable = false
			new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			new_btn.icon = item.resource.icon
			new_btn.title = "%s%s %s" % ["+" if item.amount > 0 else "", item.amount, item.resource.name]
			MetricsList.add_child(new_btn)
		
		for item in ap_list:
			var new_btn:Control = TextBtnPreload.instantiate()
			new_btn.is_hoverable = false
			new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			new_btn.title = "%s%s AP" % ["+" if item.amount > 0 else "", item.amount]
			MetricsList.add_child(new_btn)			
		
		ResourceGrid.hide() if ResourceGrid.get_child_count() == 0 else ResourceGrid.show()
		MetricsList.hide() if MetricsList.get_child_count() == 0 else MetricsList.show()
		NoBonusLabel.show() if resource_list.is_empty() and metric_list.is_empty() and ap_list.is_empty() else NoBonusLabel.hide()
