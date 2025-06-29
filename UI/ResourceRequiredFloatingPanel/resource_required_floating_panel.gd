extends Control

@onready var MainPanel:PanelContainer = $PanelContainer
@onready var Icon1:BtnBase = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/IconBtn
@onready var Label1:Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Label1
@onready var Label2:Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Label2
@export var currency:RESOURCE.CURRENCY = RESOURCE.CURRENCY.MONEY

var resources_data:Dictionary = {}

func _init() -> void:
	SUBSCRIBE.subscribe_to_resources_data(self)
	self.modulate = Color(1, 1, 1, 0)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_resources_data(self)

func fade_out() -> void:
	await U.tween_node_property(self, 'modulate:a', 0)

func update(data:Dictionary) -> void:
	if data.is_empty():return
	match data.currency:
		RESOURCE.CURRENCY.MONEY:
			Icon1.icon = SVGS.TYPE.MONEY
		RESOURCE.CURRENCY.SCIENCE:
			Icon1.icon = SVGS.TYPE.RESEARCH		
		RESOURCE.CURRENCY.MATERIAL:
			Icon1.icon = SVGS.TYPE.RING
		RESOURCE.CURRENCY.CORE:
			Icon1.icon = SVGS.TYPE.GLOBAL
			
	var amount:int = resources_data[data.currency].amount
	Label1.text = str(amount)
	Label2.text = str(U.min_max(amount - data.amount, 0, resources_data[data.currency].capacity))
	Icon1.static_color = Color.RED if data.amount > amount else Color.WHITE
	modulate = Color(1, 1, 1, 1)

	

func goto(pos:Vector2 = self.position) -> void:
	self.position = pos - Vector2(-20, MainPanel.size.y/ 2)

func reveal(state:bool) -> void:
	modulate = Color(1, 1, 1, 1 if state else 0)

func on_resources_data_update(new_val:Dictionary) -> void:
	resources_data = new_val
