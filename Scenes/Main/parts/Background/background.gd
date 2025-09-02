extends PanelContainer

@onready var MusicShaderTexture:TextureRect = $SubViewport/TextureRect
@onready var FinalOutput:TextureRect = $FinalOutput

@onready var shader_material:ShaderMaterial = MusicShaderTexture.material.duplicate()	

@export var force_show:bool = false 

func _init() -> void:
	SUBSCRIBE.subscribe_to_audio_data(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_audio_data(self)

func _ready() -> void:
	await U.tick()
	var os_settings:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_settings	
	
	MusicShaderTexture.material = shader_material
	show() if os_settings.audio_visulizer_in_background or force_show else hide()	

func on_audio_data_update(new_val:Dictionary) -> void:
	if !is_node_ready() or new_val.is_empty():return
	var new_audio_data:Array = new_val.data
	var music_position:float = new_val.pos
	shader_material.set_shader_parameter("audio_data", new_audio_data)
	shader_material.set_shader_parameter("time", music_position)
	
