extends Control

@onready var SummaryBtn:Control = $MarginContainer/SummaryBtn

@export var room_details:Dictionary = {} : 
	set(val):
		room_details = val
		on_room_details_update()

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
	on_room_details_update()
	

func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready():return
	U.debounce(str(self, "_update_node"), update_node)

func on_use_location_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self, "_update_node"), update_node)

func on_room_details_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self, "_update_node"), update_node)

func update_node() -> void:
	if !is_node_ready() or use_location.is_empty() or room_config.is_empty() or room_details.is_empty():return
	var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)
	var room_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	var is_activated:bool = room_config_data.is_activated	
	var is_room_empty:bool = room_config_data.room_data.is_empty()
	var is_scp_empty:bool = room_config_data.scp_data.is_empty()	
	var scp_details:Dictionary = {} if is_scp_empty else room_config_data.scp_data.details
	

	SummaryBtn.ref_data = {
		"type": 'scp',
		"data": scp_details,
		"is_disabled":  !is_activated 
	}

	SummaryBtn.hint_title = "HINT"
	SummaryBtn.hint_icon = SVGS.TYPE.WARNING if is_scp_empty else SVGS.TYPE.CONTAIN
	SummaryBtn.hint_description = "Requires activation" if !is_activated else ("Containment cell is empty." if is_scp_empty else scp_details.abstract.call(scp_details))
	
	SummaryBtn.icon = SVGS.TYPE.WARNING if is_scp_empty else SVGS.TYPE.CONTAIN
	SummaryBtn.use_alt = is_scp_empty and is_activated
	SummaryBtn.is_disabled = !is_activated
	SummaryBtn.title = "UNAVAILABLE" if !is_activated else  "ASSIGN SCP" if is_scp_empty else scp_details.name 
	SummaryBtn.onClick = func() -> void:
		if !is_scp_empty:return
		
		onLock.call()
		await ActionContainerNode.before_scp_selection()
		
		var scp_ref:int = await GAME_UTIL.select_scp()
		
		if scp_ref != -1:
			await GAME_UTIL.trigger_initial_containment_event(scp_ref)
		
		await ActionContainerNode.after_scp_selection()	
		
		# unlocks
		onUnlock.call()				



func lock_btns(state:bool) -> void:
	pass

func get_btns() -> Array:	
	
	return [SummaryBtn] if SummaryBtn.is_visible_in_tree() else []
