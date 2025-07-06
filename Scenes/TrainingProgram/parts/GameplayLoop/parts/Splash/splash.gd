@tool
extends Control

@onready var ColorBG:ColorRect = $ColorRect
@onready var MainPanel:PanelContainer = $PanelContainer
@onready var MainLabel:Label = $PanelContainer/MarginContainer/EmergencyLabel
@onready var MainMargin:MarginContainer = $PanelContainer/MarginContainer

@onready var EmergencyLabel:Label = $PanelContainer/MarginContainer/EmergencyLabel

var control_pos:Dictionary

@export var title:String = "CONTAINMENT BREACH IN PROGRESS" : 
	set(val):
		title = val
		on_title_update()

@export var v_offset:int = 0


# --------------------------------	
func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	set_process(false)
	on_title_update()
# --------------------------------	

# --------------------------------	
func activate() -> void:
	await U.tick()
	
	control_pos[MainPanel] = {
		"zero": 0,
		"show": 200  + v_offset,
		"hide": -MainMargin.size.y
	}
	
	MainPanel.position.y = control_pos[MainPanel].hide
	
	print(control_pos[MainPanel])
# --------------------------------	

# --------------------------------	
func start(use_zero:bool = false, duration:float = 0.3, delay:float = 0.0) -> void:
	set_process(true)	
	await U.tick()
	
	U.tween_node_property(self, "modulate:a", 1, duration)
	
	await U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].zero if use_zero else control_pos[MainPanel].show, duration, delay)
# --------------------------------	

# --------------------------------	
func on_title_update() -> void:
	if !is_node_ready():return
	MainLabel.text = title
# --------------------------------	

# --------------------------------	
func zero() -> void:
	await U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].zero)	
# --------------------------------	

# --------------------------------	
func end() -> void:
	await U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].hide)
	queue_free()
# --------------------------------	

# --------------------------------		
var time:float = 0
var speed:float = 5.0
func _process(delta: float) -> void:
	time += delta
	var value := (sin(time * speed) + 1.2) / 2.0  # Oscillates smoothly between 0 and 1
	EmergencyLabel.modulate = Color(1, 0, 0, value)
# --------------------------------
