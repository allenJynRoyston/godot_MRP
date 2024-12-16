extends ControlPanel

#@onready var WindowUI = $WindowUI
#@onready var ResourceTabContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/ResourceTabContainer
#
#@onready var money:Dictionary = {
	#"ref": RESOURCE.MONEY,
	#"node": null,
	#"node_data": {
		#"title": "Money",
		#"show_capacity": false,
		#"show_utilized": false
	#},
#} : 
	#set(val):
		#money = val
		#on_money_update()
		#
#@onready var energy:Dictionary = {
	#"ref": RESOURCE.ENERGY,
	#"node": null,
	#"node_data": {
		#"title": "Energy"
	#},
#} : 
	#set(val):
		#energy = val
		#on_energy_update()
		#
#@onready var staff:Dictionary = {
	#"ref": RESOURCE.STAFF,
	#"node": null,
	#"node_data": {
		#"title": "Staff"
	#},
#} : 
	#set(val):
		#staff = val
		#on_staff_update()
#
#@onready var mtf:Dictionary = {
	#"ref": RESOURCE.MTF,
	#"node": null,
	#"node_data": {
		#"title": "MTF"
	#},
#} : 
	#set(val):
		#mtf = val
		#on_mtf_update()
#
#@onready var dclass:Dictionary = {
	#"ref": RESOURCE.DCLASS,
	#"node": null,
	#"node_data": {
		#"title": "DClass"
	#},
#} : 
	#set(val):
		#dclass = val
		#on_dclass_update()
#
#@onready var select_arr:Array[Dictionary] = [money, energy, staff, mtf, dclass]
#
#const ResourceTabScene:PackedScene = preload("res://Components/ResourceGUI/parts/ResourceTab.tscn")
#
#var selected:int = 0 : 
	#set(val):
		#selected = val
		#on_selected_update()
		#
## -----------------------------------	
#func _ready() -> void:
	#RootPanel = $"."
	#super._ready()
	#
	#for item in select_arr:
		#item.node = ResourceTabScene.instantiate()
		#item.node.data = item.node_data
		#ResourceTabContainer.add_child(item.node)
		#
	#WindowUI.onDragEnd = func(new_offset:Vector2, node:Control) -> void:
		#var GameplayNode = GBL.find_node(REFS.GAMEPLAY_LOOP)
		#if GameplayNode != null:
			#var window_offset = GameplayNode.window_offsets.duplicate()		
			#window_offset[self.name] = new_offset		
			#GameplayNode.window_offsets = window_offset		
## -----------------------------------
#
## -----------------------------------
#func on_is_active_updated() -> void:
	#WindowUI.window_is_active = is_active
## -----------------------------------	
#
## -----------------------------------		
#func on_window_offset_update() -> void:
	#WindowUI.window_offset = window_offset
## -----------------------------------			
#
## -----------------------------------
#func on_inactive() -> void:
	#for item in select_arr:
		#if "node" in item:
			#item.node.is_active = false
## -----------------------------------
#
## -----------------------------------
#func on_active() -> void:
	#on_selected_update()
## -----------------------------------	
#
#
#
## -----------------------------------	
#func on_money_update() -> void:	
	#money.node.data = money.node_data	
## -----------------------------------		
#
## -----------------------------------	
#func on_energy_update() -> void:
	#energy.node.data = energy.node_data	
## -----------------------------------		
#
## -----------------------------------		
#func on_staff_update() -> void:
	#staff.node.data = staff.node_data
## -----------------------------------		
#
## -----------------------------------		
#func on_mtf_update() -> void:
	#mtf.node.data = mtf.node_data
## -----------------------------------			
#
## -----------------------------------		
#func on_dclass_update() -> void:
	#dclass.node.data = dclass.node_data
## -----------------------------------		
#
## -----------------------------------		
#func on_selected_update() -> void:
	#for index in select_arr.size():
		#if "node" in select_arr[index]:
			#var node:Control = select_arr[index].node
			#node.is_active = index == selected
## -----------------------------------			
#
## -----------------------------------	
#func on_data_update(_previous_state:Dictionary) -> void:
	#if data.is_empty():return
	#money.node_data.details = data[RESOURCE.MONEY]
	#money = money.duplicate()
#
	#energy.node_data.details = data[RESOURCE.ENERGY]
	#energy = energy.duplicate()
	#
	#staff.node_data.details = data[RESOURCE.STAFF]
	#staff = staff.duplicate()	
	#
	#mtf.node_data.details = data[RESOURCE.MTF]
	#mtf = mtf.duplicate()		
	#
	#dclass.node_data.details = data[RESOURCE.DCLASS]
	#dclass = dclass.duplicate()	
## -----------------------------------	
	#
	#
## -----------------------------------	
#func on_key_input(keycode:int) -> void:
	#match keycode: 
		## a
		#65: 
			#selected = select_arr.size() - 1 if selected - 1 < 0 else selected - 1
		## d btn
		#68: 
			#selected = (selected + 1) % select_arr.size()
## -----------------------------------		
