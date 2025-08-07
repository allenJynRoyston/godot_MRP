extends PanelContainer

@onready var ColorBG:ColorRect = $ColorRect
@onready var BtnControls:Control = $BtnControls
#@onready var StartBtn:Control = $Control/PanelContainer/MarginContainer/VBoxContainer/BtnList/StartBtn


@onready var OptionPanel:PanelContainer = $Control/PanelContainer
@onready var OptionSeperator:HSeparator = $Control/PanelContainer/MarginContainer/VBoxContainer/HSeparator
@onready var OptionListContainer:MarginContainer = $Control/PanelContainer/MarginContainer/VBoxContainer/MarginContainer
@onready var OptionList:VBoxContainer = $Control/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/OptionList
@onready var BtnList:VBoxContainer = $Control/PanelContainer/MarginContainer/VBoxContainer/BtnList


const ItemBtnPreload:PackedScene = preload("res://UI/Buttons/ItemBtn/ItemBtn.tscn")

var properties:Dictionary = {}
var itemlist:Array = []
var SelectedNode:Control 

signal wait_for_response

# ----------------------------------------------
func _ready() -> void:
	clear()
	hide()
	
	ColorBG.color = Color(0, 0, 0, 0)
	OptionPanel.modulate = Color(1, 1, 1, 0)
	
	BtnControls.reveal(false)
	
	BtnControls.onUpdate = func(node:Control) -> void:
		for n in itemlist:
			n.is_selected = n == node
			if n == node:
				SelectedNode = node
	
	BtnControls.onBack = func() -> void:
		end(true)
# ----------------------------------------------	

# ----------------------------------------------	
func end(on_back:bool = false) -> void:
	for n in itemlist:
		n.is_selected = false

	U.tween_node_property(ColorBG, 'color:a', 0)
	U.tween_node_property(OptionPanel, 'position:y', OptionPanel.position.y + 10, 0.3, 0, Tween.TRANS_SINE, Tween.EASE_IN)
	U.tween_node_property(OptionPanel, 'modulate:a', 0, 0.3)
	await BtnControls.reveal(false)

	hide()
	clear()
	wait_for_response.emit({"on_back": on_back})
# ----------------------------------------------	

# ----------------------------------------------	
func clear() -> void:
	# clear
	for arr in [BtnList, OptionList]:
		for child in arr.get_children():
			child.queue_free()	
# ----------------------------------------------	

# ----------------------------------------------
func setup(btn_list:Array, option_list:Array, new_position:Vector2 = Vector2()) -> void:
	show()
		
	# reset
	itemlist = []
	properties = {}
	clear()
	
	#StartBtn.title = title
	OptionPanel.position = new_position - Vector2(0, -10)
	
	OptionSeperator.hide() if option_list.is_empty() else OptionSeperator.show()
	OptionListContainer.hide() if option_list.is_empty() else OptionListContainer.show()
	BtnList.hide() if btn_list.is_empty() else BtnList.show()
	
	for item in btn_list:
		var new_node:Control = ItemBtnPreload.instantiate()
		itemlist.push_back(new_node)
		
		new_node.title = item.title
		new_node.display_checkmark = false
		new_node.onClick = func() -> void:
			await end(false)
			item.onClick.call(properties)		
			
		BtnList.add_child(new_node)	
	
	# options_list
	for item in option_list:
		var new_node:Control = ItemBtnPreload.instantiate()
		properties[item.key] = item.value
		itemlist.push_back(new_node)
		
		new_node.hint_description = item.hint_description if "hint_description" in item else null
		new_node.display_checkmark = true
		new_node.title = item.title
		new_node.is_checked = item.value
		new_node.onClick = func() -> void:
			new_node.is_checked = !new_node.is_checked
			properties[item.key] = new_node.is_checked
		OptionList.add_child(new_node)

	
	# add to btnlist
	BtnControls.itemlist = itemlist
	BtnControls.directional_pref = "UD"
	BtnControls.item_index = 0

	await U.tick()
		
	#resizeb
	OptionPanel.size.y = 1

	# fade in
	U.tween_node_property(ColorBG, 'color:a', 0.4)		
	U.tween_node_property(OptionPanel, 'modulate:a', 1)
	await U.tween_node_property(OptionPanel, 'position:y', new_position.y, 0.3, 0, Tween.TRANS_SINE)

	# reveal buttons
	BtnControls.reveal(true)
# ----------------------------------------------
