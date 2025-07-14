extends PanelContainer

@onready var List:VBoxContainer = $MarginContainer/List

const SummaryBtnPreload:PackedScene = preload("res://UI/Buttons/SummaryBtn/SummaryBtn.tscn")

var preview_mode:bool = false

var required_staffing:Array = [] : 
	set(val):
		required_staffing = val
		on_required_staffing_update()
		
var use_location:Dictionary = {} : 
	set(val):
		use_location = val
		U.debounce(str(self, "_update_node"), update_node)
		
var room_details:Dictionary = {} :
	set(val):
		room_details = val
		U.debounce(str(self, "_update_node"), update_node)

var hired_lead_researchers_arr:Array = []
var previous_room:int = -1
var previous_ring:int = -1
var previous_room_ref:int = -1
var redraw:bool = false
var NodeList:Array = []	

var onLock:Callable = func() -> void:pass
var onUnlock:Callable = func() -> void:pass

# -----------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
# -----------------------------------------------------------

func _ready() -> void:
	on_required_staffing_update()
	
func clear() -> void:
	for node in List.get_children():
		node.queue_free()

func on_required_staffing_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self, "_build_list"), build_list)

func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers_arr) -> void:
	hired_lead_researchers_arr = new_val
	U.debounce(str(self, "_update_node"), update_node)

func on_use_location_update() -> void:
	if !is_node_ready() or use_location.is_empty():return
	U.debounce(str(self, "_build_list"), build_list)
	U.debounce(str(self, "_update_node"), update_node)	

func build_list() -> void:
	if use_location.is_empty():return
	if previous_room != use_location.room or previous_ring != use_location.ring or room_details.ref != previous_room_ref:
		previous_room = use_location.room
		previous_ring = use_location.ring
		previous_room_ref = room_details.ref
		redraw = true
		NodeList = []
	
		for index in range(0, required_staffing.size()):
			var new_btn:Control = SummaryBtnPreload.instantiate()
			new_btn.index = index
			new_btn.onClick = func() -> void:pass
			NodeList.push_back(new_btn)
			
		U.debounce(str(self, "_update_node"), update_node)			

func update_node() -> void:
	if !is_node_ready() or use_location.is_empty() or room_details.is_empty():return
	var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)
	
	for index in NodeList.size():
		if NodeList.size() > index and room_details.required_staffing.size() > index:
			var SummaryBtnNode:Control = NodeList[index]
			var required_slot:Dictionary = RESEARCHER_UTIL.return_specialization_data(room_details.required_staffing[index])

			# find researcher in slot
			var filtered:Array = hired_lead_researchers_arr.filter(func(x):
				var researcher_data:Dictionary = RESEARCHER_UTIL.get_user_object(x)
				var assigned_room:Dictionary = researcher_data.props.assigned_to_room
				var slot:int = researcher_data.props.slot
				var specialization_ref:int = researcher_data.specialization.ref

				var is_assigned_to_room:bool = !assigned_room.is_empty()
				var matches_location:bool = assigned_room == use_location
				var is_specialist_match:bool = specialization_ref == required_slot.ref

				if required_slot.ref == RESEARCHER.SPECIALIZATION.ANY:
					return (is_assigned_to_room and matches_location) and (slot == index)
				
				return  (is_assigned_to_room and matches_location) and (slot == index) and is_specialist_match
			)
			
			# then assign
			var researcher:Dictionary = RESEARCHER_UTIL.get_user_object(filtered[0]) if filtered.size() > 0 else {}
			
			# fill btn slots
			if researcher.is_empty():
				#SummaryBtnNode.use_alt = true
				SummaryBtnNode.title = "ASSIGN %s" % [required_slot.name]
				SummaryBtnNode.ref_data = {
					"type": 'researcher', 
					"data": {}
				}

				#SummaryBtnNode.icon = SVGS.TYPE.PLUS
				#SummaryBtnNode.hint_title = "HINT"
				#SummaryBtnNode.hint_icon = SVGS.TYPE.CONVERSATION
				#SummaryBtnNode.hint_description = "This room requires a %s to be activated." % required_slot.name
				#SummaryBtnNode.onClick = func() -> void:
					#onLock.call()
					#await ActionContainerNode.before_use()
					#await GAME_UTIL.assign_researcher(required_staffing[index], index)
					#onUnlock.call()
					#await ActionContainerNode.after_use()			
			else:	
				SummaryBtnNode.ref_data = {
					"type": "researcher", 
					"data": researcher
				}			
				SummaryBtnNode.use_alt = false
				SummaryBtnNode.title = researcher.name
				SummaryBtnNode.icon = SVGS.TYPE.STAFF
				SummaryBtnNode.hint_title = "HINT"
				SummaryBtnNode.hint_icon = SVGS.TYPE.CONVERSATION
				SummaryBtnNode.hint_description = "This room requires a %s to be activated." % required_slot.name
				SummaryBtnNode.onClick = func() -> void:
					onLock.call()
					await ActionContainerNode.before_use()
					await GAME_UTIL.unassign_researcher(researcher)
					onUnlock.call()
					await ActionContainerNode.after_use()	
					
			if redraw:
				List.add_child(SummaryBtnNode)
	
	redraw = false
	for node in List.get_children():
		if node not in NodeList:
			node.free()
		
		
func lock_btns(state:bool) -> void:
	if !is_node_ready():return


func get_btns() -> Array:	
	return List.get_children()
