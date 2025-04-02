extends PanelContainer

@onready var NameLabel:Label = $MarginContainer/VBoxContainer/SynergyContainer/Description/NameLabel
@onready var DescriptionLabel:Label = $MarginContainer/VBoxContainer/SynergyContainer/Description/DescriptionLabel
@onready var ProfileImage:TextureRect = $MarginContainer/VBoxContainer/SynergyContainer/Metadata/SubViewport/ProfileImage
@onready var Effects:VBoxContainer = $MarginContainer/VBoxContainer/SynergyContainer/Effects
@onready var ResourceGrid:GridContainer = $MarginContainer/VBoxContainer/SynergyContainer/Effects/ResourceGrid
@onready var MetricsList:VBoxContainer = $MarginContainer/VBoxContainer/SynergyContainer/Effects/MetricList

@onready var Syncs:VBoxContainer = $MarginContainer/VBoxContainer/SynergyContainer/Syncs
@onready var SyncList:GridContainer = $MarginContainer/VBoxContainer/SynergyContainer/Syncs/SyncList

@onready var ActiveAbilites:VBoxContainer = $MarginContainer/VBoxContainer/SynergyContainer/ActiveAbilities
@onready var ActiveAbilitiesList:VBoxContainer = $MarginContainer/VBoxContainer/SynergyContainer/ActiveAbilities/ActiveAbilitiesList

@onready var PassiveAbilities:VBoxContainer = $MarginContainer/VBoxContainer/SynergyContainer/PassiveAbilities
@onready var PassiveAbilitiesList:VBoxContainer = $MarginContainer/VBoxContainer/SynergyContainer/PassiveAbilities/PassiveAbilitiesList

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
	
	for node in [MetricsList, ResourceGrid, SyncList, ActiveAbilitiesList, PassiveAbilitiesList]:
		for child in node.get_children():
			child.queue_free()
	
	for item in ROOM_UTIL.return_pairs_with_details(room_details.ref):
		var btn_node:Control = TextBtnPreload.instantiate()
		btn_node.is_hoverable = false
		btn_node.title = item.name
		btn_node.icon = item.icon
		btn_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		SyncList.add_child(btn_node)
	
	if "abilities" in room_details:
		var abilities:Array = room_details.abilities.call()
		for ability_index in abilities.size():
			var ability:Dictionary = abilities[ability_index]
			var btn_node:Control = TextBtnPreload.instantiate()
			btn_node.title = "Lvl-%s  %s" % [ability.lvl_required, ability.name]
			btn_node.icon = SVGS.TYPE.NONE
			ActiveAbilitiesList.add_child(btn_node)
			ActiveAbilites.show()
	else:
		ActiveAbilites.hide()
			
	if "passive_abilities" in room_details:
		var passive_abilities:Array = room_details.passive_abilities.call()
		for ability_index in passive_abilities.size():
			var ability:Dictionary = passive_abilities[ability_index]
			var btn_node:Control = TextBtnPreload.instantiate()
			btn_node.title = "Lvl-%s  %s" % [ability.lvl_required, ability.name]
			btn_node.icon = SVGS.TYPE.NONE
			PassiveAbilitiesList.add_child(btn_node)			
			PassiveAbilities.show()
	else:
		PassiveAbilities.hide()
	
	var is_activated:bool = true
	var operating_costs:Array = ROOM_UTIL.return_operating_cost(ref)	
	var resource_list:Array = operating_costs.filter(func(i):return i.type == "amount") if is_activated else []
	var metric_list:Array = operating_costs.filter(func(i):return i.type == "metrics") if is_activated else []
	
	ResourceGrid.columns = U.min_max(resource_list.size(), 1, 2)
	
	for item in resource_list:
		var new_btn:Control = TextBtnPreload.instantiate()
		new_btn.is_hoverable = false
		new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_btn.icon = item.resource.icon
		new_btn.title = "%s%s" % ["+" if item.amount > 0 else "", item.amount]
		ResourceGrid.add_child(new_btn)
		
	for item in metric_list:
		if item.type == "metrics":
			var new_btn:Control = TextBtnPreload.instantiate()
			new_btn.is_hoverable = false
			new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			new_btn.icon = item.resource.icon
			new_btn.title = "%s%s %s" % ["+" if item.amount > 0 else "", item.amount, item.resource.name]
			MetricsList.add_child(new_btn)		
			
	## TODO FIND MORE RELIABLE WAY TO GET THE NUMBERS HERE
	#var activation_effects:Array = [] #ROOM_UTIL.return_activation_effect(item.ref)		
	#Effects.hide() if is_locked or activation_effects.is_empty() else Effects.show()
	#for item in activation_effects:
		#var btn_node:Control = TextBtnPreload.instantiate()
		#btn_node.is_hoverable = false
		#btn_node.title = "%s%s [%s] [%s]" % ["+" if item.amount > 0 else "", item.amount, item.resource.name, str(item.type).to_upper()]
		#btn_node.icon = item.resource.icon
		#EffectsList.add_child(btn_node)
	#
	#var spec_preferences:Array = ROOM_UTIL.return_room_speclization_preferences(ref)
	#Syncs.hide() if is_locked or spec_preferences.is_empty() else Syncs.show()
	#for item in spec_preferences:
		#var btn_node:Control = TextBtnPreload.instantiate()
		#btn_node.is_hoverable = false		
		#btn_node.title = "%s" % [item.details.name]
		#btn_node.icon = item.details.icon
		#SyncList.add_child(btn_node)
