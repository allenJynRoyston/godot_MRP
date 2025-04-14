extends PanelContainer

@onready var TextureRectUI:TextureRect = $TextureRect

@export var background_image:Texture2D :
	set(val):
		background_image = val
		on_background_image_update()
		
func _ready() -> void:
	on_background_image_update()
	
func on_background_image_update() -> void:
	if !is_node_ready():return
	TextureRectUI.texture = background_image
