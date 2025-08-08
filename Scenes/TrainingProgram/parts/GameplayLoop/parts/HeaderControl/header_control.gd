extends GameContainer

@onready var Location:Control = $Location
@onready var Visualizer:Control = $Visualizer
@onready var HeaderLeft:Control = $HeaderLeft
@onready var HeaderWingRight:Control = $HeaderWingRight
@onready var HeaderFloorRight:Control = $HeaderFloorRight
@onready var BuffsAndDebuffs:Control = $BuffsAndDebuffs


# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.GAMEPLAY_HEADER, self)

func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.GAMEPLAY_HEADER)

func _ready() -> void:
	super._ready()
	modulate = Color(1, 1, 1, 0)

func activate() -> void:
	modulate = Color(1, 1, 1, 1)	
	update.call_deferred()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------	
func on_camera_settings_update(new_val:Dictionary) -> void:
	camera_settings = new_val
	U.debounce(str(self, "_update"), update)
# --------------------------------------------------------------------------------------------------	

# -----------------------------------------------
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()
	U.debounce(str(self, "_update"), update)
# -----------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func get_hint_buttons() -> Array:
	return []
	#var btns:Array =  [Energy, PersonnelStaff, PersonnelTechnicians, PersonnelSecurity, PersonnelDClass]
	#for node in [FloorBuffsContainer, RingBuffsContainer, RoomBuffContainer]:
		#if node.is_visible_in_tree():
			#for child in node.get_children():
				#btns.push_back(child)
	#return btns
# --------------------------------------------------------------------------------------------------	

# -----------------------------------------------	
func update() -> void:
	if !is_node_ready() or camera_settings.is_empty():return

	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			HeaderWingRight.reveal(false)
			for node in [Location, Visualizer, HeaderLeft, HeaderFloorRight, BuffsAndDebuffs]:
				node.reveal(is_showing)	
		CAMERA.TYPE.WING_SELECT:
			HeaderFloorRight.reveal(false)
			for node in [Location, Visualizer, HeaderLeft, HeaderWingRight, BuffsAndDebuffs]:
				node.reveal(is_showing)	
	

# -----------------------------------------------	
