@tool
extends CardDrawerClass

@onready var List:VBoxContainer = $MarginContainer/MarginContainer/List

const ScpBtnPreload:PackedScene = preload("res://UI/Buttons/ScpBtn/ScpBtn.tscn")

var scp_ref:int = 0 : 
	set(val):
		scp_ref = val
		on_scp_ref_update()
		
var preview_mode:bool = false
var use_location:Dictionary = {}
var onLock:Callable = func() -> void:pass
var onUnlock:Callable = func() -> void:pass

func _ready() -> void:
	super._ready()
	on_scp_ref_update()

func clear() -> void:
	for node in List.get_children():
		node.free()

func on_scp_ref_update() -> void:
	if !is_node_ready():return
	clear()
	
	var new_btn:Control = ScpBtnPreload.instantiate()
	new_btn.index = 0
	new_btn.use_location = use_location
	List.add_child(new_btn)

	#for index in range(0, researchers_per_room):
		#var new_btn:Control = RoomResearchersBtnPreload.instantiate()
		#new_btn.index = index
		#new_btn.use_location = use_location
		#new_btn.onClick = func() -> void:
			#var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)
			## first, disables btns in the card
			#onLock.call()
			## then disables the btn controls
			#await ActionContainerNode.before_use_ability()
			## perform the ability
			#if new_btn.researcher.is_empty():
				#await GAME_UTIL.assign_researcher()
			#else:
				#await GAME_UTIL.unassign_researcher(new_btn.researcher)
			## unlocks
			#onUnlock.call()
			#await ActionContainerNode.after_use_ability()
		#
		#List.add_child(new_btn)


func lock_btns(state:bool) -> void:
	for btn in List.get_children():
		btn.is_hoverable = !state

func get_btns() -> Array:	
	return List.get_children()
