extends Control

@onready var ColorBG:ColorRect = $ColorRect
@onready var MainPanel:PanelContainer = $PanelContainer
@onready var MainMargin:MarginContainer = $PanelContainer/MarginContainer

@onready var EmergencyLabel:Label = $PanelContainer/MarginContainer/EmergencyLabel

var control_pos:Dictionary


# --------------------------------	
func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	ColorBG.color = Color(0, 0, 0, 0.8)
	set_process(false)
# --------------------------------	

# --------------------------------	
func activate() -> void:
	await U.tick()
	
	control_pos[MainPanel] = {
		"zero": 0,
		"show": 200,
		"hide": -MainMargin.size.y
	}
	
	MainPanel.position.y = control_pos[MainPanel].hide
# --------------------------------	

# --------------------------------	
func start() -> void:
	set_process(true)	
	U.tween_node_property(ColorBG, "color:a", 0, 3.0, 1.0)	
	U.tween_node_property(self, "modulate:a", 1, 0.5)
	await U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].show, 0.5, 1.0)
# --------------------------------	

# --------------------------------	
func zero() -> void:
	await U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].zero)	
# --------------------------------	


# --------------------------------	
func end() -> void:
	await U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].hide)
# --------------------------------	

# --------------------------------		
var time:float = 0
var speed:float = 5.0
func _process(delta: float) -> void:
	time += delta
	var value := (sin(time * speed) + 1.2) / 2.0  # Oscillates smoothly between 0 and 1
	EmergencyLabel.modulate = Color(1, 0, 0, value)
# --------------------------------
