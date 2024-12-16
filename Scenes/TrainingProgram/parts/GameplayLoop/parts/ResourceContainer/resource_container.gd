@tool
extends GameContainer

@onready var ResourceItemMoney:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ResourceItemMoney
@onready var ResourceItemEnergy:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ResourceItemEnergy
@onready var ResourceItemLeadResearchers:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ResourceItemLeadResearchers

@onready var ResourceItemStaff:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer2/ResourceItemStaff
@onready var ResourceItemSecurity:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer2/ResourceItemSecurity
@onready var ResourceItemDClass:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer2/ResourceItemDClass

var resources_data:Dictionary = {} : 
	set(val):
		resources_data = val
		on_resources_data_update()

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	on_resources_data_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_resources_data_update() -> void:
	if is_node_ready() and !resources_data.is_empty():
		for key in resources_data:
			var data:Dictionary = resources_data[key]
			match key:
				RESOURCE.TYPE.MONEY:
					ResourceItemMoney.title = "%s" % [data.amount]
				RESOURCE.TYPE.ENERGY:
					ResourceItemEnergy.title = "%s" % [data.amount]
				RESOURCE.TYPE.LEAD_RESEARCHERS:
					ResourceItemLeadResearchers.title = "%s" % [data.amount]
				RESOURCE.TYPE.STAFF:
					ResourceItemStaff.title = "%s/%s" % [data.amount, data.capacity]
				RESOURCE.TYPE.SECURITY:
					ResourceItemSecurity.title = "%s/%s" % [data.amount, data.capacity]
				RESOURCE.TYPE.DCLASS:
					ResourceItemDClass.title = "%s/%s" % [data.amount, data.capacity]
# --------------------------------------------------------------------------------------------------
