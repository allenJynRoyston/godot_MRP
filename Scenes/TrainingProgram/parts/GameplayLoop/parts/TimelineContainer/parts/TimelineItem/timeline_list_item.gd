extends PanelContainer

@onready var IconBtn:Control = $HBoxContainer/IconBtn
@onready var DetailsContainer:VBoxContainer = $HBoxContainer/VBoxContainer
@onready var TitleLabel:Label = $HBoxContainer/VBoxContainer/TitleLabel
@onready var DescriptionLabel:Label = $HBoxContainer/VBoxContainer/DescriptionLabel

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		
var show_details:bool = false : 
	set(val): 
		show_details = val
		on_show_details_update()

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	SUBSCRIBE.subscribe_to_gameplay_conditionals(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_gameplay_conditionals(self)

func _ready() -> void:
	on_data_update()
	on_show_details_update()

# --------------------------------------------------------------------------------------------------	
func on_gameplay_conditionals_update(new_val:Dictionary) -> void:
	if !is_node_ready() or new_val.is_empty():return
	var make_visible:bool = new_val[CONDITIONALS.TYPE.ENABLE_TIMELINE].val		
	DetailsContainer.show() # if make_visible else DetailsContainer.hide()
# --------------------------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	TitleLabel.text = data.title
	DescriptionLabel.text = data.description
	IconBtn.icon = data.icon
	
func on_show_details_update() -> void:
	if !is_node_ready() or data.is_empty():return
	TitleLabel.show() if show_details else TitleLabel.hide()
	DescriptionLabel.show() if show_details else DescriptionLabel.hide()
# ------------------------------------------------------------------------------

# --------------------------------		
var time:float = 0
var speed:float = 5.0
func _process(delta: float) -> void:
	time += delta
	var value := (sin(time * speed) + 1.2) / 2.0  # Oscillates smoothly between 0 and 1
	IconBtn.icon_color = Color(1, 1 - value, 1 - value)
# --------------------------------
