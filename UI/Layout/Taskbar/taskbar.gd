@tool
extends PanelContainer

@onready var TimeLabel:Label = $MarginContainer/HBoxContainer/HBoxContainer3/TimeDisplay/TimeLabel
@onready var MediaPlayer:HBoxContainer = $MarginContainer/HBoxContainer/HBoxContainer3/MediaPlayer

@export var show_media_player:bool = false : 
	set(val):
		show_media_player = val
		on_show_media_player_update()

var music_data:Dictionary = {} : 
	set(val): 
		music_data = val
		on_music_data_update()

# ------------------------------------------------------------------------------
func _ready() -> void:
	GBL.subscribe_to_music_player(self)
	on_music_data_update()
	on_show_media_player_update()
	
func _exit_tree() -> void:
	GBL.unsubscribe_to_music_player(self)
	
func on_show_media_player_update() -> void:
	if is_node_ready():
		MediaPlayer.show() if show_media_player else MediaPlayer.hide()
	
func on_music_data_update() -> void:
	show_media_player = !music_data.is_empty()
	MediaPlayer.data = music_data
# ------------------------------------------------------------------------------
