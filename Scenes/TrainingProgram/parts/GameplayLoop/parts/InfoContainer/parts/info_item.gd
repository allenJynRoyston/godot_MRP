@tool
extends PanelContainer

@onready var Title:Label = $MarginContainer/HBoxContainer/Title
@onready var Status:Label = $MarginContainer/HBoxContainer/Status

@export var title:String = "" : 
	set(val):
		title = val
		on_title_update()

@export var status:String = "" : 
	set(val):
		status = val
		on_status_update()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_title_update()
	on_status_update()

func on_title_update() -> void:
	if !is_node_ready():return
	Title.text = "[%s]" % [title]
	
func on_status_update() -> void:
	if !is_node_ready():return
	Status.text = status
