extends PanelContainer

@onready var FocusContainer:Control = $FocusContainer
@onready var DetailImage:TextureRect = $FocusContainer/HighlightContainer/Details/DetailImage
@onready var Title:Label = $FocusContainer/HighlightContainer/Details/Title
@onready var Description:Label = $FocusContainer/HighlightContainer/Details/Description
@onready var ConstructionTime:Label = $FocusContainer/HighlightContainer/ConstructionCosts/ConstructionTime
@onready var EffectList:VBoxContainer = $FocusContainer/HighlightContainer/Effects/EffectList
@onready var OperatingCostsList:VBoxContainer = $FocusContainer/HighlightContainer/OperatingCosts/OperatingCostsList
@onready var ConstructionCostList:VBoxContainer = $FocusContainer/HighlightContainer/ConstructionCosts/ConstructionCostsList
@onready var ConstructionLabel:Label = $FocusContainer/HighlightContainer/ConstructionCosts/HBoxContainer/ConstructionLabel

@onready var Effects:VBoxContainer = $FocusContainer/HighlightContainer/Effects
@onready var OperatingCosts:VBoxContainer = $FocusContainer/HighlightContainer/OperatingCosts
@onready var ConstructionCosts:VBoxContainer = $FocusContainer/HighlightContainer/ConstructionCosts

const small_label_preload:LabelSettings = preload("res://Fonts/settings/small_label.tres")
const TextButtonPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		
var tab:TIER.TYPE  = TIER.TYPE.FACILITY

func _ready() -> void:
	on_data_update()

func hide_details() -> void:
	if !is_node_ready(): return
	FocusContainer.hide() if data.is_empty() else FocusContainer.show()
	if data.is_empty():
		for node in [EffectList, ConstructionCostList, OperatingCostsList]:
			for child in node.get_children():
				child.queue_free()

func on_data_update() -> void:
	hide_details()
	if !is_node_ready() or data.is_empty():return
	
	match tab:
		TIER.TYPE.BASE_DEVELOPMENT:
			Title.text = data.details.name
			Description.text = data.details.description
			DetailImage.texture = CACHE.fetch_image(data.details.img_src if "img_src" in data.details else "")		
			ConstructionLabel.text = "Development costs"
			ConstructionTime.text = "Days required: %s" % [str(data.details.get_build_time.call())]
			
			var purchase_cost_list:Array = BASE_UTIL.return_purchase_cost(data.ref)
			for item in purchase_cost_list:
				var new_node:BtnBase = TextButtonPreload.instantiate()		
				new_node.icon = item.resource.icon
				new_node.title = "%s%s [%s]" % ["" if item.amount < 0 else "+", item.amount, item.type]
				ConstructionCostList.add_child(new_node)			
			
			Effects.show()
			OperatingCosts.hide()
			ConstructionCosts.show()
			
		TIER.TYPE.RESEARCH_AND_DEVELOPMENT:
			Title.text = data.details.name
			Description.text = data.details.description
			DetailImage.texture = CACHE.fetch_image(data.details.img_src if "img_src" in data.details else "")		
			ConstructionLabel.text = "Research costs"
			ConstructionTime.text = "Days required: %s" % [str(data.details.get_build_time.call())]
			
			var purchase_cost_list:Array = RD_UTIL.return_purchase_cost(data.ref)
			for item in purchase_cost_list:
				var new_node:BtnBase = TextButtonPreload.instantiate()		
				new_node.icon = item.resource.icon
				new_node.title = "%s%s [%s]" % ["" if item.amount < 0 else "+", item.amount, item.type]
				ConstructionCostList.add_child(new_node)
				
			Effects.hide()
			OperatingCosts.hide()
			ConstructionCosts.show()	
			
		TIER.TYPE.FACILITY:
			Title.text = data.details.name
			Description.text = data.details.description
			DetailImage.texture = CACHE.fetch_image(data.details.img_src if "img_src" in data.details else "")		
			ConstructionLabel.text = "Construction costs"
			ConstructionTime.text = "Days required: %s" % [str(data.details.get_build_time.call())]
			
			var operating_cost_list:Array = ROOM_UTIL.return_operating_cost(data.ref)
			var purchase_cost_list:Array = ROOM_UTIL.return_purchase_cost(data.ref)
			#var build_complete_list:Array = ROOM_UTIL.return_build_complete(data.ref)
#
			#for item in build_complete_list:
				#var new_node:BtnBase = TextButtonPreload.instantiate()		
				#new_node.icon = item.resource.icon
				#new_node.title = "+%s [%s]" % [item.amount, item.type]
				#EffectList.add_child(new_node)
				
			for item in operating_cost_list:
				var new_node:BtnBase = TextButtonPreload.instantiate()		
				new_node.icon = item.resource.icon
				new_node.title = "%s%s [%s] (per week)" % ["" if item.amount < 0 else "+", item.amount, item.type]
				OperatingCostsList.add_child(new_node)	
				
			for item in purchase_cost_list:
				var new_node:BtnBase = TextButtonPreload.instantiate()		
				new_node.icon = item.resource.icon
				new_node.title = "%s%s [%s]" % ["" if item.amount < 0 else "+", item.amount, item.type]
				ConstructionCostList.add_child(new_node)
				
			Effects.show()
			OperatingCosts.show()
			ConstructionCosts.show()
