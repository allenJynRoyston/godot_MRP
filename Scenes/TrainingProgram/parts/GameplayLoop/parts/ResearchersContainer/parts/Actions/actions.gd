extends PanelContainer

@onready var ListContainer:VBoxContainer = $ActionsList/PanelContainer/MarginContainer/VBoxContainer/ListContainer

const ActionItemBtnPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ContainmentContainer/parts/SCPActions/parts/ActionItemBtn/ActionItemBtn.tscn")


var assign_only:bool = false : 
	set(val): 
		assign_only = val
		on_assign_only_update() 

var researcher_details:Dictionary = {} : 
	set(val):
		researcher_details = val
		on_researcher_details_update()

var onAction:Callable = func(_action:ACTION.RESEARCHERS):pass

var scp_details:Dictionary = {} : 
	set(val):
		scp_details = val
		on_scp_details_update()
		
		
# -------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_scp_data(self)
			
# -------------------------
func _ready() -> void:
	on_assign_only_update()
	on_researcher_details_update()
# -------------------------

# -------------------------
func on_assign_only_update() -> void:
	if !is_node_ready():return
	build_list()
# -------------------------

# -------------------------
func on_scp_details_update() -> void:
	if !is_node_ready():return
	build_list()
# -------------------------

# -------------------------
func on_scp_data_update(_new_val:Dictionary) -> void:
	build_list()
# -------------------------

# -------------------------
func on_researcher_details_update() -> void:
	if !is_node_ready():return
	
	if researcher_details.is_empty():
		reset_list()
		ListContainer.hide()
	else:
		ListContainer.show()	
		build_list()
# -------------------------

# -------------------------
func build_list() -> void:
	var list:Array = []
	if researcher_details.is_empty():return

	if assign_only:
		list.push_back(
			{
				"title":"Assign Researcher",
				"title_icon": SVGS.TYPE.CAUTION,
				"onClick": func() -> void:
					onAction.call(ACTION.RESEARCHERS.SELECT_FOR_ASSIGN),
				#"bulletpoints": [
					#{
						#"header": "Prerequisites",
						#"list": [
							#{
								#"icon": SVGS.TYPE.EMPTY_CHECKBOX, 
								#"text": func() -> String:
									#return "Nuclear Detonation Controls",
							#}	
						#]
					#}
				#]
			}		
		)	
	else:
		
		if !scp_details.is_empty():
			list.push_back(
				{
					"title":"Remove as Lead Researcher",
					"title_icon": SVGS.TYPE.CAUTION,
					"onClick": func() -> void:
						onAction.call(ACTION.RESEARCHERS.UNASSIGN_FROM_SCP),
					"bulletpoints": [
						{
							"header": "Attached to",
							"list": [
								{
									"icon": SVGS.TYPE.CONTAIN, 
									"text": func() -> String:
										return "%s" % [scp_details.name],
								}	
							]
						}
					]
				}		
			)
		else:
			list.push_back(
				{
					"title":"Assign as Lead Researcher",
					"title_icon": SVGS.TYPE.CAUTION,
					"onClick": func() -> void:
						onAction.call(ACTION.RESEARCHERS.ASSIGN_TO_SCP),
					"bulletpoints": [
						{
							"header": "Attached to",
							"list": [
								{
									"icon": SVGS.TYPE.CONTAIN, 
									"text": func() -> String:
										return "None",
								}	
							]
						}
					]
				}		
			)
			
		list.push_back(
			{
				"title":"Dismiss Researcher",
				"title_icon": SVGS.TYPE.CAUTION,
				"onClick": func() -> void:
					onAction.call(ACTION.RESEARCHERS.DISMISS),
				#"bulletpoints": [
					#{
						#"header": "Prerequisites",
						#"list": [
							#{
								#"icon": SVGS.TYPE.EMPTY_CHECKBOX, 
								#"text": func() -> String:
									#return "Nuclear Detonation Controls",
							#}	
						#]
					#}
				#]
			}		
		)			
					
	update_list(list)
# -------------------------

# -------------------------
func reset_list() -> void:
	for child in ListContainer.get_children():
		child.queue_free()
# -------------------------


# -------------------------
func update_list(list:Array) -> void:
	reset_list()
	
	for action_data in list:
		var new_btn:Control = ActionItemBtnPreload.instantiate()
		new_btn.data = action_data
		new_btn.onClick = action_data.onClick
		ListContainer.add_child(new_btn)	
# -------------------------
