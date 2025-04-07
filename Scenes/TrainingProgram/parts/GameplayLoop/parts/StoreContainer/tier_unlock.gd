extends PanelContainer

@onready var BackBtn:BtnBase = $MarginContainer/PanelContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/BackBtn
@onready var ConfirmBtn:BtnBase = $MarginContainer/PanelContainer/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/ConfirmBtn
@onready var ResourceContainer:HBoxContainer = $MarginContainer/PanelContainer/MarginContainer/CenterContainer/VBoxContainer/MarginContainer/ResourceContainer
@onready var TitleBarLabel:Label = $MarginContainer/PanelContainer/MarginContainer/CenterContainer/VBoxContainer/TitleBarLabel

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var resource_data:Dictionary = {}

var disable_confirm:bool = false : 
	set(val):
		disable_confirm = val
		on_disable_confirm_update()

var onConfirm:Callable = func(data:Dictionary):pass

# ----------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_resources_data(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_resources_data(self)	

func _ready() -> void:
	on_data_update()
	
	BackBtn.onClick = func() -> void:
		data = {}
		
	ConfirmBtn.onClick = func() -> void:
		if !disable_confirm:
			onConfirm.call(data)
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary) -> void:
	resource_data = new_val
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
func on_data_update() -> void:
	hide() if data.is_empty() else show()
	if data.is_empty() or resource_data.is_empty():return
	var resource_list:Dictionary = data.get_unlock_cost.call()
	
	TitleBarLabel.text = "UNLOCK %s?" % [data.name]
	
	for child in ResourceContainer.get_children():
		child.queue_free()
	
	await U.tick()
	
	for key in resource_list:
		var amount:int = resource_list[key]
		var btn_node:BtnBase = TextBtnPreload.instantiate()
		var resource_details:Dictionary = RESOURCE_UTIL.return_currency(key)
		btn_node.title = str(amount)
		btn_node.icon = resource_details.icon
		btn_node.is_disabled = resource_data[key].amount < amount
		btn_node.is_hoverable = false
		
		ResourceContainer.add_child(btn_node)
	
	var is_disable:bool = false
	for btn in ResourceContainer.get_children():
		if !is_disable and btn.is_disabled:
			is_disable = true
	disable_confirm = is_disable
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
func on_disable_confirm_update() -> void:
	ConfirmBtn.is_disabled = disable_confirm
# ----------------------------------------------------------------------------
