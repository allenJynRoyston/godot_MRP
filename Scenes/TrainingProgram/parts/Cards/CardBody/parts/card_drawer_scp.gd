@tool
extends CardDrawerClass

@onready var ScpBtn:BtnBase = $MarginContainer/MarginContainer/VBoxContainer/ScpBtn

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
	super._ready()
	
	ScpBtn.index = 0	
	ScpBtn.onClick = func() -> void:
		if ScpBtn.scp_ref == -1:
			var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)
			# first, disables btns in the card
			onLock.call()
			# then disables the btn controls
			await ActionContainerNode.before_use()
			
			var scp_ref:int = await GAME_UTIL.select_scp_to_contain()
			await GAME_UTIL.trigger_initial_containment_event(scp_ref)

			await ActionContainerNode.after_use()	
			# unlocks
			onUnlock.call()			
	


func get_is_activated() -> bool:
	if !use_location.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		return extract_data.room.is_activated	 if (extract_data.has("room") and extract_data.room.has("is_activated")) else false
		
	return false



func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready():return
	ScpBtn.is_disabled = !get_is_activated()

func on_use_location_update() -> void:
	if !is_node_ready():return
	ScpBtn.use_location = use_location

func lock_btns(state:bool) -> void:
	ScpBtn.is_hoverable = !state

func get_btns() -> Array:	
	return [ScpBtn]
