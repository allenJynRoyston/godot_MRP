extends PanelContainer

@onready var CardContainer:HBoxContainer = $VBoxContainer/CardContainer

const ProfileCardPreload = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/RecruitContainer/parts/ProfileCard/ProfileCard.tscn")

var recruit_data:Array = []:
	set(val):
		recruit_data = val
		on_recruit_data_update()

var researcher_hire_list:Array = [] : 
	set( val ):
		researcher_hire_list = val
		on_researcher_hire_list_update()
		
var lead_researchers_data:Array = [] : 
	set ( val ): 
		lead_researchers_data = val
		on_recruit_data_update()

var resources_data:Dictionary = {} 
	
var addHire:Callable = func(data:Dictionary) -> void:pass

# ---------------------------------------------------------------
func _ready() -> void:
	on_recruit_data_update()
	on_researcher_hire_list_update()
# ---------------------------------------------------------------

# ---------------------------------------------------------------
func on_recruit_data_update() -> void:
	if !is_node_ready():return
	
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

# ---------------------------------------------------------------
func on_researcher_hire_list_update() -> void:
	recruit_data = []
	for researcher in researcher_hire_list:
		recruit_data.push_back(RESEARCHER_UTIL.get_user_object(researcher))
	recruit_data = recruit_data
# ---------------------------------------------------------------
