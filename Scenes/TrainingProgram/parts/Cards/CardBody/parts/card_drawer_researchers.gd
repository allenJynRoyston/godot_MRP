@tool
extends CardDrawerClass

@onready var List:VBoxContainer = $MarginContainer/MarginContainer/List

const RoomResearchersBtnPreload:PackedScene = preload("res://UI/Buttons/RoomResearcherBtn/RoomResearcherBtn.tscn")

var required_staffing:Array = [] : 
	set(val):
		required_staffing = val
		on_required_staffing_update()
		
var preview_mode:bool = false
var use_location:Dictionary = {}
var room_details:Dictionary = {}
var onLock:Callable = func() -> void:pass
var onUnlock:Callable = func() -> void:pass

func _ready() -> void:
	super._ready()
	on_required_staffing_update()

func clear() -> void:
	for node in List.get_children():
		node.free()

func on_required_staffing_update() -> void:
	if !is_node_ready():return
	clear()
	
	for index in range(0, required_staffing.size()):
		var new_btn:Control = RoomResearchersBtnPreload.instantiate()
		new_btn.index = index
		new_btn.use_location = use_location
		new_btn.room_details = room_details
		#new_btn.pairs_with = pairs_with
		new_btn.onClick = func() -> void:
			var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)
			# first, disables btns in the card
			onLock.call()
			# then disables the btn controls
			await ActionContainerNode.before_use()
			# perform the ability
			if new_btn.researcher.is_empty():
				await GAME_UTIL.assign_researcher(required_staffing[index])
			else:
				await GAME_UTIL.unassign_researcher(new_btn.researcher)
			# unlocks
			onUnlock.call()
			await ActionContainerNode.after_use()
		
		List.add_child(new_btn)


func lock_btns(state:bool) -> void:
	for btn in List.get_children():
		btn.is_hoverable = !state

func get_btns() -> Array:	
	return List.get_children()
