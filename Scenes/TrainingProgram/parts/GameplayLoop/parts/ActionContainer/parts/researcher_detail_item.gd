extends PanelContainer

@onready var Portrait:TextureRect = $HBoxContainer/Portrait
@onready var TitleLabel:Label = $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/TitleLabel
@onready var Description:Label = $HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/DescriptionLabel
@onready var DetailList:VBoxContainer = $HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/DetailList

const ResearcherDetailLineItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionContainer/parts/ResearcherDetailLineItem.tscn")
const BlankPortrait:CompressedTexture2D = preload("res://Media/images/redacted.png")

var researcher:Dictionary = {} : 
	set(val):
		researcher = val
		on_researcher_update()
		
func _ready() -> void:
	for child in DetailList.get_children():
		child.queue_free()
		
	on_researcher_update()

func on_researcher_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = researcher.name if !researcher.is_empty() else "RESEARCHER SLOT AVAILABLE"
	Portrait.texture = CACHE.fetch_image(researcher.img_src) if !researcher.is_empty() else BlankPortrait
	
	if researcher.is_empty():return	
	for trait_id in researcher.traits:
		var new_line_item:Control = ResearcherDetailLineItemPreload.instantiate()
		new_line_item.details = RESEARCHER_UTIL.return_trait_data(trait_id)
		DetailList.add_child(new_line_item)
