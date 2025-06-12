extends PanelContainer

@onready var TextureRectUI:TextureRect = $MarginContainer2/TextureRect
@onready var TransitionScreen:Control = $TransitionScreen

@export var use_transition:bool = false: 
	set(val):
		use_transition = val
		on_use_transition_update()

@export var background_image:Texture2D :
	set(val):
		background_image = val
		on_background_image_update()
		
func _ready() -> void:
	hide()
	on_background_image_update()
	
func on_use_transition_update() -> void:
	if !is_node_ready():return
	TransitionScreen.hide() if !use_transition else TransitionScreen.show()
	
func on_background_image_update() -> void:
	if !is_node_ready():return
	TextureRectUI.texture = background_image
	

func _on_visibility_changed() -> void:
	if !is_node_ready():return	
	if is_visible_in_tree() and use_transition:
		TransitionScreen.start()
