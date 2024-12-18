@tool
extends PanelContainer

enum OPTIONS {STAFF, SECURITY, DCLASS}

@onready var TitleLabel:Label = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TitleLabel
@onready var IconBtn:Control = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/IconBtn
@onready var SectionImage:TextureRect = $VBoxContainer/SectionImage

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
				SectionImage.texture = CACHE.fetch_image("res://Media/images/researcher.jpg")
			OPTIONS.SECURITY:
				TitleLabel.text = "Security"
				IconBtn.icon = SVGS.TYPE.SECURITY
				SectionImage.texture = CACHE.fetch_image("res://Media/images/security.jpg")
			OPTIONS.DCLASS:
				TitleLabel.text = "D-Class"
				IconBtn.icon = SVGS.TYPE.D_CLASS
				SectionImage.texture = CACHE.fetch_image("res://Media/images/dclass.jpg")
