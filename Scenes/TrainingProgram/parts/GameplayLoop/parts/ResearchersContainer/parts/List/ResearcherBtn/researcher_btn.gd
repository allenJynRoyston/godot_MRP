extends MouseInteractions

@onready var NameLabel:BtnBase = $MarginContainer/HBoxContainer/NameLabel

var researcher_id:Array = [] : 
	set(val):
		researcher_id = val 
		on_researcher_id_update()

var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()

var researcher_details:Dictionary = {} 

var hired_lead_researchers:Array = []

var onClick:Callable = func(_researcher_details:Dictionary):pass

# --------------------------------------	
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
	
func _ready() -> void:
	super._ready()
	on_researcher_id_update()
	on_is_active_update()
# --------------------------------------	

# --------------------------------------	
func on_hired_lead_researchers_update(new_val:Array) -> void:
	hired_lead_researchers = new_val
# --------------------------------------	

# --------------------------------------	
func on_is_active_update() -> void:
	if !is_node_ready():return
	NameLabel.icon = SVGS.TYPE.DOT if is_active else SVGS.TYPE.NONE
# --------------------------------------	

# --------------------------------------	
func on_researcher_id_update() -> void:
	if !is_node_ready():return
	researcher_details = RESEARCHER_UTIL.get_user_object(researcher_id)

	NameLabel.title = researcher_details.name
# --------------------------------------		

# --------------------------------------	
func on_focus(state:bool) -> void:
	if !is_node_ready():return
		
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
# --------------------------------------	

# --------------------------------------	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover:
		onClick.call({} if is_active else researcher_details)
# --------------------------------------		
