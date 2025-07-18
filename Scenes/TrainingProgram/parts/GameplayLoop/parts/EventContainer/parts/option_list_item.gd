extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var IconBtn:Control = $MarginContainer/HBoxContainer/SVGIcon

@onready var PropertyLabel:Label = $Control/PropertyLabel
@onready var TitleLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/TitleLabel

var index:int
var enabled:bool = false 
var is_paranoid:bool = false

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
				
var apply_dyslexia:bool = false
var allow_for_hint:bool = false

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
	U.tween_node_property(IconBtn, 'icon_color:a', 0.6, 0.3, delay)
	U.tween_node_property(self, 'modulate:a', 0.6, 0.3, delay)
	await U.set_timeout(0.1)
# ----------------------

# ----------------------	
func fade_out(delay:float = 0) -> void:
	U.tween_node_property(IconBtn, 'icon_color:a', 0, 0.3, delay)
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
	var use_color:Color = COLORS.disabled_color if !is_available else COLORS.primary_color
	use_color.a = 1 if is_selected else 0.75
	
	stylebox.bg_color = use_color
	RootPanel.set('theme_override_styles/panel', stylebox)	
	
	modulate = Color(1, 1, 1, 1 if is_selected else 0.6)
	IconBtn.icon_color.a = 1 if is_selected else 0.6
	
	if hint_description == "":
		if is_available:
			hint_description = "" if ("success_rate" not in data or !allow_for_hint) else "Estimated chance of success: %s%s." % [data.success_rate, "%"] 
		else:
			hint_description = "UNAVAILABLE" if render_if.is_empty() else render_if.hint_description


func on_render_if_update() -> void:
	if !is_node_ready():return
	
	if render_if.is_empty() or is_paranoid:
		is_available = true
		PropertyLabel.hide()
		return
	
	if "lockout" in render_if and render_if.lockout:
		is_available = false
		PropertyLabel.text = "UNAVAILABLE"
		return
		
	is_available = render_if.is_available	 
	PropertyLabel.text = "%s (%s)" % [render_if.property, render_if.current_amount]
	
	
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	TitleLabel.text = "SUFFERING FROM PARANOIA..." if is_paranoid else U.simulate_dyslexia(data.title) if apply_dyslexia else data.title
# ----------------------


var time_accumulator := 0.0
var trigger_time := randf_range(0.5, 1.0)
func _process(delta: float) -> void:
	if !is_node_ready() or !apply_dyslexia:return
	time_accumulator += delta

	if time_accumulator >= trigger_time:
		time_accumulator = 0.0
		trigger_time = randf_range(0.5, 1.0)
		on_data_update()
