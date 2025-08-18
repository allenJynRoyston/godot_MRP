extends MouseInteractions

@onready var HeaderPanel:PanelContainer = $VBoxContainer/Header
@onready var ContentPanel:PanelContainer = $VBoxContainer/PanelContainer

@onready var HeaderLabel:Label = $VBoxContainer/Header/MarginContainer/HBoxContainer/HeaderLabel
@onready var LockIcon:Control = $VBoxContainer/Header/MarginContainer/HBoxContainer/LockContainer/LockIcon
@onready var SelectedIcon:Control = $VBoxContainer/Header/MarginContainer/HBoxContainer/SelectedIcon

@onready var TitleLabel:Label = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var DescriptionLabel:Label = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Description
@onready var OutcomeLabel:Label = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/OutcomeLabel
@onready var ImageRect:TextureRect = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/TextureRect

@onready var Costs:VBoxContainer = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Costs
@onready var CostHBox:HBoxContainer = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Costs/CostHBox

@onready var content_stylebox_copy:StyleBoxFlat = ContentPanel.get("theme_override_styles/panel").duplicate()
@onready var header_stylebox_copy:StyleBoxFlat = HeaderPanel.get("theme_override_styles/panel").duplicate()
@onready var title_label_setting:LabelSettings = TitleLabel.get("label_settings").duplicate()
@onready var outcome_label_setting:LabelSettings = OutcomeLabel.get("label_settings").duplicate()

const EconItemPreload:PackedScene = preload("res://UI/EconItem/EconItem.tscn")
const VibeItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/HeaderControl/parts/VibeItem/VibeItem.tscn")

var index:int
var enabled:bool = false 
var is_selectable:bool = true
var can_afford:bool = true

var is_available:bool = true : 
	set(val):
		is_available = val
		is_available_update()

var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

# ----------------------
func _init() -> void:
	super._init()
	modulate = Color(1, 1, 1, 0)

func _ready() -> void:
	super._ready()
	on_data_update()
	ContentPanel.set('theme_override_styles/panel', content_stylebox_copy)		
	HeaderPanel.set("theme_override_styles/panel", header_stylebox_copy)
	TitleLabel.set("label_settings", title_label_setting)
	OutcomeLabel.set("label_settings", outcome_label_setting)
	
	for node in CostHBox.get_children():
		node.queue_free()
	
	hint_title = "HINT"
	on_is_selected_update()
	

func start(delay:float = 0) -> void:
	pass
# ----------------------

# ----------------------	
func fade_out(delay:float = 0) -> void:
	U.tween_node_property(LockIcon, 'icon_color:a', 0, 0.3, delay)
	await U.tween_node_property(self, 'modulate:a', 0, 0.3, delay)
# ----------------------		

# ----------------------	
func is_available_update() -> void:
	U.debounce(str(self, "_update_node"), update_node)

func on_data_update() -> void:
	U.debounce(str(self, "_update_node"), update_node)

func on_is_selected_update() -> void:
	U.debounce(str(self, "_update_node"), update_node)
# ----------------------	

# ----------------------	
var built_once:bool = false
func update_node(rebuild_list:bool = true) -> void:
	if !is_node_ready() or data.is_empty():return
	
	# elements
	if data.has("header"):
		HeaderLabel.show()
		HeaderLabel.text = data.header
	else:
		HeaderLabel.hide()

	if data.has("title"):
		TitleLabel.show()
		TitleLabel.text = data.title
	else:
		TitleLabel.hide()
	
	if data.has("description"):
		DescriptionLabel.show()
		DescriptionLabel.text = data.description
	else:
		DescriptionLabel.hide()
		
	if data.has("outcomes") and data.outcomes.has("outcome_description"):
		OutcomeLabel.show()
		OutcomeLabel.text = data.outcomes.outcome_description
	else:
		OutcomeLabel.hide()
		
	if data.has("cost"):
		Costs.show()	
				
		if data.cost.has("currency") and !built_once:
			for ref in data.cost.currency:
				var amount:int = data.cost.currency[ref]
				var new_node:Control = EconItemPreload.instantiate()
				var resource_data:Dictionary = RESOURCE_UTIL.return_currency(ref)
				new_node.icon = resource_data.icon
				new_node.amount = amount
				new_node.horizontal_mode = false
				new_node.burn_val = ""
				CostHBox.add_child(new_node)		
		
		if data.cost.has("metrics") and !built_once:
			for ref in data.cost.metrics:
				var amount:int = data.cost.metrics[ref]
				var new_node:Control = VibeItemPreload.instantiate()
				new_node.metric = ref
				new_node.value = amount
				new_node.invert_color = true
				CostHBox.add_child(new_node)

		built_once = true
	else:
		Costs.hide()
		
	# update content stylebox
	content_stylebox_copy.bg_color = Color.DARK_GRAY if !is_selected else COLORS.primary_color 
	
	# update header when selected
	header_stylebox_copy.bg_color = COLORS.primary_black if is_available and can_afford else COLORS.disabled_color
	title_label_setting.font_color = Color.WHITE if !is_selected else Color.BLACK if can_afford else COLORS.disabled_color
	
	outcome_label_setting.font_color = Color.PURPLE
	outcome_label_setting.outline_color = outcome_label_setting.font_color
	outcome_label_setting.outline_color.a = 0.2
	
	# modulate
	modulate.a = 1 if is_selected else 0.9
	
	# lock icon
	LockIcon.icon_color.a = 1 if is_selected else 0.9
	LockIcon.hide() if is_available and can_afford else LockIcon.show()
	SelectedIcon.show() if is_selected else SelectedIcon.hide()		
	
	is_selectable = is_available and can_afford
		
# ----------------------	

# ----------------------	
#var time_accumulator := 0.0
#var trigger_time := randf_range(0.5, 1.0)
#func _process(delta: float) -> void:
	#if !is_node_ready() or !apply_dyslexia:return
	#time_accumulator += delta
#
	#if time_accumulator >= trigger_time:
		#time_accumulator = 0.0
		#trigger_time = randf_range(0.5, 1.0)
		#on_data_update()
# ----------------------	
