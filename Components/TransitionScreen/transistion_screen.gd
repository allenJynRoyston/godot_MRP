extends Control

@onready var TransitionPanel:PanelContainer = $PanelContainer
@onready var TextureRectUI:TextureRect = $PanelContainer/TextureRect


func _ready() -> void:
	await U.tick()
	TextureRectUI.hide()
	

func start(duration:float = 0.3) -> void:
	TextureRectUI.show()
	TextureRectUI.texture = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))
	TextureRectUI.material.set_shader_parameter("sensitivity", 0)
	await U.tween_range(0.0, 1.0, duration, func(val:float) -> void:
		TextureRectUI.material.set_shader_parameter("sensitivity", val)
	).finished
	

func end(duration:float = 0.3, return_delay:float = 0.3) -> void:
	await U.tween_range(1.0, 0.0, duration, func(val:float) -> void:
		TextureRectUI.material.set_shader_parameter("sensitivity", val)
	).finished
	await U.set_timeout(return_delay)
	
