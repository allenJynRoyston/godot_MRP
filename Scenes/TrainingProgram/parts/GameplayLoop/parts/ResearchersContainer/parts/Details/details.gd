extends PanelContainer

@onready var ProfileCard:Control = $MarginContainer/VBoxContainer/ProfileCard

var researcher_details:Dictionary = {} : 
	set(val):
		researcher_details = val
		on_researcher_details_update()

# -------------------------------------------
func _ready() -> void:
	on_researcher_details_update()
# -------------------------------------------

# -------------------------------------------
func on_researcher_details_update() -> void:
	if !is_node_ready():return
	
	if researcher_details.is_empty():
		ProfileCard.hide()
	else:
		ProfileCard.show()
		ProfileCard.data = researcher_details
# -------------------------------------------
