extends Control

@onready var RollLabel:Label = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/RollLabel
@onready var RollIcon:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Control/RollIcon
@onready var SuccessPanel:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/SuccessPanel
@onready var FailurePanel:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/FailurePanel

# --------------------------------------------------------------------------------------------------		
func _init() -> void:
	modulate = Color(1, 1, 1, 0)
	GBL.subscribe_to_process(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)

func _ready() -> void:
	hide()
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------		
func set_title(title:String) -> void:
	RollLabel.text = title
# --------------------------------------------------------------------------------------------------		
	 
# --------------------------------------------------------------------------------------------------		
func use(is_success:bool, duration:float = 4.0) -> void:
	await U.tick()
	
	show()
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))	

	RollIcon.rotation_degrees = -720.0
	await U.tween_node_property(RollIcon, "rotation_degrees", 180 if is_success else 0, duration, 0, Tween.TRANS_SPRING, Tween.EASE_IN_OUT)
	
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.3, 0.5)	
	hide()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func on_process_update(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree(): return

	var normalized_rotation = fmod(RollIcon.rotation_degrees, 360.0)
	if normalized_rotation < 0.0:
		normalized_rotation += 360.0
	
	FailurePanel.modulate = Color(1, 1, 1, 1.0 if normalized_rotation >= 0.0 and normalized_rotation < 180.0 else 0.5)
	SuccessPanel.modulate = Color(1, 1, 1, 1.0 if normalized_rotation >= 180.0 and normalized_rotation < 360.0 else 0.5)
# --------------------------------------------------------------------------------------------------	
