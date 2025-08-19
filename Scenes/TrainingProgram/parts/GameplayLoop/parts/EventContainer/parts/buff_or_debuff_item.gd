extends VBoxContainer

@onready var Title:Label = $Title
@onready var Description:Label = $Description

@export var title:String = "" : 
	set(val):
		title = val
		on_title_update()
		
@export var description:String = "" : 
	set(val):
		description = val
		on_description_update()
		
func _ready() -> void:
	on_title_update()
	on_description_update()
	
func on_title_update() -> void:
	if !is_node_ready():return
	Title.text = title

func on_description_update() -> void:
	if !is_node_ready():return
	Description.text = description
