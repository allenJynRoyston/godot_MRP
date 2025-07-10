extends GameContainer

@onready var Backdrop:ColorRect = $Backdrop
@onready var MainShape:ColorRect = $Control/MainShape

@onready var VHSLabel:Control = $VBoxContainer/StageContainer/MarginContainer/VhsLabel

func _ready() -> void:
	super._ready()

func start(phase_title:String) -> void:
	VHSLabel.title = phase_title
	show()
	await U.set_timeout(1.0)

func end() -> void:
	VHSLabel.title = ""
	hide()	
	await U.set_timeout(1.0)
