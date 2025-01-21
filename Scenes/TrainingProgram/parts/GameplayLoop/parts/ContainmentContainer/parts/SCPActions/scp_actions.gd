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
var onAction:Callable = func(action:ACTION.CONTAINED) -> void:pass
var hired_lead_researchers_arr:Array = []

var assign_only:bool = false : 
	set(val):
		assign_only = val
		on_assign_only_update()

# ------------------------------------------------------------
func ready() -> void:
	on_assign_only_update()
	
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_scp_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
# ------------------------------------------------------------

# ------------------------------------------------------------
func on_list_type_update() -> void:
	if !is_node_ready():return
	on_data_update()
	#update_list()
# ------------------------------------------------------------	

# -------------------------
func on_assign_only_update() -> void:
	if !is_node_ready():return
	on_data_update()
# -------------------------

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
func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers_arr) -> void:
	hired_lead_researchers_arr = new_val
# ------------------------------------------------------------


# ------------------------------------------------------------
func on_data_update() -> void:
	if !is_node_ready():return
	
	for child in ListContainer.get_children():
		child.queue_free()
	
	if data.is_empty():return	
	
	var list:Array = []
	
	
	match list_type:
		# ----------------------------------------------------------------
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
						"title":"Cancel Containment" if active_scp_data.days_until_expire > 0 else "Cancel and Reject",
						"title_icon": SVGS.TYPE.DELETE,
						"onClick": func() -> void:
							if active_scp_data.days_until_expire > 0:
								onAction.call(ACTION.CONTAINED.STOP_CONTAINMENT)
							else:
								onAction.call(ACTION.CONTAINED.REJECT_AND_REMOVE),
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
							onAction.call(ACTION.CONTAINED.START_CONTAINMENT),
					},
					{
						"title":"Reject",
						"title_icon": SVGS.TYPE.DELETE,
						"onClick": func() -> void:
							onAction.call(ACTION.CONTAINED.REJECT_AND_REMOVE),
					}		
				] 
				
		# ----------------------------------------------------------------
		LIST_TYPE.CONTAINED:
			var scp_list:Array = scp_data.contained_list.filter(func(i): return i.ref == data.ref)
			if scp_list.size() > 0:			
				var active_scp_data:Dictionary = scp_list[0]
				var can_transfer:bool = active_scp_data.current_activity.is_empty()
				var can_destroy:bool = false
				
				if assign_only:
					list.push_back(
						{
							"title": "Select" if active_scp_data.lead_researcher.is_empty() else "Select (Unavailable)",
							"title_icon": SVGS.TYPE.DRS,
							"onClick": func() -> void:
								if active_scp_data.lead_researcher.is_empty():
									onAction.call(ACTION.CONTAINED.SELECT_FOR_ASSIGN),
							"bulletpoints": [] if active_scp_data.lead_researcher.is_empty() else [
								{
									"header": "Lead Researcher already assigned",
									"list": [
										{
											"icon": SVGS.TYPE.STAFF, 
											"text": func() -> String:
												var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(active_scp_data.lead_researcher.uid, hired_lead_researchers_arr)
												return "DR %s" % [researcher_details.name],
										}	
									]
								}
							] 
						}		
					)					
				else:
					if active_scp_data.transfer_status.state:
						list.push_back(
							{
								"title":"Cancel Transfer",
								"title_icon": SVGS.TYPE.DELETE,
								"onClick": func() -> void:
									onAction.call(ACTION.CONTAINED.CANCEL_TRANSFER),
							}	
						)
					else:
						
						if !active_scp_data.lead_researcher.is_empty():
							list.push_back(
								{
									"title": "Start Testing" if active_scp_data.current_activity.is_empty() else "Stop Testing",
									"title_icon": SVGS.TYPE.RESEARCH,
									"onClick": func() -> void:
										onAction.call(ACTION.CONTAINED.START_TESTING if active_scp_data.current_activity.is_empty() else ACTION.CONTAINED.STOP_TESTING),
								}		
							)					

						list.push_back(
							{
								"title":"Assign Lead Researcher" if active_scp_data.lead_researcher.is_empty() else "Remove Lead Researcher",
								"title_icon": SVGS.TYPE.DRS,
								"onClick": func() -> void:
									onAction.call(ACTION.CONTAINED.ASSIGN_RESEARCHER if active_scp_data.lead_researcher.is_empty() else ACTION.CONTAINED.UNASSIGN_RESEARCHER),
								"bulletpoints": [
									{
										"header": "Lead Researcher",
										"list": [
											{
												"icon": SVGS.TYPE.STAFF, 
												"text": func() -> String:
													if active_scp_data.lead_researcher.is_empty():
														return "NONE ASSIGNED"
													else:
														var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(active_scp_data.lead_researcher.uid, hired_lead_researchers_arr)
														return "DR %s" % [researcher_details.name],
											}	
										]
									}
								]
							}
						)
						
						list.push_back(
							{
								"title":"Transfer SCP" if can_transfer else "Transfer SCP (Unavailable)",
								"title_icon": SVGS.TYPE.CONTAIN,
								"onClick": func() -> void:
									if can_transfer:
										onAction.call(ACTION.CONTAINED.TRANSFER_TO_NEW_LOCATION),
								"bulletpoints": [] if can_transfer else [
									{
										"header": "Action unavailable",
										"list": [
											{
												"icon": SVGS.TYPE.CLEAR, 
												"text": func() -> String:
													return "Testing ongoing.",
											}	
										]
									}
								]										
							}		
						)
											
						list.push_back(
							{
								"title": "Destroy SCP" if can_destroy else  "Destroy SCP (Unavailable)",
								"title_icon": SVGS.TYPE.CAUTION,
								"onClick": func() -> void:
									if can_destroy:
										pass,	
								"bulletpoints": [] if can_destroy else [
									{
										"header": "Action unavailable",
										"list": [
											{
												"icon": SVGS.TYPE.CLEAR, 
												"text": func() -> String:
													return "Technology missing",
											}	
										]
									}
								]
							}		
						)

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
