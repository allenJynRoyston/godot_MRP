extends PanelContainer

# --------------------------------------------
@onready var HeaderTitle:Label = $MarginContainer/VBoxContainer/Label

@onready var Morale:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/Morale
@onready var Safety:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/Safety
@onready var Readiness:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/Readiness

@onready var MoraleTag:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/MoraleTag
@onready var SafetyTag:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/SafetyTag
@onready var ReadinessTag:PanelContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/ReadinessTag
# --------------------------------------------

# --------------------------------------------
var header:String  = "" : 
	set(val):
		header = val
		on_header_update()
		
var morale_val:int : 
	set(val):
		morale_val = val
		on_morale_val_update()
		
var safety_val:int : 
	set(val):
		safety_val = val
		on_safety_val_update()
		
var readiness_val:int : 
	set(val):
		readiness_val = val
		on_readiness_val_update()
		
var morale_tag_val:int : 
	set(val):
		morale_tag_val = val
		on_morale_tag_val_update()
		
var safety_tag_val:int : 
	set(val):
		safety_tag_val = val
		on_safety_tag_val_update()		
		
var readiness_tag_val:int : 
	set(val):
		readiness_tag_val = val
		on_readiness_tag_val_update()
	
var resources_data:Dictionary
# --------------------------------------------

# --------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_resources_data(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_resources_data(self)

func _ready() -> void:
	on_header_update()
	
	on_morale_val_update()
	on_safety_val_update()
	on_readiness_val_update()
	
	on_morale_tag_val_update()
	on_safety_tag_val_update()
	on_readiness_tag_val_update()
	
	update_node()
# --------------------------------------------


# --------------------------------------------
func on_header_update() -> void:
	if !is_node_ready():return
	HeaderTitle.text = str(header)
	
func on_morale_val_update() -> void:
	if !is_node_ready():return
	Morale.value = morale_val
	print("updat emorale value: ", Morale.value)
	
func on_safety_val_update() -> void:
	if !is_node_ready():return
	Safety.value = safety_val
	
func on_readiness_val_update() -> void:
	if !is_node_ready():return
	Readiness.value = readiness_val
	
func on_morale_tag_val_update() -> void:
	if !is_node_ready():return
	MoraleTag.val = morale_tag_val
	
func on_safety_tag_val_update() -> void:
	if !is_node_ready():return
	SafetyTag.val = safety_tag_val
	
func on_readiness_tag_val_update() -> void:
	if !is_node_ready():return
	ReadinessTag.val = readiness_tag_val
# --------------------------------------------

# --------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val	
	U.debounce(str(self, "_update_node"), update_node)
# --------------------------------------------	

# --------------------------------------------	
func update_node() -> void:
	if !is_node_ready() or resources_data.is_empty():return
	# update vibes
	morale_val = 1
	safety_val = 1
	readiness_val = 1
	# update metrics
	morale_tag_val = 1
	safety_tag_val = 1
	readiness_tag_val = 1
# --------------------------------------------	
