extends AppWrapper

@onready var VList:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VList

var data:Dictionary = {} :
	set(val):
		data = val
		on_data_update()

var tracklist_unlocks:Dictionary = {}

# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	super._ready()
	on_data_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func after_ready() -> void:
	WindowUI.window_position = offset
	bind_events()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func on_data_update() -> void:
	if is_node_ready() and !data.is_empty():
		var list_data:Array[Dictionary] = []
		var author_list:Dictionary = {}
		var all_tracks:Array = []
		
		for index in data.music_track_list.size():
			var item:Dictionary = data.music_track_list[index]
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
						"track_list": data.music_track_list,
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
						"track_list": data.music_track_list,
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
	
	
