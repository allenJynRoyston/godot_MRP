extends GameContainer

@onready var Backdrop:ColorRect = $Backdrop
@onready var MainShape:ColorRect = $Control/MainShape

@onready var StageContainer:PanelContainer = $VBoxContainer/StageContainer
@onready var StageLabel:Label = $VBoxContainer/StageContainer/MarginContainer/HBoxContainer/StageLabel

var show_pos:Dictionary = {}
var hide_pos:Dictionary = {}


func _ready() -> void:
	super._ready()
	# hides
	#StageContainer.modulate = Color(1, 1, 1, 0)

func start(phase_title:String) -> void:
	StageLabel.text = phase_title
	show()
	await U.set_timeout(1.0)
	StageLabel.text = ""
	hide()
	
