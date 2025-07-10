extends VBoxContainer

@onready var RootPanel:PanelContainer = $PanelContainer
@onready var ObjectiveTitle:Label = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/ObjectiveTitle
@onready var CostLabel:Label = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/CostLabel
@onready var LockIcon:Control = $PanelContainer/MarginContainer/HBoxContainer/SVGIcon
@onready var HasMoreIcon:Control = $HasMoreBtn

var index:int : 
	set(val):
		index = val
		on_index_update()

var title:String = "" : 
	set(val):
		title = val
		on_title_update()
		
var cost:int = 0 : 
	set(val):
		cost = val
		on_cost_update()
		
var is_complete:bool = false : 
	set(val):
		is_complete = val
		on_is_complete_update()

var is_locked:bool = false : 
	set(val):
		is_locked = val
		on_is_locked_update()

var is_expired:bool = false : 
	set(val):
		is_expired = val
		on_is_expired_update()

var has_more:bool = false : 
	set(val):
		has_more = val
		on_has_more_update()

# -----------------------------------------
func _ready() -> void:
	on_index_update()
	on_title_update()
	on_is_complete_update()
	on_cost_update()
	on_has_more_update()
	on_is_expired_update()
	on_is_locked_update.call_deferred()
# -----------------------------------------

# -----------------------------------------
func on_index_update() -> void:
	if !is_node_ready():return

	
func on_is_complete_update() -> void:
	if !is_node_ready():return
	var label_settings_copy:LabelSettings = ObjectiveTitle.label_settings.duplicate()
	var use_color:Color = COLORS.primary_black 
	label_settings_copy.font_color = use_color
	label_settings_copy.font_color.a = 1 
	ObjectiveTitle.label_settings = label_settings_copy

func on_is_expired_update() -> void:
	if !is_node_ready():return

func on_cost_update() -> void:
	if !is_node_ready():return
	CostLabel.text = "UNLOCK WITH %s %s." % [cost, "CORE" if cost < 2 else "CORES"]

func on_title_update() -> void:
	if !is_node_ready():return
	ObjectiveTitle.text = title 
	
func on_is_locked_update() -> void:
	if !is_node_ready():return
	LockIcon.icon = (SVGS.TYPE.CHECKBOX if is_complete else SVGS.TYPE.EMPTY_CHECKBOX) if !is_locked else SVGS.TYPE.LOCK 
	#OrderLabel.hide() if is_locked else OrderLabel.show()
	ObjectiveTitle.hide() if is_locked else ObjectiveTitle.show()
	CostLabel.show() if is_locked else CostLabel.hide()

func on_has_more_update() -> void:
	if !is_node_ready():return
	HasMoreIcon.show() if has_more else HasMoreIcon.hide()
# -----------------------------------------
