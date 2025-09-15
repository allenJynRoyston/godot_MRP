extends PanelContainer

@onready var TextureRectImg:TextureRect = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect
@onready var NameLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/MarginContainer3/VBoxContainer/NamePanel/MarginContainer/HBoxContainer/NameLabel
@onready var NicknameLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/MarginContainer3/VBoxContainer/NamePanel/MarginContainer/HBoxContainer/NicknameLabel

@onready var DescriptionContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/DescriptionContainer
@onready var DescriptionLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/DescriptionContainer/PanelContainer2/MarginContainer/VBoxContainer/DescriptionLabel
@onready var QuoteLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/DescriptionContainer/PanelContainer2/MarginContainer/VBoxContainer/QuoteLabel

@onready var EffectContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/EffectContainer
@onready var EffectLabel:RichTextLabel = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/EffectContainer/PanelContainer2/MarginContainer/EffectLabel

@onready var InfluenceContainer:Control = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/Influence
@onready var InfluenceLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/Influence/PanelContainer2/MarginContainer/InfluenceLabel

@export var ref:int = -1: 
	set(val):
		ref = val
		on_ref_update()

var index:int = -1

var use_location:Dictionary : 
	set(val):
		use_location = val
		on_use_location_update()
		
# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_scp_data(self)	
	
func _ready() -> void:
	modulate.a = 0
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
		modulate.a = 0
		return	
	modulate.a = 1
	
	var scp_details:Dictionary = SCP_UTIL.return_data(ref)
	
	NameLabel.text = scp_details.name
	NicknameLabel.text = scp_details.nickname
	TextureRectImg.texture = CACHE.fetch_image(scp_details.img_src) 
	
	DescriptionLabel.text = scp_details.description.call(scp_details)
	QuoteLabel.text = scp_details.quote.call(scp_details)
	
	EffectLabel.text = "[color=ORANGE][b]EFFECT:[/b][/color] %s" % [scp_details.effect.description if scp_details.effect.has("description") else "None"]
	EffectContainer.show() if scp_details.effect.has("description") else EffectContainer.hide()
# ------------------------------------------------------------------------------
