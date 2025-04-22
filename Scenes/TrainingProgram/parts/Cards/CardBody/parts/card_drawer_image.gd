@tool
extends CardDrawerClass

@onready var DrawerImage:TextureRect = $MarginContainer2/DrawerImage

@export var img_src:String = "" : 
	set(val):
		img_src = val
		on_img_src_update()
		

func _ready() -> void:
	super._ready()
	on_img_src_update()
	
func on_img_src_update() -> void:
	if !is_node_ready():return
	DrawerImage.texture = CACHE.fetch_image(img_src)
