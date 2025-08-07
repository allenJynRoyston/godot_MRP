extends PanelContainer

@onready var TextureRectImg:TextureRect = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect
@onready var NameTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/NamePanel/MarginContainer/HBoxContainer/NameTag
@onready var BreachLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/HBoxContainer/BreachOddsContainer/MarginContainer/HBoxContainer/BreachLabel

@onready var DescriptionContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/DescriptionContainer
@onready var DescriptionPanel:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/DescriptionContainer/PanelContainer2/MarginContainer/DescriptionPanel

@onready var EffectContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/EffectContainer
@onready var EffectPanel:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/EffectContainer/PanelContainer2/MarginContainer/EffectPanel

@onready var TypeContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/TypeContainer
@onready var TypePanel:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/TypeContainer/PanelContainer2/MarginContainer/TypePanel

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
	BreachLabel.text = str( "BREACH CHANCE ", SCP_UTIL.get_breach_event_chance(ref, use_location), "%" )
	
	DescriptionPanel.content = scp_details.abstract.call(scp_details)
	EffectPanel.content = scp_details.effect.description if scp_details.effect.has("description") else ""
	EffectContainer.show() if scp_details.effect.has("description") else EffectContainer.hide()
	
	TypePanel.content = SCP_UTIL.get_containment_type_str(scp_details.containment_requirements)
	TypeContainer.show() if !scp_details.containment_requirements.is_empty() else TypeContainer.hide()
	
	
# ------------------------------------------------------------------------------
