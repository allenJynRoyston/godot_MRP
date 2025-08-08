extends Control

@onready var ListContainer:HBoxContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer
@onready var NoneLabel:Label = $VBoxContainer/Content/MarginContainer/NoneLabel

const MTFItemPreload:PackedScene = preload("res://UI/MTFItem/MTFItem.tscn")

var mtf:Array = [] : 
	set(val):
		mtf = val
		on_mtf_update()

# --------------------------------------------------------------------------------------------------
func _ready() -> void:	
	await U.tick()
	on_mtf_update()
# --------------------------------------------------------------------------------------------------

# -----------------------------------------------			
func clear() -> void:
	for item in ListContainer.get_children():
		item.queue_free()
# -----------------------------------------------			

# -----------------------------------------------			
func on_mtf_update() -> void:
	if !is_node_ready():return
	for item in ListContainer.get_children():
		item.queue_free()
	
	NoneLabel.show() if mtf.is_empty() else NoneLabel.hide()
	
	for ref in mtf:
		var new_node:Control = MTFItemPreload.instantiate()
		var mtf_details:Dictionary = MTF.return_data(ref)
		new_node.title = mtf_details.name
		new_node.icon = SVGS.TYPE.RECRUIT
		
		ListContainer.add_child(new_node)
# -----------------------------------------------				
