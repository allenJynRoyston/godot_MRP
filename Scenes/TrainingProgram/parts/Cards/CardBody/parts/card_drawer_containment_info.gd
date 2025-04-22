@tool
extends CardDrawerClass

@onready var ContainedEffect:Control = $MarginContainer/MarginContainer/VBoxContainer/ContainedEffect
@onready var UncontainedEffect:Control = $MarginContainer/MarginContainer/VBoxContainer/UncontainedEffect

@onready var ContainedPanel:PanelContainer = $MarginContainer/MarginContainer/VBoxContainer/ContainedEffect/PanelContainer
@onready var UncontainedPanel:PanelContainer = $MarginContainer/MarginContainer/VBoxContainer/UncontainedEffect/PanelContainer

@onready var ContainedDescription:Label = $MarginContainer/MarginContainer/VBoxContainer/ContainedEffect/PanelContainer/MarginContainer/DescriptionLabel
@onready var UncontainedDescription:Label = $MarginContainer/MarginContainer/VBoxContainer/UncontainedEffect/PanelContainer/MarginContainer/DescriptionLabel

var metrics:Dictionary = {} : 
	set(val):
		metrics = val
		on_metrics_update()

var effects:Dictionary = {} : 
	set(val):
		effects = val
		on_effects_update()

func _ready() -> void:
	super._ready()
	on_metrics_update()
	
func on_metrics_update() -> void:
	if !is_node_ready() or metrics.is_empty():return
	var active_phase:bool = true

	var contained_stylebox:StyleBoxFlat = ContainedPanel.get("theme_override_styles/panel").duplicate()
	contained_stylebox.border_color = border_color if active_phase else border_color.darkened(0.5)
	ContainedPanel.set("theme_override_styles/panel", contained_stylebox)
	
	var uncontained_stylebox:StyleBoxFlat = UncontainedPanel.get("theme_override_styles/panel").duplicate()
	uncontained_stylebox.border_color = border_color if !active_phase else border_color.darkened(0.5)
	UncontainedPanel.set("theme_override_styles/panel", uncontained_stylebox)
	
	var contained_label_settings_copy:LabelSettings = ContainedDescription.label_settings.duplicate()
	var uncontained_label_settings_copy:LabelSettings = UncontainedDescription.label_settings.duplicate()
	
	contained_label_settings_copy.font_color = Color.WHITE if active_phase else Color(0.673, 0.673, 0.673)
	uncontained_label_settings_copy.font_color = Color.WHITE if !active_phase else Color(0.673, 0.673, 0.673)
	
	ContainedDescription.label_settings = contained_label_settings_copy
	UncontainedDescription.label_settings = uncontained_label_settings_copy
	
	ContainedEffect.modulate = Color(1, 1, 1, 1 if active_phase else 0.5)
	UncontainedEffect.modulate = Color(1, 1, 1, 1 if !active_phase else 0.5)

func on_effects_update() -> void:
	if !is_node_ready():return	
	ContainedDescription.text = effects.contained.description
	UncontainedDescription.text = effects.uncontained.description
