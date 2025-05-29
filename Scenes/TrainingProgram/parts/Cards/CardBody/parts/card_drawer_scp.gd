@tool
extends CardDrawerClass

@onready var ScpBtn:BtnBase = $MarginContainer/MarginContainer/VBoxContainer/ScpBtn

var preview_mode:bool = false
var use_location:Dictionary = {} : 
	set(val):
		use_location = val
		on_use_location_update()
		
var onLock:Callable = func() -> void:pass
var onUnlock:Callable = func() -> void:pass

func _ready() -> void:
	super._ready()
	
	ScpBtn.index = 0	
	ScpBtn.onClick = func() -> void:
		var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)
		# first, disables btns in the card
		onLock.call()
		# then disables the btn controls
		await ActionContainerNode.before_use_ability()
		# perform the ability
		#if new_btn.researcher.is_empty():
		await GAME_UTIL.contain_scp()
		#	await GAME_UTIL.unassign_researcher(new_btn.researcher)
		# unlocks
		onUnlock.call()
		await ActionContainerNode.after_use_ability()	

func on_use_location_update() -> void:
	if !is_node_ready():return
	ScpBtn.use_location = use_location

func lock_btns(state:bool) -> void:
	ScpBtn.is_hoverable = !state

func get_btns() -> Array:	
	return [ScpBtn]
