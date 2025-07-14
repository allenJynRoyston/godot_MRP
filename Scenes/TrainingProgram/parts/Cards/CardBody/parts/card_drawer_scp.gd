extends Control

@onready var SummaryBtn:Control = $MarginContainer/SummaryBtn

var room_config:Dictionary = {}

var preview_mode:bool = false
var use_location:Dictionary = {} : 
	set(val):
		use_location = val
		on_use_location_update()
		
var onLock:Callable = func() -> void:pass
var onUnlock:Callable = func() -> void:pass

func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)

func _ready() -> void:
	SummaryBtn.index = 0	
	SummaryBtn.onClick = func() -> void:pass
	


func get_is_activated() -> bool:
	if !use_location.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		return extract_data.room.is_activated	 if (extract_data.has("room") and extract_data.room.has("is_activated")) else false
		
	return false


func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready():return
	U.debounce(str(self, "_update_node"), update_node)

func on_use_location_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self, "_update_node"), update_node)


func update_node() -> void:
	if !is_node_ready() or use_location.is_empty() or room_config.is_empty():return
	var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)

	var room_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	var is_activated:bool = room_config_data.is_activated
	
	var is_room_empty:bool = room_config_data.room_data.is_empty()
	var is_scp_empty:bool = room_config_data.scp_data.is_empty()
	
	var room_details:Dictionary = {} if is_room_empty else room_config_data.room_data.details 
	var scp_details:Dictionary = {} if is_scp_empty else room_config_data.scp_data.details

	SummaryBtn.ref_data = {
		"type": 'scp',
		"data": scp_details
	}
	SummaryBtn.is_disabled = !is_activated
	SummaryBtn.title = "ASSIGN SCP" if is_scp_empty else scp_details.name
	SummaryBtn.onClick = func() -> void:
		if !is_scp_empty:return
		
		onLock.call()
		await ActionContainerNode.before_use()
		
		var scp_ref:int = await GAME_UTIL.select_scp_to_contain()
		
		if scp_ref != -1:
			await GAME_UTIL.trigger_initial_containment_event(scp_ref)
		
		await ActionContainerNode.after_use()	
		
		# unlocks
		onUnlock.call()				



func lock_btns(state:bool) -> void:
	pass

func get_btns() -> Array:	
	return [SummaryBtn]
