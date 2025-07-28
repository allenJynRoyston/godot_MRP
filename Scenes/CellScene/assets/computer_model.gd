@tool
extends Node3D

@onready var ScreenTextureRect:TextureRect = $Monitor/ScreenTexture/SubViewport/TextureRect
@onready var OmniLight3d:OmniLight3D = $Monitor/OmniLight3D
@onready var SpriteTexture:Sprite3D = $Monitor/ScreenTexture

@export var viewport_feed:ViewportTexture : 
	set(val):
		viewport_feed = val
		on_viewport_feed_update()
		
@export var screen_glow_color:Color = Color.AQUA : 
	set(val):
		screen_glow_color = val
		on_screen_glow_color_update()
		
@export var enable_screen:bool = false : 
	set(val):
		enable_screen = val		
		on_enable_screen_update()

func _ready() -> void:
	on_enable_screen_update()
	
func on_viewport_feed_update() -> void:
	if !is_node_ready() or viewport_feed == null:return	
	ScreenTextureRect.texture = viewport_feed if enable_screen else null

func on_screen_glow_color_update() -> void:
	if !is_node_ready():return	
	OmniLight3d.light_color = screen_glow_color

func on_enable_screen_update() -> void:
	if !is_node_ready():return	
	OmniLight3d.hide() if !enable_screen else OmniLight3d.show()
	
	on_viewport_feed_update()
	on_screen_glow_color_update()
		
	if enable_screen:
		U.tween_node_property(SpriteTexture, "modulate", Color(1, 1, 1), 1)
		U.tween_node_property(OmniLight3d, "light_energy", 3, 0.3)		
	else:
		U.tween_node_property(SpriteTexture, "modulate", Color(0.35, 0.35, 0.4), 0.2)
		U.tween_node_property(OmniLight3d, "light_energy", 0, 0.3)
