extends PanelContainer

@onready var ListContainer:VBoxContainer = $ActionsList/PanelContainer/MarginContainer/VBoxContainer/ListContainer

enum LIST_TYPE {CONTAINED, AVAILABLE}

const ActionItemBtnPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ContainmentContainer/parts/SCPActions/parts/ActionItemBtn/ActionItemBtn.tscn")

var list_type:LIST_TYPE = LIST_TYPE.AVAILABLE : 
	set(val):
		list_type = val
		on_list_type_update()

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		
var available_actions:Array = [] : 
	set(val): 
		available_actions = val

var purchased_facility_arr:Array = []
var scp_data:Dictionary = {} 

var onContain:Callable = func() -> void:pass
var onReject:Callable = func() -> void:pass
var onCancelTransfer:Callable = func() -> void:pass

# ------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_scp_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
# ------------------------------------------------------------

# ------------------------------------------------------------
func on_list_type_update() -> void:
	if !is_node_ready():return
	on_data_update()
	#update_list()
# ------------------------------------------------------------	

# ------------------------------------------------------------
func on_purchased_facility_arr_update(new_val:Array) -> void:
	purchased_facility_arr = new_val
# ------------------------------------------------------------

# ------------------------------------------------------------
func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val 
	on_data_update()
# ------------------------------------------------------------

# ------------------------------------------------------------
func on_data_update() -> void:
	if !is_node_ready():return
	
	for child in ListContainer.get_children():
		child.queue_free()
	
	if data.is_empty():return	
	
	var list:Array = []
	
	match list_type:
		LIST_TYPE.AVAILABLE:
			var scp_list:Array = scp_data.available_list.filter(func(i): return i.ref == data.ref)
			if scp_list.size() > 0:
				var active_scp_data:Dictionary = scp_list[0]

				var placement_bullepoints:Array = []
				var bonus_bulletpoints:Array = []
				var ongoing_bulletspoints:Array = []
				
				var initial_containment_rewards:Array = SCP_UTIL.return_initial_containment_rewards.call(data.ref)
				var ongoing_containment_rewards:Array = SCP_UTIL.return_ongoing_containment_rewards.call(data.ref)
				var containment_requirements:Array = data.containment_requirements
				
				for index in containment_requirements.size():
					var room_data:Dictionary = ROOM_UTIL.return_data( containment_requirements[index] )
					var room_count:int = ROOM_UTIL.get_count(index, purchased_facility_arr)
					placement_bullepoints.push_back({
						"icon": SVGS.TYPE.CLEAR if room_count < 1 else SVGS.TYPE.CHECKBOX, 
						"text": func() -> String:
							return 'Requires [%s] containment cell.  (You have %s available.)' % [str(room_data.name).to_upper(), room_count],
					})

				for item in initial_containment_rewards:
					match item.type:
						"amount": 
							bonus_bulletpoints.push_back({
								"icon": item.resource.icon, 
								"text": func() -> String:
									return '+%s %s [amount] on initial containment.' % [item.amount, str(item.resource.name).to_upper()],
							})
						"capacity":
							bonus_bulletpoints.push_back({
								"icon": item.resource.icon, 
								"text": func() -> String:
									return '+%s %s [capacity] on initial containment.' % [item.amount, str(item.resource.name).to_upper()],
							})

				for item in ongoing_containment_rewards:
					match item.type:
						"amount": 
							ongoing_bulletspoints.push_back({
								"icon": item.resource.icon, 
								"text": func() -> String:
									return '+%s %s [amount] for each week in containment.' % [item.amount, str(item.resource.name).to_upper()],
							})
						"capacity":
							ongoing_bulletspoints.push_back({
								"icon": item.resource.icon, 
								"text": func() -> String:
									return '+%s %s [capacity] for each week in containment.' % [item.amount, str(item.resource.name).to_upper()],
							})
							
				list = [
					{
						"title":"Cancel Transfer" if active_scp_data.days_until_expire > 0 else "Cancel and Reject",
						"title_icon": SVGS.TYPE.DELETE,
						"onClick": func() -> void:
							if active_scp_data.days_until_expire > 0:
								onCancelTransfer.call()
							else:
								onReject.call(),
					}		
				]  if active_scp_data.transfer_status.state else [
					{
						"title": "Contain",
						"title_icon": SVGS.TYPE.TARGET,
						"bulletpoints": [
							{
								"header": "Placement",
								"list": placement_bullepoints
							},
							{
								"header": "Initial Bonus",
								"list": bonus_bulletpoints
							},
							{
								"header": "Ongoing Containment Bonus",
								"list": ongoing_bulletspoints
							}								
						],
						"onClick": func() -> void:
							onContain.call(),
					},
					{
						"title":"Reject",
						"title_icon": SVGS.TYPE.DELETE,
						"onClick": func() -> void:
							onReject.call(),
					}		
				] 
			
		LIST_TYPE.CONTAINED:
			var scp_list:Array = scp_data.contained_list.filter(func(i): return i.ref == data.ref)
			if scp_list.size() > 0:			
				var active_scp_data:Dictionary = scp_list[0]
			# TODO check for any active statuses
	

	

	update_list(list)
# ------------------------------------------------------------

# ------------------------------------------------------------
func update_list(list:Array) -> void:
	if data.is_empty():return
	
	for action_data in list:
		var new_btn:Control = ActionItemBtnPreload.instantiate()
		new_btn.data = action_data
		new_btn.onClick = action_data.onClick
		ListContainer.add_child(new_btn)	
# ------------------------------------------------------------
