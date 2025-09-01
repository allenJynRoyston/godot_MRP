extends PanelContainer

@onready var TextureRectImg:TextureRect = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect
@onready var NameTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/NamePanel/MarginContainer/HBoxContainer/NameTag

@onready var DescriptionContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/DescriptionContainer
@onready var DescriptionLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/DescriptionContainer/PanelContainer2/MarginContainer/DescriptionLabel

@onready var TypeContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/TypeContainer
@onready var TypeLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/TypeContainer/PanelContainer2/MarginContainer/TypeLabel

@onready var EffectContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/EffectContainer
@onready var EffectLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/EffectContainer/PanelContainer2/MarginContainer/EffectLabel

@onready var InfluenceContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/Influence
@onready var InfluenceLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/Influence/PanelContainer2/MarginContainer/InfluenceLabel


@export var ref:int = -1: 
	set(val):
		ref = val
		on_ref_update()

var use_location:Dictionary : 
	set(val):
		use_location = val
		on_use_location_update()
		
var index:int = -1

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_scp_data(self)	
	
func _ready() -> void:
	on_ref_update()
	on_use_location_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_ref_update() -> void:
	U.debounce(str(self, "_update_card"), update_card)

func on_use_location_update() -> void:
	U.debounce(str(self, "_update_card"), update_card)

func update_card() -> void:
	if !is_node_ready() or use_location.is_empty() or ref == -1:
		hide()
		return
	
	show()
	var scp_details:Dictionary = SCP_UTIL.return_data(ref)
	NameTag.text = "%s\n(%s)" % [scp_details.name, scp_details.nickname]
	TextureRectImg.texture = CACHE.fetch_image(scp_details.img_src) 
	
	DescriptionLabel.text = scp_details.abstract.call(scp_details)
	
	TypeLabel.text = SCP_UTIL.get_containment_type_str(scp_details.containment_requirements)
	TypeContainer.show() if !scp_details.containment_requirements.is_empty() else TypeContainer.hide()
	
	EffectLabel.text = scp_details.effect.description if scp_details.effect.has("description") else ""
	EffectContainer.show() if scp_details.effect.has("description") else EffectContainer.hide()

	InfluenceContainer.show() if !scp_details.influence.is_empty() else InfluenceContainer.hide()
	InfluenceLabel.text = scp_details.influence.effect.description if !scp_details.influence.is_empty() else ""
# ------------------------------------------------------------------------------
