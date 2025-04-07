extends PanelContainer

@onready var MissingPanel:Control = $MissingPanel
@onready var CardContainer:HBoxContainer = $VBoxContainer/CardContainer
@onready var NextLabel:Label = $VBoxContainer/NextLabel

const ResearcherCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/RESEARCHER/ResearcherCard.tscn")

var researcher_hire_list:Array = [] 
var hired_lead_researchers_arr:Array = []
var resources_data:Dictionary = {}
var progress_data:Dictionary = {}
var purchased_facility_arr:Array = []
var addHire:Callable = func(data:Dictionary) -> void:pass
var allow_recruitment:bool = false : 
	set(val):
		allow_recruitment = val
		on_allow_recruitment_update()
		
# ---------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_progress_data(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_researcher_hire_list(self)
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_progress_data(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_researcher_hire_list(self)
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)

func _ready() -> void:
	on_allow_recruitment_update()
# ---------------------------------------------------------------

# ------------------------------------
func on_purchased_facility_arr_update(new_val:Array) -> void:
	if !is_node_ready():return
	purchased_facility_arr = new_val
	allow_recruitment = true #ROOM_UTIL.get_count(ROOM.TYPE.HR_DEPARTMENT, new_val) > 0 
# ------------------------------------

# ------------------------------------
func on_progress_data_update(new_val:Dictionary = progress_data) -> void:
	if progress_data.is_empty():return
	progress_data = new_val
	NextLabel.text = "More choices available in %s days" % [progress_data.days_till_report]
# ------------------------------------

# ---------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
# ---------------------------------------------------------------

# ---------------------------------------------------------------
func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers_arr) -> void:
	hired_lead_researchers_arr = new_val
	on_researcher_hire_list_update()
# ---------------------------------------------------------------

# ---------------------------------------------------------------
func on_allow_recruitment_update() -> void:
	if !is_node_ready():return
	MissingPanel.show() if !allow_recruitment else MissingPanel.hide()	
# ---------------------------------------------------------------


# ---------------------------------------------------------------
func on_researcher_hire_list_update(new_val:Array = researcher_hire_list) -> void:
	if !is_node_ready():return
	researcher_hire_list = new_val
	
	var recruit_data = []
	for researcher in researcher_hire_list:
		recruit_data.push_back(RESEARCHER_UTIL.get_user_object(researcher))

	for node in CardContainer.get_children():
		node.queue_free()
		
	for index in recruit_data.size():
		var data:Dictionary = recruit_data[index]
		var card_node:Control = ResearcherCardPreload.instantiate()
		#card_node.data = data
		#card_node.addHire = func(cost:int) -> void:
			#if !allow_recruitment:return
			#if resources_data[RESOURCE.CURRENCY.MONEY].amount >= cost:
				#addHire.call({
					#"researcher": researcher_hire_list[index], 
					#"cost": cost
				#})
			## do purchase check first
		#var already_hired:bool = hired_lead_researchers_arr.filter(func(i):return i[0] == data.uid).size() > 0
		#card_node.none_available = already_hired
		CardContainer.add_child(card_node)
# ---------------------------------------------------------------	
