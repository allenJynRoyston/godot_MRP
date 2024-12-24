extends PanelContainer

@onready var CardContainer:HBoxContainer = $VBoxContainer/CardContainer

const ProfileCardPreload = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/RecruitContainer/parts/ProfileCard/ProfileCard.tscn")

var researcher_hire_list:Array = [] 
var lead_researchers_data:Array = []
var resources_data:Dictionary = {}
	
var addHire:Callable = func(data:Dictionary) -> void:pass

# ---------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_researcher_hire_list(self)
	SUBSCRIBE.subscribe_to_lead_researchers_data(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_researcher_hire_list(self)
	SUBSCRIBE.unsubscribe_to_lead_researchers_data(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
# ---------------------------------------------------------------

# ---------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
# ---------------------------------------------------------------

# ---------------------------------------------------------------
func on_lead_researchers_data_update(new_val:Array = lead_researchers_data) -> void:
	lead_researchers_data = new_val
# ---------------------------------------------------------------

# ---------------------------------------------------------------
func on_researcher_hire_list_update(new_val:Array = researcher_hire_list) -> void:
	researcher_hire_list = new_val
	
	var recruit_data = []
	for researcher in researcher_hire_list:
		recruit_data.push_back(RESEARCHER_UTIL.get_user_object(researcher))

	for node in CardContainer.get_children():
		node.queue_free()
		
	for index in recruit_data.size():
		var data:Dictionary = recruit_data[index]
		var card_node:Control = ProfileCardPreload.instantiate()
		card_node.data = data
		card_node.addHire = func(cost:int) -> void:
			if resources_data[RESOURCE.TYPE.MONEY].amount >= cost:
				addHire.call({
					"researcher": researcher_hire_list[index], 
					"cost": cost
				})
			# do purchase check first
		var already_hired:bool = lead_researchers_data.filter(func(i):return i[0] == data.uid).size() > 0
		card_node.none_available = already_hired
		CardContainer.add_child(card_node)
# ---------------------------------------------------------------	
