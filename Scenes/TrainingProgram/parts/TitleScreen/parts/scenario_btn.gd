extends BtnBase

@onready var RootPanel:PanelContainer = $"."
@onready var TitleLabel:Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var DescriptionLabel:Label = $MarginContainer/VBoxContainer/VBoxContainer/DescriptionLabel
@onready var RewardList:VBoxContainer = $MarginContainer/VBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/RewardList

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")


@export var distance_from_center:int : 
	set(val):
		distance_from_center = val
		on_distance_from_center_update()
		
var scenario_ref:int = -1 : 
	set(val):
		scenario_ref = val
		on_scenario_ref_update()
		
var is_completed:bool = false : 
	set(val):
		is_completed = val
		on_scenario_ref_update()
		

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()

func _exit_tree() -> void:
	super._exit_tree()

func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	on_distance_from_center_update()
	on_scenario_ref_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_scenario_ref_update() -> void:
	if !is_node_ready() or scenario_ref == -1:return
	var scenario_details:Dictionary = SCENARIO_UTIL.get_scenario_data(scenario_ref)
	var awarded_rooms:Array = SCENARIO_UTIL.get_awarded_rooms(scenario_ref, true)

	TitleLabel.text = 'LOCKED' if is_disabled else scenario_details.title
	DescriptionLabel.text = scenario_details.description
	
	var stylebox_clone:StyleBoxFlat = RootPanel.get('theme_override_styles/panel').duplicate()
	stylebox_clone.bg_color = Color(0.138, 0.0, 0.521, 0.796) if !is_disabled else Color(0.358, 0.0, 0.07, 0.796)
	RootPanel.set('theme_override_styles/panel', stylebox_clone)

	for child in RewardList.get_children():
		child.queue_free()
	
	for award in awarded_rooms:
		var text_btn:Control = TextBtnPreload.instantiate()
		text_btn.is_hoverable = false
		text_btn.icon = SVGS.TYPE.NONE
		text_btn.title = award.name
		text_btn.custom_minimum_size = Vector2(0, 25)
		RewardList.add_child(text_btn)
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func on_distance_from_center_update() -> void:
	if !is_node_ready():return
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1.0 - (distance_from_center * 0.3)), 0.3)
	
	var stylebox_clone:StyleBoxFlat = RootPanel.get('theme_override_styles/panel').duplicate()
	stylebox_clone.border_color = Color.WHITE if distance_from_center == 0 else Color.BLACK
	RootPanel.set('theme_override_styles/panel', stylebox_clone)
# ------------------------------------------------------------------------------
