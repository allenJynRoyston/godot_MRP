extends PanelContainer

@onready var MusicShaderTexture:TextureRect = $SubViewport/TextureRect
@onready var FinalOutput:TextureRect = $FinalOutput

func _init() -> void:
	SUBSCRIBE.subscribe_to_audio_data(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_audio_data(self)

func on_audio_data_update(new_val:Dictionary) -> void:
	if new_val.is_empty():return
	var new_audio_data:Array = new_val.data
	var music_position:float = new_val.pos
	var shader_material:ShaderMaterial = MusicShaderTexture.material.duplicate()	
	shader_material.set_shader_parameter("audio_data", new_audio_data)
	shader_material.set_shader_parameter("time", music_position)

	MusicShaderTexture.material = shader_material			
