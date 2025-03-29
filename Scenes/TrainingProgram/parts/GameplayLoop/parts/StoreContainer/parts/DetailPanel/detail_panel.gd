extends PanelContainer

@onready var NameLabel:Label = $MarginContainer/VBoxContainer/SynergyContainer/Description/NameLabel
@onready var DescriptionLabel:Label = $MarginContainer/VBoxContainer/SynergyContainer/Description/DescriptionLabel
@onready var ProfileImage:TextureRect = $MarginContainer/VBoxContainer/SynergyContainer/Metadata/SubViewport/ProfileImage
@onready var Effects:VBoxContainer = $MarginContainer/VBoxContainer/SynergyContainer/Effects
@onready var EffectsList:VBoxContainer = $MarginContainer/VBoxContainer/SynergyContainer/Effects/EffectList
@onready var Syncs:VBoxContainer = $MarginContainer/VBoxContainer/SynergyContainer/Syncs
@onready var SyncList:GridContainer = $MarginContainer/VBoxContainer/SynergyContainer/Syncs/SyncList

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var ref:int = -1:
	set(val):
		ref = val
		on_ref_update()

var shop_unlock_purchases:Array = []


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	SUBSCRIBE.subscribe_to_shop_unlock_purchases(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_shop_unlock_purchases(self)

func on_shop_unlock_purchases_update(new_val:Array) -> void:
	shop_unlock_purchases = new_val

func on_ref_update() -> void:
	if !is_node_ready():return
	
	if ref == -1:
		hide()
		return
	show()
	
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)
	var is_locked:bool = false
	var own_aquistions:bool = ROOM_UTIL.owns_and_is_active(ROOM.TYPE.AQUISITION_DEPARTMENT)
	
	if room_details.requires_unlock:		
		if room_details.ref not in shop_unlock_purchases:	
			is_locked = !own_aquistions # if you own aquisitions, you can view them anyways	
	
	NameLabel.text = "%s" % [room_details.name if !is_locked else "[REDACTED]"]
	DescriptionLabel.text = room_details.description if !is_locked else "(Viewable with AQUISITION DEPARTMENT.)"
	ProfileImage.texture = CACHE.fetch_image(room_details.img_src if !is_locked else "")
	
	for node in [EffectsList, SyncList]:
		for child in node.get_children():
			child.queue_free()

	# TODO FIND MORE RELIABLE WAY TO GET THE NUMBERS HERE
	var activation_effects:Array = [] #ROOM_UTIL.return_activation_effect(item.ref)		
	Effects.hide() if is_locked or activation_effects.is_empty() else Effects.show()
	for item in activation_effects:
		var btn_node:Control = TextBtnPreload.instantiate()
		btn_node.is_hoverable = false
		btn_node.title = "%s%s [%s] [%s]" % ["+" if item.amount > 0 else "", item.amount, item.resource.name, str(item.type).to_upper()]
		btn_node.icon = item.resource.icon
		EffectsList.add_child(btn_node)
	
	var spec_preferences:Array = ROOM_UTIL.return_room_speclization_preferences(ref)
	Syncs.hide() if is_locked or spec_preferences.is_empty() else Syncs.show()
	for item in spec_preferences:
		var btn_node:Control = TextBtnPreload.instantiate()
		btn_node.is_hoverable = false		
		btn_node.title = "%s" % [item.details.name]
		btn_node.icon = item.details.icon
		SyncList.add_child(btn_node)
