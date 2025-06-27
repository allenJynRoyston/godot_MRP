extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var IconBtn:Control = $MarginContainer/HBoxContainer/IconBtn

@onready var PropertyLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/PropertyLabel
@onready var TitleLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/TitleLabel
@onready var CostLabel:Label = $MarginContainer2/CostLabel


var index:int
var enabled:bool = false 

var render_if:Dictionary = {} : 
	set(val):
		render_if = val
		on_render_if_update()

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

var onClick:Callable = func() -> void:pass
var onHover:Callable = func() -> void:pass

# ----------------------
func _init() -> void:
	super._init()
	modulate = Color(1, 1, 1, 0)

func _ready() -> void:
	super._ready()
	on_data_update()
	on_render_if_update.call_deferred()	
	hint_title = "HINT"
	

func start(delay:float = 0) -> void:
	U.tween_node_property(IconBtn, 'static_color:a', 0.6, 0.3, delay)
	U.tween_node_property(self, 'modulate:a', 0.6, 0.3, delay)
	await U.set_timeout(0.1)
# ----------------------

# ----------------------	
func fade_out(delay:float = 0) -> void:
	U.tween_node_property(IconBtn, 'static_color:a', 0, 0.3, delay)
	await U.tween_node_property(self, 'modulate:a', 0, 0.3, delay)
# ----------------------		

# ----------------------	
func is_available_update() -> void:
	if !is_node_ready():return
	IconBtn.hide() if is_available else IconBtn.show()
	
	on_is_selected_update()
	on_data_update()
# ----------------------	

# ----------------------	
func on_is_selected_update() -> void:
	if !is_node_ready():return
	var stylebox:StyleBoxFlat = RootPanel.get("theme_override_styles/panel").duplicate()
	stylebox.bg_color = Color.RED if !is_available else (Color(0.337, 0.275, 1.0) if is_selected else Color(0.162, 0.162, 0.162))
	RootPanel.set('theme_override_styles/panel', stylebox)	
	
	modulate = Color(1, 1, 1, 1 if is_selected else 0.6)
	IconBtn.static_color.a = 1 if is_selected else 0.6
	
	if is_available:
		hint_description = "Estimated chance of success: %s%s." % [data.success_rate, "%"] 
	else:
		hint_description = "UNAVAILABLE" if render_if.is_empty() else render_if.hint_description


func on_render_if_update() -> void:
	if !is_node_ready():return
	
	if render_if.is_empty():
		is_available = true
		PropertyLabel.hide()
		CostLabel.hide()
		return
		
	if "cost" in render_if:
		CostLabel.text = str("[", render_if.cost.text, "]")
	else:
		CostLabel.hide()
		
	is_available = !render_if.is_available	
	PropertyLabel.text = "[%s]" % render_if.property
	
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	TitleLabel.text = data.title
# ----------------------
