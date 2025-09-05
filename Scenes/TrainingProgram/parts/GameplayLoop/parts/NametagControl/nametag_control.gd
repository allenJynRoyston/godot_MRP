extends Control

@onready var TransitionScreen:Control = $TransitionScreen

@onready var NametagContainer:Control = $NametagContainer
@onready var CheckboxContainer:PanelContainer = $PanelContainer
@onready var CheckboxMargin:MarginContainer = $PanelContainer/MarginContainer
@onready var Checkbox:Control = $PanelContainer/MarginContainer/CheckBox

const NametagPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionContainer/parts/Nametag.tscn")

var control_pos:Dictionary
var is_animating:bool = false
var allow_input:bool = false
var show_nametags:bool = true : 
	set(val):
		show_nametags = val
		on_show_nametags_update()

# ------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)

func _ready() -> void:
	# CREATE NAMETAGS AND ADD THEM TO SCENE
	for index in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
		var new_node:Control = NametagPreload.instantiate()
		new_node.index = index
		NametagContainer.add_child(new_node)	
	
	await U.tick()
	control_pos[CheckboxContainer] = {
		"show": 0, 
		"hide": CheckboxMargin.size.x
	}

	reveal_controls(true)
# ------------------------------------------

# ------------------------------------------
func reveal_nametags(state:bool) -> void:
	for node in NametagContainer.get_children():
		node.reveal(state)

func reveal_controls(state:bool) -> void:
	allow_input = state
	await U.tween_node_property(CheckboxContainer, "position:x", control_pos[CheckboxContainer].show if state else control_pos[CheckboxContainer].hide)	

func change_camera_view(new_viewpoint:CAMERA.VIEWPOINT) -> void:
	match new_viewpoint:
		# ---------------
		CAMERA.VIEWPOINT.OVERHEAD:
			reveal_nametags(true)
			reveal_controls(false)
		# ---------------
		_:
			on_show_nametags_update()
			reveal_controls(true)
	
	for node in NametagContainer.get_children():
		node.change_camera_view(new_viewpoint)
# ------------------------------------------

# ------------------------------------------
func on_show_nametags_update() -> void:
	if !is_node_ready():return
	reveal_nametags(show_nametags)
	Checkbox.title = "DISPLAY NAMES (N)" if !show_nametags else "HIDE NAMES (N)"
	Checkbox.is_checked = show_nametags
	

func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or !allow_input or is_animating: 
		return

	var key:String = input_data.key		
	match key:
		"N":
			is_animating = true
			show_nametags = !show_nametags
			await TransitionScreen.start(0.1, true)
			is_animating = false
# ------------------------------------------
