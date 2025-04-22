@tool
extends CardDrawerClass

@onready var DrawerImage:TextureRect = $MarginContainer2/DrawerImage

const StaticShader:ShaderMaterial = preload("res://Shader/Static.tres")

@export var img_src:String = "" : 
	set(val):
		img_src = val
		on_img_src_update()
		
@export var use_static:bool = false : 
	set(val):
		use_static = val
		on_use_static_update()
		

func _ready() -> void:
	super._ready()
	on_img_src_update()
	on_use_static_update()
	
func on_img_src_update() -> void:
	if !is_node_ready():return
	DrawerImage.texture = CACHE.fetch_image(img_src)
	
func on_use_static_update() -> void:
	if !is_node_ready():return
	DrawerImage.material = StaticShader if use_static else null
