extends AppWrapper

@onready var VList:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VList

var music_track_list:Array = [] : 
	set(val):
		music_track_list = val
		on_music_track_list_update()

var tracklist_unlocks:Dictionary = {}

# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	super._ready()
	on_music_track_list_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func after_ready() -> void:
	WindowUI.window_position = offset
	WindowUI.onClick = onClick
	WindowUI.onCloseBtn = onCloseBtn
	WindowUI.onMaxBtn = onMaxBtn	
	WindowUI.onDragStart = onDragStart
	WindowUI.onDragEnd = onDragEnd
	WindowUI.onFocus = onFocus
	WindowUI.onBlur = onBlur
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func on_music_track_list_update() -> void:
	if is_node_ready():
		var list_data:Array[Dictionary] = []
		var author_list:Dictionary = {}
		var all_tracks:Array = []
		
		for index in music_track_list.size():
			var item:Dictionary = music_track_list[index]
			var metadata:Dictionary = item.metadata
			
			if metadata.author not in author_list:
				author_list[metadata.author] = []
			
			author_list[metadata.author].push_back({
				"get_details": func():
					return {
						"title": metadata.name
					},
				"is_new": func(_data:Dictionary):
					return false,
				"render_if": func():
					return item.unlocked.call(),
				"onClick": func(_data:Dictionary):
					GBL.music_data = {
						"track_list": music_track_list,
						"selected": index,
					},
			})

			all_tracks.push_back({
				"get_details": func():
					return {
						"title": metadata.name
					},
				"is_new": func(_data:Dictionary):
					return false,
				"render_if": func():
					return item.unlocked.call(),
				"onClick": func(_data:Dictionary):
					GBL.music_data = {
						"track_list": music_track_list,
						"selected": index,
					},
			})

		list_data.push_back({
			"section": "All Tracks",
			"opened": true,
			"items": all_tracks
		})
		
		for author in author_list:
			list_data.push_back({
				"section": author,
				"opened": false,
				"items": author_list[author]
			})

		VList.data = list_data
# ------------------------------------------------------------------------------	
	
	
