extends PanelContainer

@onready var Portrait:TextureRect = $HBoxContainer/Portrait
@onready var TitleLabel:Label = $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/TitleLabel
@onready var SpecLabel:Label = $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/SpecLabel
@onready var Description:Label = $HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/DescriptionLabel
@onready var DetailList:VBoxContainer = $HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/DetailList

const LineItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ResearcherMiniCard/parts/LineItem.tscn")
const BlankPortrait:CompressedTexture2D = preload("res://Media/images/redacted.png")

var uid:String = "" : 
	set(val):
		uid = val
		on_uid_update()

var researcher:Dictionary = {} : 
	set(val):
		researcher = val
		on_researcher_update()
		
func _ready() -> void:
	on_uid_update()
	on_researcher_update()
	
func on_uid_update() -> void:
	if !is_node_ready() or uid.is_empty():return
	researcher = RESEARCHER_UTIL.return_data_with_uid(uid)

func on_researcher_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = researcher.name if !researcher.is_empty() else "RESEARCHER SLOT AVAILABLE"
	Portrait.texture = CACHE.fetch_image(researcher.img_src) if !researcher.is_empty() else BlankPortrait
	SpecLabel.text = "" if researcher.is_empty() else RESEARCHER_UTIL.return_specialization_data(researcher.specializations[0]).name
	
	for child in DetailList.get_children():
		child.queue_free()
	
	if researcher.is_empty():return	
	
	
	
	for trait_id in researcher.traits:
		var new_line_item:Control = LineItemPreload.instantiate()
		new_line_item.details = RESEARCHER_UTIL.return_trait_data(trait_id)
		DetailList.add_child(new_line_item)
