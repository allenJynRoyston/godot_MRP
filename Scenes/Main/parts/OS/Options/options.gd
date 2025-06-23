extends PanelContainer

@onready var ColorBG:ColorRect = $ColorRect
@onready var BtnControls:Control = $BtnControls
@onready var StartBtn:Control = $Control/PanelContainer/MarginContainer/VBoxContainer/BtnList/StartBtn

@onready var OptionPanel:PanelContainer = $Control/PanelContainer
@onready var OptionList:VBoxContainer = $Control/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/OptionList

const OptionItemPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Options/parts/OptionItem.tscn")

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
		await end()
		wait_for_response.emit({
			"continue": false
		})
		
	BtnControls.onAction = func() -> void:
		match SelectedNode:
			StartBtn:
				await end()
				wait_for_response.emit({
					"continue": true,
					"properties": properties
				})
# ----------------------------------------------	

# ----------------------------------------------	
func end() -> void:
	for n in itemlist:
		n.is_selected = false

	U.tween_node_property(ColorBG, 'color:a', 0)
	U.tween_node_property(OptionPanel, 'position:y', OptionPanel.position.y + 10, 0.4, 0, Tween.TRANS_CIRC, Tween.EASE_IN)
	U.tween_node_property(OptionPanel, 'modulate:a', 0, 0.6)
	await BtnControls.reveal(false)

	hide()
	clear()
# ----------------------------------------------	

# ----------------------------------------------	
func clear() -> void:
	# clear
	for arr in [OptionList]:
		for child in arr.get_children():
			child.queue_free()	
# ----------------------------------------------	

# ----------------------------------------------
func setup(title:String, new_list:Array, new_position:Vector2 = Vector2()) -> void:
	show()
	var list:Array = new_list
		
	# reset
	itemlist = [StartBtn]
	properties = {}
	clear()
	
	StartBtn.title = title
	OptionPanel.position = new_position - Vector2(0, -10)
	
	# list
	for item in list:
		var new_node:Control = OptionItemPreload.instantiate()
		properties[item.key] = item.value
		itemlist.push_back(new_node)
		
		new_node.hint_description = item.hint_description if "hint_description" in item else null
		new_node.display_checkmark = true
		new_node.title = item.title
		new_node.is_checked = item.value
		new_node.onClick = func():
			new_node.is_checked = !new_node.is_checked
			properties[item.key] = new_node.is_checked
		OptionList.add_child(new_node)
	
	
	# add to btnlist
	BtnControls.itemlist = itemlist
	BtnControls.directional_pref = "UD"
	BtnControls.item_index = 0

	await U.tick()
	
	# fade in
	OptionPanel.size.y = 1
	U.tween_node_property(ColorBG, 'color:a', 0.4)		
	U.tween_node_property(OptionPanel, 'modulate:a', 1)
	await U.tween_node_property(OptionPanel, 'position:y', new_position.y, 0.4)
	
	# reveal buttons
	await BtnControls.reveal(true)
# ----------------------------------------------
