extends Control

@onready var TitlePanel:PanelContainer = $TitlePanel
@onready var TitleMargin:MarginContainer = $TitlePanel/MarginContainer
@onready var TitleLabel:Label = $TitlePanel/MarginContainer/VBoxContainer/MarginContainer/TitleLabel

@onready var ImagePanel:PanelContainer = $ImagePanel
@onready var ImageMargin:MarginContainer = $ImagePanel/MarginContainer
@onready var ImageTextRect:TextureRect = $ImagePanel/MarginContainer/VBoxContainer/ImageTextRect

var control_pos:Dictionary

var is_showing:bool

var img_src:String = "" : 
	set(val):
		img_src = val
		on_img_src_update()

var title:String = "" : 
	set(val):
		title = val
		on_title_update()

func _ready() -> void:
	on_img_src_update()
	on_title_update()

	await U.tick()
	
	control_pos[TitlePanel] = {
		"show": 0,
		"hide": TitlePanel.size.x
	}
	
	control_pos[ImagePanel] = {
		"show": 0,
		"hide": ImageMargin.size.x
	}	
	
	ImagePanel.position.x = control_pos[ImagePanel].hide
	check_state()

func on_img_src_update() -> void:
	if !is_node_ready():return
	ImageTextRect.texture = CACHE.fetch_image(img_src)

func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title

func reveal(state:bool, delay:float = 0.0) -> void:
	await U.tween_node_property(TitlePanel, "position:x", control_pos[TitlePanel].show if state else control_pos[TitlePanel].hide, 0.3 if !state else 0.7, delay, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	U.debounce(str(self, "_check_state"), check_state)

func reveal_image(state:bool, delay:float = 0.2) -> void:
	await U.tween_node_property(ImagePanel, "position:x", control_pos[ImagePanel].show if state else control_pos[TitlePanel].hide, 0.5 if !state else 0.5, delay, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	U.debounce(str(self, "_check_state"), check_state)

func check_state() -> void:
	is_showing = title != "" and img_src != ""
	
	
	
