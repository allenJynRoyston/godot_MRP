extends GameContainer

@onready var Backdrop:ColorRect = $Backdrop
@onready var MainShape:ColorRect = $Control/MainShape

@onready var StageContainer:PanelContainer = $VBoxContainer/StageContainer
@onready var StageLabel:Label = $VBoxContainer/StageContainer/MarginContainer/HBoxContainer/StageLabel


func _ready() -> void:
	super._ready()

func start(phase_title:String) -> void:
	StageLabel.text = phase_title
	show()
	await U.set_timeout(1.0)

func end() -> void:
	StageLabel.text = ""
	hide()	
	await U.set_timeout(1.0)
