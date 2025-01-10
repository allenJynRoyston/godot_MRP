extends PanelContainer

@onready var ListContainer:VBoxContainer = $ActionsList/PanelContainer/MarginContainer/VBoxContainer/ListContainer

enum LIST_TYPE {CONTAINED, AVAILABLE}

const ActionItemBtnPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ContainmentContainer/parts/SCPActions/parts/ActionItemBtn/ActionItemBtn.tscn")

var list_type:LIST_TYPE = LIST_TYPE.AVAILABLE : 
	set(val):
		list_type = val
		on_list_type_update()

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		
var available_actions:Array = [
	{
		"title": "Contain",
		"title_icon": SVGS.TYPE.TARGET,
		"bulletpoints": [
			{
				"header": "Placement",
				"list": [
					{
						"icon": SVGS.TYPE.CONTAIN, 
						"text": func() -> String:
							return "Requires [] containment cell.",
					}
				]
			},
			{
				"header": "Bonus",
				"list": [
					{
						"icon": SVGS.TYPE.MONEY, 
						"text": func() -> String:
							return "+[] inital containment bonus",
					},
					{
						"icon": SVGS.TYPE.MONEY, 
						"text": func() -> String:
							return "+[] bonus containment",
					}					
				]
			}				
		],
		"onClick": func() -> void:
			print("show map and select location."),
	},
	{
		"title":"Reject",
		"title_icon": SVGS.TYPE.DELETE,
		"onClick": func() -> void:
			print("show map and select location."),
	}		
]

# ------------------------------------------------------------
func _ready() -> void:
	on_data_update()
	on_list_type_update()
# ------------------------------------------------------------

# ------------------------------------------------------------
func on_list_type_update() -> void:
	if !is_node_ready():return
	update_list()
# ------------------------------------------------------------	


# ------------------------------------------------------------
func on_data_update() -> void:
	if !is_node_ready():return
	update_list()
# ------------------------------------------------------------

# ------------------------------------------------------------
func update_list() -> void:
	for child in ListContainer.get_children():
		child.queue_free()
	
	if data.is_empty():return
	
	match list_type:
		LIST_TYPE.CONTAINED:
			for action_data in available_actions:
				var new_btn:Control = ActionItemBtnPreload.instantiate()
				new_btn.data = action_data
				ListContainer.add_child(new_btn)
				
		LIST_TYPE.AVAILABLE:
			for action_data in available_actions:
				var new_btn:Control = ActionItemBtnPreload.instantiate()
				new_btn.data = action_data
				ListContainer.add_child(new_btn)	
# ------------------------------------------------------------
