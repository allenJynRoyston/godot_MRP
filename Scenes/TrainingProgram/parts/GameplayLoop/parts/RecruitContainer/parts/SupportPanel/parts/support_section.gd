@tool
extends PanelContainer

enum OPTIONS {STAFF, SECURITY, DCLASS}

@onready var TitleLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/TitleLabel
@onready var IconBtn:Control = $MarginContainer/VBoxContainer/HBoxContainer/IconBtn

@export var option:OPTIONS = OPTIONS.STAFF : 
	set(val):
		option = val
		on_option_update()

func _ready() -> void:
	on_option_update()

func on_option_update() -> void:
	if is_node_ready():
		match option:
			OPTIONS.STAFF:
				TitleLabel.text = "Staff"
				IconBtn.icon = SVGS.TYPE.STAFF
			OPTIONS.SECURITY:
				TitleLabel.text = "Security"
				IconBtn.icon = SVGS.TYPE.SECURITY
			OPTIONS.DCLASS:
				TitleLabel.text = "D-Class"
				IconBtn.icon = SVGS.TYPE.D_CLASS
