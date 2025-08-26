@tool
extends MouseInteractions

@onready var RootTextureRect:TextureRect  = $"."
@onready var Subviewport:SubViewport = $SubViewport
@onready var MainPanel:PanelContainer = $SubViewport/PanelContainer

@onready var HeaderPanel:PanelContainer = $SubViewport/PanelContainer/VBoxContainer/VBoxContainer/Header
@onready var ContentPanel:PanelContainer = $SubViewport/PanelContainer/VBoxContainer/VBoxContainer/PanelContainer

@onready var HeaderLabel:Label = $SubViewport/PanelContainer/VBoxContainer/VBoxContainer/Header/MarginContainer/HBoxContainer/HeaderLabel
@onready var LockIcon:Control = $SubViewport/PanelContainer/VBoxContainer/VBoxContainer/Header/MarginContainer/HBoxContainer/LockContainer/LockIcon
@onready var SelectedIcon:Control = $SubViewport/PanelContainer/VBoxContainer/VBoxContainer/Header/MarginContainer/HBoxContainer/SelectedIcon

@onready var TitleLabel:Label = $SubViewport/PanelContainer/VBoxContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var DescriptionLabel:Label = $SubViewport/PanelContainer/VBoxContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Description
@onready var OutcomeLabel:Label = $SubViewport/PanelContainer/VBoxContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/OutcomeLabel
@onready var ConditionalLabel:Label = $SubViewport/PanelContainer/VBoxContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ConditionalLabel

@onready var CostPanel:PanelContainer = $SubViewport/PanelContainer/VBoxContainer/Cost/PanelContainer
@onready var Costs:VBoxContainer = $SubViewport/PanelContainer/VBoxContainer/Cost
@onready var CostList:VBoxContainer = $SubViewport/PanelContainer/VBoxContainer/Cost/PanelContainer/MarginContainer/CostList

@onready var Requires:VBoxContainer = $SubViewport/PanelContainer/VBoxContainer/Requires
@onready var RequiresList:VBoxContainer = $SubViewport/PanelContainer/VBoxContainer/Requires/PanelContainer/MarginContainer/RequiresList
@onready var RequiresCheckbox:Control = $SubViewport/PanelContainer/VBoxContainer/Requires/PanelContainer/MarginContainer/RequiresList/HBoxContainer/RequiresCheckbox
@onready var RequiresLabel:Label = $SubViewport/PanelContainer/VBoxContainer/Requires/PanelContainer/MarginContainer/RequiresList/HBoxContainer/RequiresLabel

@onready var content_stylebox_copy:StyleBoxFlat = ContentPanel.get("theme_override_styles/panel").duplicate()
@onready var header_stylebox_copy:StyleBoxFlat = HeaderPanel.get("theme_override_styles/panel").duplicate()
@onready var cost_stylebox_copy:StyleBoxFlat = CostPanel.get("theme_override_styles/panel").duplicate()

@onready var title_label_setting:LabelSettings = TitleLabel.get("label_settings").duplicate()
@onready var outcome_label_setting:LabelSettings = OutcomeLabel.get("label_settings").duplicate()
@onready var cost_item_label_setting:LabelSettings = TitleLabel.get("label_settings").duplicate()
@onready var requires_label_setting:LabelSettings = RequiresLabel.get("label_settings").duplicate()

@onready var root_texture_material:ShaderMaterial = RootTextureRect.material.duplicate()


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
	CostPanel.set("theme_override_styles/panel", cost_stylebox_copy)
	TitleLabel.set("label_settings", title_label_setting)
	OutcomeLabel.set("label_settings", outcome_label_setting)
	RequiresLabel.set("label_settings", requires_label_setting)
	RootTextureRect.material = root_texture_material
	
	for node in CostList.get_children():
		node.queue_free()
	
	hint_title = "HINT"
	on_is_selected_update()
	

func start(delay:float = 0) -> void:
	pass
# ----------------------

# ----------------------	
func fade_out(delay:float = 0) -> void:
	await U.set_timeout(delay)
	await U.tween_range(0, 1, 0.5, func(val:float) -> void:
		root_texture_material.set_shader_parameter("transition", val)	
	).finished
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
		
	if data.has("requires"):		
		Requires.show()
		is_available = RequiresCheckbox.is_checked
		requires_label_setting.font_color = COLORS.disabled_color if !is_available else COLORS.primary_black		
		
		RequiresCheckbox.is_checked = data.requires.check.call()
		RequiresCheckbox.is_negative = !is_available
		RequiresLabel.text = data.requires.title		
	else:
		Requires.hide()

	
	if data.has("impact"):
		Costs.hide()	
		if data.impact.has("conditional"):
			var new_node:Control = Label.new()
			var conditional_data:Dictionary = CONDITIONALS.return_data(data.impact.conditional)
			ConditionalLabel.text = conditional_data.description
			ConditionalLabel.show()
		else:
			ConditionalLabel.hide()
		
		if data.impact.has("buff") and !built_once:
			Costs.show()	
			for ref in data.impact.buff:
				var new_node:Control = Label.new()
				var buff_data:Dictionary = BASE_UTIL.return_buff(ref)
				var label_setting:LabelSettings = cost_item_label_setting.duplicate()
				label_setting.font_color = Color.DARK_GREEN
				new_node.label_settings = label_setting				
				new_node.text = buff_data.name
				CostList.add_child(new_node)	
				
		if data.impact.has("debuff") and !built_once:
			Costs.show()	
			for ref in data.impact.debuff:
				var new_node:Control = Label.new()
				var buff_data:Dictionary = BASE_UTIL.return_debuff(ref)
				var label_setting:LabelSettings = cost_item_label_setting.duplicate()
				label_setting.font_color = COLORS.disabled_color
				new_node.label_settings = label_setting	
				new_node.text = buff_data.name
				CostList.add_child(new_node)
		
		if data.impact.has("currency") and !built_once:
			Costs.show()	
			for ref in data.impact.currency:
				var amount:int = data.impact.currency[ref]
				var new_node:Control = Label.new()
				var resource_data:Dictionary = RESOURCE_UTIL.return_currency(ref)
				var label_setting:LabelSettings = cost_item_label_setting.duplicate()
				label_setting.font_color = COLORS.disabled_color if amount < 0 else Color.DARK_GREEN
				new_node.label_settings = label_setting				
				new_node.text = "%s%s %s" % ["+" if amount >= 0 else "", amount, resource_data.name]
				CostList.add_child(new_node)		
		
		if data.impact.has("metrics") and !built_once:
			Costs.show()	
			for ref in data.impact.metrics:
				var amount:int = data.impact.metrics[ref]
				var new_node:Control = Label.new()
				var resource_data:Dictionary = RESOURCE_UTIL.return_metric(ref)
				var label_setting:LabelSettings = cost_item_label_setting.duplicate()
				new_node.label_settings = label_setting	
				label_setting.font_color = COLORS.disabled_color if amount < 0 else Color.DARK_GREEN
				new_node.text = "%s%s %s" % ["+" if amount >= 0 else "", amount, resource_data.name]
				CostList.add_child(new_node)

		built_once = true
	else:
		Costs.hide()
		ConditionalLabel.hide()
		
	# update content stylebox
	content_stylebox_copy.bg_color = Color.DARK_GRAY if !is_selected else COLORS.primary_color 
	cost_stylebox_copy.bg_color = Color.DARK_GRAY if !is_selected else COLORS.primary_color 
	
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
func _process(delta: float) -> void:
	if !is_node_ready():return
	Subviewport.size = MainPanel.size + Vector2(5, 5)
# ----------------------	
