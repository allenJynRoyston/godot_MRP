extends Control

@onready var TransitionPanel:PanelContainer = $PanelContainer
@onready var TextureRectUI:TextureRect = $PanelContainer/TextureRect

@export var transition_type:TYPE = TYPE.DISSOLVE

enum TYPE {DISSOLVE, GLITCH }

const DissolveMaterial:ShaderMaterial = preload("res://CanvasShader/Dissolve/Dissolve.tres")
const ScreenMeltMaterial:ShaderMaterial = preload("res://CanvasShader/ScreenMelt/screenMelt.tres")

func _ready() -> void:
	await U.tick()
	TextureRectUI.hide()
	
func start(duration:float = 0.3, clear_after:bool = false, viewpoint_ref:int = REFS.MAIN_ACTIVE_VIEWPORT) -> void:
	TextureRectUI.texture = U.get_viewport_texture(GBL.find_node(viewpoint_ref))
	TextureRectUI.show()
	
	match transition_type:
		TYPE.DISSOLVE:
			TextureRectUI.material = DissolveMaterial.duplicate(true)
			TextureRectUI.material.set_shader_parameter("sensitivity", 0)
			await U.tween_range(0.0, 1.0, duration, func(val:float) -> void:
				TextureRectUI.material.set_shader_parameter("sensitivity", val)
			).finished
		TYPE.GLITCH:
			TextureRectUI.material = ScreenMeltMaterial.duplicate(true)
			TextureRectUI.material.set_shader_parameter("transition", 0)
			await U.tween_range(0.0, 1.0, duration, func(val:float) -> void:
				TextureRectUI.material.set_shader_parameter("transition", val)
			).finished

	if clear_after:		
		TextureRectUI.texture = null
		TextureRectUI.hide()

func end(duration:float = 0.3, return_delay:float = 0.3) -> void:
	await U.tween_range(1.0, 0.0, duration, func(val:float) -> void:
		match transition_type:
			TYPE.DISSOLVE:		
				TextureRectUI.material.set_shader_parameter("sensitivity", val)
			TYPE.GLITCH:
				TextureRectUI.material.set_shader_parameter("transition", val)
	).finished

	await U.set_timeout(return_delay)
	
