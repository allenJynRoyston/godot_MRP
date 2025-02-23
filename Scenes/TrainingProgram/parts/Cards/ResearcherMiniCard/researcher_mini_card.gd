extends PanelContainer

@onready var Portrait:TextureRect = $HBoxContainer/Portrait
@onready var TitleLabel:Label = $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/TitleLabel
@onready var SpecLabel:Label = $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/SpecLabel
@onready var OutputList:VBoxContainer = $HBoxContainer/VBoxContainer/MarginContainer/OutputList

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
		
func _ready() -> void:
	on_uid_update()
	on_researcher_update()
	on_room_extract_update()
	
func on_uid_update() -> void:
	if !is_node_ready() or uid.is_empty():return
	researcher = RESEARCHER_UTIL.return_data_with_uid(uid)

func on_researcher_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = researcher.name if !researcher.is_empty() else "RESEARCHER SLOT AVAILABLE"
	Portrait.texture = CACHE.fetch_image("res://Media/images/redacted.png" if researcher.is_empty() else researcher.img_src)
	SpecLabel.text = "" if researcher.is_empty() else RESEARCHER_UTIL.return_specialization_data(researcher.specializations[0]).name

func on_room_extract_update() -> void:
	if !is_node_ready() or room_extract.is_empty() or researcher.is_empty():return
	for child in OutputList.get_children():
		child.queue_free()	
	if !room_extract.is_room_empty:
		var spec_bonus:Array = ROOM_UTIL.return_specilization_bonus(room_extract.room.details.ref, researcher.specializations)
		for item in spec_bonus:
			var new_btn:Control = TextBtnPreload.instantiate()
			new_btn.is_hoverable = false
			new_btn.icon = item.resource.icon
			new_btn.title = "%s%s" % ["+" if item.amount > 0 else "", item.amount]
			OutputList.add_child(new_btn)
