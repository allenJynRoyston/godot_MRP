extends PanelContainer

@onready var MusicShaderTexture:TextureRect = $SubViewport/TextureRect
@onready var FinalOutput:TextureRect = $FinalOutput

func _init() -> void:
	GBL.register_node(REFS.AUDIO_BG, self)	
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.AUDIO_BG)	

func update_music_shader(new_audio_data:Array, music_position:float) -> void:
	var shader_material:ShaderMaterial = MusicShaderTexture.material.duplicate()	
	shader_material.set_shader_parameter("audio_data", new_audio_data)
	shader_material.set_shader_parameter("time", music_position)

	MusicShaderTexture.material = shader_material			
