extends AppWrapper

@onready var ModComponent:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/ModComponent
@onready var LoadingComponent:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/LoadingComponent

enum SECTIONS { DIFFICULTY, PRODUCTION, ECONOMY }

var mods_data:Array[Dictionary] = [
	{
		"section": "Difficulty",
		"ref": SECTIONS.DIFFICULTY,
		"opened": true,
		"selected": [],
		"items": [
			{
				"get_details": func() -> Dictionary:
					return {
						"ref": Layout.MODS.DIFFICULTY_EASY,
						"title": "Easy",
						"description": "Containment failures are rare.  Bonus XP at 0%."
					},
				"render_if": func(details:Dictionary) -> bool:
					return false,
					#return app_props.get_modifications_unlocked.call()[details.ref],
			},
			{
				"get_details": func() -> Dictionary:
					return {
						"ref": Layout.MODS.DIFFICULTY_NORMAL,
						"title": "Normal",
						"description": "Containment failures are likely.  Bonus XP at +50%."
					},
				"render_if": func(details:Dictionary) -> bool:
					return false,
					#return app_props.get_modifications_unlocked.call()[details.ref],
			},
			{
				"get_details": func() -> Dictionary:
					return {
						"ref": Layout.MODS.DIFFICULTY_STORY,
						"title": "Story",
						"description": "Containment failures are frequent.  Bonus XP at +100%."
					},
				"render_if": func(details:Dictionary) -> bool:
					return false,
					#return app_props.get_modifications_unlocked.call()[details.ref],
			}
		]
	},
	{
		"section": "Production",
		"ref": SECTIONS.PRODUCTION,
		"opened": true,
		"selected": [],
		"items": [
			{
				"get_details": func() -> Dictionary:
					return {
						"ref": Layout.MODS.PRODUCTION_ONE,
						"title": "PRODUCTION_ONE",
						"description": "PRODUCTION_ONE description"
					},
				"render_if": func(details:Dictionary) -> bool:
					return false,
					#return app_props.get_modifications_unlocked.call()[details.ref],
			},
			{
				"get_details": func() -> Dictionary:
					return {
						"ref": Layout.MODS.PRODUCTION_TWO,
						"title": "PRODUCTION_TWO",
						"description": "PRODUCTION_TWO description"
					},
				"render_if": func(details:Dictionary) -> bool:
					return false,
					#return app_props.get_modifications_unlocked.call()[details.ref],
			},
			{
				"get_details": func() -> Dictionary:
					return {
						"ref": Layout.MODS.PRODUCTION_THREE,
						"title": "PRODUCTION_THREE",
						"description": "PRODUCTION_THREE description"
					},
				"render_if": func(details:Dictionary) -> bool:
					return false,
					#return app_props.get_modifications_unlocked.call()[details.ref],
			}
		]
	},
	{
		"section": "Economy",
		"ref": SECTIONS.ECONOMY,
		"opened": true,
		"selected": [],
		"items": [
			{
				"get_details": func() -> Dictionary:
					return {
						"ref": Layout.MODS.ECONOMY_ONE,
						"title": "ECONOMY_ONE",
						"description": "ECONOMY_ONE description"
					},
				"render_if": func(details:Dictionary) -> bool:
					return false,
					#return app_props.get_modifications_unlocked.call()[details.ref],
			},
			{
				"get_details": func() -> Dictionary:
					return {
						"ref": Layout.MODS.ECONOMY_TWO,
						"title": "ECONOMY_TWO",
						"description": "ECONOMY_TWO description"
					},
				"render_if": func(details:Dictionary) -> bool:
					return false,
					#return app_props.get_modifications_unlocked.call()[details.ref],
			},
			{
				"get_details": func() -> Dictionary:
					return {
						"ref": Layout.MODS.ECONOMY_THREE,
						"title": "ECONOMY_THREE",
						"description": "ECONOMY_THREE description"
					},
				"render_if": func(details:Dictionary) -> bool:
					return false,
					#return app_props.get_modifications_unlocked.call()[details.ref],
			}
		]
	}
]

# ------------------------------------------------------------------------------
func _ready() -> void:
	pass
	#LoadingComponent.delay = 0.3 if fast_load else 1.0
	#ModComponent.hide()
	#LoadingComponent.start()
	#await LoadingComponent.on_complete	
	#ModComponent.show()
	#
	#var mod_settings:Array = [] #app_props.get_mod_settings.call()
#
	#for item in mods_data:
		#var setting:Array = mod_settings.filter(func(d): return d.ref == item.ref)		
		#item.selected = [] if setting.size() == 0 else setting[0].selected

	## make sure has_read first so email_data can reference it
	#ModComponent.not_new = app_props.get_not_new.call()
	## assign email_data
	#ModComponent.mods_data = mods_data
	#
	## assign event to update has read
	#ModComponent.on_marked = app_events.on_marked	
	## assign event to updat eif state has changed
	#ModComponent.on_data_changed = func(new_state:Array) -> void:
		## not used, but can be used to capture the state of opened 
		#pass
	#
	## custom rules for click on a section
	#ModComponent.on_click = func(data:Dictionary) -> void:
		## can only be one selected for each section (maybe change later?)
		#mods_data[data.parent_index].selected = [data.index]
		#ModComponent.mods_data = mods_data
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func update_game_settings(new_game_settings:Dictionary) -> void:
	ModComponent.game_settings = new_game_settings
# ------------------------------------------------------------------------------
