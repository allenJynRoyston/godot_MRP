extends PanelContainer

@onready var BG:TextureRect = $BG
@onready var TaskbarCornerPanel:PanelContainer = $HeaderControls/PanelContainer/PanelContainer/Control/TaskbarCornerPanel
@onready var AudioVisualizer:PanelContainer = $AudioVisualizer

@onready var BtnControls:Control = $BtnControl
@onready var Taskbar:Control = $Taskbar
@onready var PauseContainer:PanelContainer = $PauseContainer
@onready var TransitionScreen:Control = $TransitionScreen
@onready var RunningAppsContainer:Control = $RunningAppsContainer

@onready var OptionsMenu:Control = $OptionsMenu

@onready var LoginPanel:PanelContainer = $LoginControl/PanelContainer
@onready var LoginMargin:MarginContainer = $LoginControl/PanelContainer/MarginContainer

@onready var DesktopGrid:Control =  $Desktop/MarginContainer/DesktopGrid
@onready var LoginContainer:PanelContainer = $NodeControl/LoginContainer
@onready var Installer:PanelContainer = $NodeControl/Installer
@onready var NotificationContainer:PanelContainer = $NodeControl/NotificationContainer

@onready var HeaderControls:Control = $HeaderControls
#@onready var TaskbarBtn:BtnBase = $HeaderControls/PanelContainer/MarginContainer/VBoxContainer/TaskbarBtn

const AppItemPreload:PackedScene = preload("res://Scenes/Main/parts/OS/AppItem/AppItem.tscn")
const SiteDirectorTrainingAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/SiteDirectorTrainingApp/SiteDirectorTrainingApp.tscn")
const EmailAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/EmailApp/EmailApp.tscn")
const MediaPlayerAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/MediaPlayerApp/MediaPlayerApp.tscn")
const StoreAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/StoreApp/StoreApp.tscn")

enum APPS {
	SITE_DIRECTOR_TRAINING_PROGRAM, 
	SETTINGS, 
	MUSIC_PLAYER, 
	EMAIL, 
	STORE
}

# -----------------------------------
#region SAVABLE DATA
var os_setting:Dictionary = {}
var apps_installing:Array = []
var has_started:bool = false

var previous_desktop_index:int = 0
#endregion
# -----------------------------------

# -----------------------------------
#region LOCAL DATA
func update_media_options(_options:Dictionary) -> void:
	for key in _options:
		var val:bool = _options[key]
		if os_setting.media_player.has(key):
			os_setting.media_player[key] = val
	
	AudioVisualizer.show() if os_setting.media_player.enable_visulizer else AudioVisualizer.hide()
	TransitionScreen.start(0.3, true)	
	save_state()
	
func update_settings_options(_options:Dictionary) -> void:
	for key in _options:
		var val:bool = _options[key]
		if GBL.active_user_profile.graphics.shaders.has(key):
			GBL.active_user_profile.graphics.shaders[key] = val
	
	# update settings
	check_graphics_settings()
	save_state()

var app_list:Array[Dictionary] = [
	# ----------
	#{
		#"details": {
			#"title": "LOCK",
			#"icon": SVGS.TYPE.BACK,
		#},
		#"installed": func() -> bool:
			#return true,
		#"events": {
			#"open": func(data:Dictionary) -> void:
				#pause(),
		#}
	#},
	# ----------
	
	# ----------
	{
		"details": {
			"ref": APPS.SITE_DIRECTOR_TRAINING_PROGRAM,
			"title": "Site Director Training Program",
			"icon": SVGS.TYPE.EXE_FILE,
			"app": SiteDirectorTrainingAppPreload,
		},
		"installed": func() -> bool:
			return true,
		"events": {
			"close": func() -> void:
				close_app(APPS.SITE_DIRECTOR_TRAINING_PROGRAM),			
			"open": func(data:Dictionary) -> void:
				var options:Array = [
					{
						"title": "ENABLE TUTORIAL", 
						"key": "is_tutorial",
						"value": true,
						"hint_description": "Enable/Disable tutorial mode."
					}
				]
				
				if data.ref not in running_apps_list.map(func(i): return i.ref):
					open_options(
						# ------- BTNS
						[
							{
								"title": "LAUNCH...",
								"onClick": func(_options:Dictionary) -> void:
									open_app(data, _options),
							},
							{
								"title": "OPEN INSTRUCTION MANUAL",
								"onClick": func(_options:Dictionary) -> void:
									pass,
							}
						],
						# ------- OPTIONS
						options
					)
				else:
					open_options(
						# ------- BTNS
						[
							{
								"title": "RESUME",
								"onClick": func(_options:Dictionary) -> void:
									open_app(data),
							},
							{
								"title": "OPEN INSTRUCTION MANUAL",
								"onClick": func(_options:Dictionary) -> void:
										pass,
							},							
							{
								"title": "FORCE QUIT",
								"onClick": func(_options:Dictionary) -> void:
									close_app(data.ref),
							}
						]
					),
		}
	},
	# ----------	
	
	# ----------
	{
		"details": {
			"ref": APPS.EMAIL,
			"title": "Netmail",
			"icon": SVGS.TYPE.EMAIL,
			"app": EmailAppPreload,
		},
		"installed": func() -> bool:
			return true,
		"events": {
			"open": func(data:Dictionary) -> void:
				open_app(data),
			"close": func() -> void:
				close_app(APPS.EMAIL),
			"install": func(data:Dictionary) -> void:
				Installer.add_item(data.installer_data),
			"fetch_read_emails": func() -> Array:
				return os_setting.read_emails,
			"mark": func(index:int) -> void:
				if index not in os_setting.read_emails:
					os_setting.read_emails.push_back(index)
				save_state(0.2),
		},
	},
	# ----------
	
	# ----------
	{
		"details": {
			"ref": APPS.MUSIC_PLAYER,
			"title": "Music Player",
			"icon": SVGS.TYPE.MUSIC,
			"app": MediaPlayerAppPreload
		},
		"installed": func() -> bool:
			return true,
		"events": {
			"fetch_tracks_unlocked": func() -> Array:
				return os_setting.tracks_unlocked,			
			"open": func(data:Dictionary) -> void:
				var options:Array = 	[
						{
							"title": "ENABLE AUDIO VISUALIZER", 
							"key": "enable_visulizer",
							"value": os_setting.media_player.enable_visulizer,
							"hint_description": "Enable/Disable audio visulizer."
						}
					]
				
				if data.ref not in running_apps_list.map(func(i): return i.ref):
					open_options(
						# ------- BTNS
						[
							{
								"title": "LAUNCH...",
								"onClick": func(_options:Dictionary) -> void:
									await open_app(data, _options)
									update_media_options(_options),
								
							},
							{
								"title": "OPEN MINI PLAYER...",
								"onClick": func(_options:Dictionary) -> void:
									Taskbar.show_media_player = true
									update_media_options(_options)
									await toggle_show_taskbar(true),
								
							}							
						],
						# ------- OPTIONS
						options
					)
				else:
					open_options(
						# ------- BTNS
						[
							{
								"title": "RESUME",
								"onClick": func(_options:Dictionary) -> void:
									open_app(data),
							},
							{
								"title": "FORCE QUIT",
								"onClick": func(_options:Dictionary) -> void:
									close_app(data.ref),
							},
							{
								"title": "APPLY CHANGES...",
								"onClick": func(_options:Dictionary) -> void:
									update_media_options(_options)
									
									# then show controls
									BtnControls.reveal(true),
							},							
						],
						# ------- OPTIONS
						options
					),
					
		},
	},
	# ----------
	
	# ----------
	{
		"details": {
			"ref": APPS.STORE,
			"title": "Store",
			"icon": SVGS.TYPE.MONEY,
			"app": StoreAppPreload
		},
		"installed": func() -> bool:
			return true,
		"events": {
			"open": func(data:Dictionary) -> void:
				var options:Array = []
				if data.ref not in running_apps_list.map(func(i): return i.ref):
					open_options(
						# ------- BTNS
						[
							{
								"title": "LAUNCH...",
								"onClick": func(_options:Dictionary) -> void:
									await open_app(data, _options),
								
							}
						],
						# ------- OPTIONS
						options
					)
				else:
					open_options(
						# ------- BTNS
						[
							{
								"title": "RESUME",
								"onClick": func(_options:Dictionary) -> void:
									open_app(data),
							},
							{
								"title": "FORCE QUIT",
								"onClick": func(_options:Dictionary) -> void:
									close_app(data.ref),
							}
						],
						# ------- OPTIONS
						options
					),
			"fetch_purchases": func() -> Array:
				return os_setting.store_purchases,
			"make_purchase": func(uid:String, cost:int) -> void:
				if uid not in os_setting.store_purchases:
					os_setting.store_purchases.push_back(uid)					
					os_setting.currency.amount -= cost
				else:
					os_setting.store_purchases.erase(uid)
					os_setting.currency.amount += cost
				save_state(0.2),
		},
	},
	# ----------	
	
	# ----------
	{
		"details": {
			"ref": APPS.SETTINGS,
			"title": "Settings",
			"icon": SVGS.TYPE.SETTINGS
		},
		"installed": func() -> bool:
			return true,
		"events": {
			"open": func(data:Dictionary) -> void:
				open_options(
					[
						{
							"title": "APPLY CHANGES...",
							"onClick": func(_options:Dictionary) -> void:
								update_settings_options(_options)

								# reveal controls
								BtnControls.reveal(true),
						},
					],
					[
						{
							"title": "FULLSCREEN", 
							"key": "fullscreen",
							"value": false,
							"hint_description": "Enable/Disable fullscreen mode."
						},
						{
							"title": "CRT FX", 
							"key": "crt_effect",
							"value": GBL.active_user_profile.graphics.shaders.crt_effect,
							"hint_description": "Enable/Disable crt effect."
						}
					]
				),
				
		},
	}
]


var desktop_itemlist:Array = []
var already_loaded:Array = []
var simulate_busy:bool = false : 
	set(val):
		simulate_busy = val
		on_simulated_busy_update()

var running_apps_list:Array = []
var app_in_fullscreen:bool = false 

var control_pos:Dictionary
var freeze_inputs:bool = false : 
	set(val):
		freeze_inputs = val
		on_freeze_inputs_update()
var show_taskbar:bool = false

var selected_app:Dictionary
var selected_app_item:Control
var currently_running_app:Control : 
	set(val):
		currently_running_app = val
		on_currently_running_app_update()

var onBack:Callable = func() -> void:pass

signal on_confirm
#endregion
# -----------------------------------


#region local functions
# -----------------------------------
func _init() -> void:
	GBL.register_node(REFS.OS_LAYOUT, self)
	GBL.subscribe_to_control_input(self)
# -----------------------------------

# -----------------------------------
func _exit_tree() -> void:
	GBL.unregister_node(REFS.OS_LAYOUT)
	GBL.unsubscribe_to_control_input(self)
# -----------------------------------	

# -----------------------------------
func _ready() -> void:	
	set_process(false)
	set_physics_process(false)	
	
	# hide
	HeaderControls.hide()
	PauseContainer.hide()
	AudioVisualizer.hide()
	
	# show
	LoginContainer.show()
	
	# setup
	Taskbar.onBack = func() -> void:
		if freeze_inputs or Taskbar.is_busy:return
		toggle_show_taskbar(false)
				
	#TaskbarBtn.onClick = func() -> void:
		#if freeze_inputs or Taskbar.is_busy:return		
		#toggle_show_taskbar()
# -----------------------------------

# -----------------------------------
func start() -> void:
	var skip_boot:bool = DEBUG.get_val(DEBUG.OS_SKIP_BOOT)
	var skip_to_game:bool = DEBUG.get_val(DEBUG.OS_SKIP_TO_GAME)

	has_started = true
	check_graphics_settings(true)
	load_state()	
	on_simulated_busy_update()
	
	await U.tick()
	
	control_pos[LoginPanel] = {
		"show": 0,
		"hide": -LoginMargin.size.y
	}
	LoginPanel.position.y = control_pos[LoginPanel].hide
	
	await U.set_timeout(1.0 if !skip_boot else 0)
	
	if skip_boot:
		LoginContainer.queue_free()
	else:
		await LoginContainer.start()
		
	await render_desktop_icons()	
	Taskbar.activate()
	HeaderControls.show()
		
	if skip_to_game:
		var app:Dictionary = find_in_app_list(APPS.SITE_DIRECTOR_TRAINING_PROGRAM)
		open_app(app.details)
	
	await reveal_logo(true, 0.5)
	reveal_logo(false, 3.0)
		
func return_to_desktop() -> void:
	currently_running_app = null	
	PauseContainer.hide()
	await toggle_show_taskbar(false)
	assign_default_btn_events()
	BtnControls.reveal(true)
	
func return_to_app(ref:int) -> void:
	PauseContainer.hide()
	await toggle_show_taskbar(false)
	currently_running_app = running_apps_list.filter(func(i): return i.ref == ref)[0].node
	currently_running_app.unpause()
# -----------------------------------	

# -----------------------------------	
func reveal_logo(state:bool, delay:float = 0.0) -> void:
	await U.tween_node_property(LoginPanel, 'position:y', control_pos[LoginPanel].show if state else control_pos[LoginPanel].hide, 0.7, delay)
# -----------------------------------	

# -----------------------------------	
func on_simulated_busy_update() -> void:	
	if !is_node_ready():return
	# DOES NOTHING RIGHT NOW
# -----------------------------------		

# -----------------------------------		
func simulate_wait(duration:float, show_busy:bool = true) -> void:
	if show_busy and duration > 0:
		simulate_busy = true
		
	await U.set_timeout(duration * 1.0)
	
	if show_busy and duration > 0:
		simulate_busy = false
# -----------------------------------		

# -----------------------------------
func open_options(btn_list:Array, option_list:Array = []) -> void:
	if selected_app_item == null:return
		
	freeze_inputs = true
	await BtnControls.reveal(false)
	
	var app_pos:Vector2 = selected_app_item.global_position + Vector2(0, selected_app_item.size.y + 10) 
	OptionsMenu.setup(btn_list, option_list, app_pos)
	var res:Dictionary = await OptionsMenu.wait_for_response
	if res.on_back:
		await BtnControls.reveal(true)
		
	freeze_inputs = false

func find_in_app_list(ref:APPS) -> Dictionary:
	return app_list.filter(func(i): return ("ref" in i.details) and (i.details.ref == ref))[0]
	
func installing_app_start(ref:APPS) -> void:
	if ref not in apps_installing:
		apps_installing.push_back(ref)

func install_app_complete(ref:APPS) -> void:
	apps_installing.erase(ref)
	#
	#if ref not in apps_installed:
		#apps_installed.push_back(ref)
	await render_desktop_icons()
	#save_state()
# -----------------------------------
#endregion


# -----------------------------------
#region SAVE/LOAD
func check_graphics_settings(instant:bool = false) -> void:
	var use_crt_effect:bool = GBL.active_user_profile.graphics.shaders.crt_effect
	if use_crt_effect:
		GBL.find_node(REFS.MAIN).apply_shader_effects(false) 
	else:
		GBL.find_node(REFS.MAIN).no_shader_effects(false)	

func save_state(duration:float = 0.2) -> void:
	GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_setting = os_setting
	GBL.update_and_save_user_profile()
	
	await simulate_wait(duration)

func load_state() -> void:
	restore_state(GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_setting)
		
func restore_state(restore_os_setting:Dictionary) -> void:
	os_setting = restore_os_setting

#endregion		
# -----------------------------------

# -----------------------------------	
func open_app(data:Dictionary, options:Dictionary = {}) -> void:
	if simulate_busy or freeze_inputs:return
	
	# hide button controls
	freeze_inputs = true	
	await BtnControls.reveal(false)	
	
	# grab background image for pause continaer	
	PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.MAIN_ACTIVE_VIEWPORT))	

	# ... now open the "app"
	if data.ref not in running_apps_list.map(func(i): return i.ref):
		simulate_busy = true
		var app:Dictionary = find_in_app_list(data.ref) 
		var new_node:Control = data.app.instantiate()
		var previously_loaded:bool = data.ref in already_loaded
		
		# added to running apps list
		running_apps_list.push_back({
			"ref": data.ref, 
			"node": new_node
		})		
		
		# add to already loaded list
		if data.ref not in already_loaded:
			already_loaded.push_back(data.ref)
		
		# pass properties
		if "events" in app:
			new_node.events = app.events
		new_node.options = options
		new_node.in_fullscreen = true
		new_node.details = app.details
		
		# add child 
		RunningAppsContainer.add_child( new_node )
		
		# add to taskbar
		Taskbar.add_item({
			"title": data.title,
			"icon": data.icon,
			"ref": data.ref,
			"node": new_node,
			"events": app.events
		}) 
		
		# start app
		await U.tick()
		currently_running_app = new_node
		await new_node.start( previously_loaded or DEBUG.get_val(DEBUG.OS_APP_FAST_LOAD) )
	
	else:
		currently_running_app = running_apps_list.filter(func(i): return i.ref == data.ref)[0].node
		currently_running_app.unpause()
	
	mark_as_running()
	
	simulate_busy = false
	freeze_inputs = false		

func force_close_app(ref:int) -> void:
	var filtered:Array = running_apps_list.filter(func(item): return item.ref == ref)
	if !filtered.is_empty():
		if "force_save_and_quit" in filtered[0].node:
			filtered[0].node.force_save_and_quit.call()
		# quit node
		filtered[0].node.queue_free()
		# remove from taskbar
		Taskbar.remove_item(ref)
		
	running_apps_list = running_apps_list.filter(func(item): return item.ref != ref)
	
	mark_as_running()

func close_app(ref:int) -> void:
	var filtered:Array = running_apps_list.filter(func(item): return item.ref == ref)
		
	if !filtered.is_empty():
		# quit node
		filtered[0].node.queue_free()
		# remove from taskbar
		Taskbar.remove_item(ref)
		
	running_apps_list = running_apps_list.filter(func(item): return item.ref != ref)

	currently_running_app = null
	BtnControls.reveal(true)
	
	mark_as_running()

func mark_as_running() -> void:
	var active_refs:Array = running_apps_list.map(func(x): return x.ref)
	for child in DesktopGrid.get_children():
		if "ref" in child.data:
			child.is_running = child.data.ref in active_refs	

func on_currently_running_app_update() -> void:
	TransitionScreen.start(0.1, true)
	
	# hide/show any desktop icons 
	for node in DesktopGrid.get_children():
		if currently_running_app == null:
			node.show() 
		else: 
			node.hide()
	
	for app in RunningAppsContainer.get_children():
		if app == currently_running_app:
			app.show() 
		else:
			app.hide()
			
	if currently_running_app == null:
		#reveal_logo(true)
		RunningAppsContainer.hide()
	else:
		#reveal_logo(false)
		RunningAppsContainer.show()
		
# -----------------------------------	
#endregion
# -----------------------------------

# -----------------------------------
#region LIST AND NODE BEHAVIOR
# -----------------------------------		
func render_desktop_icons() -> void:
	freeze_inputs = true
	
	if currently_running_app == null:
		await BtnControls.reveal(false)
	
	desktop_itemlist = []

	for child in DesktopGrid.get_children():
		child.free()
			
	for app in app_list:
		if app.installed.call():
			var new_node:Control = AppItemPreload.instantiate()	
			DesktopGrid.add_child(new_node)
			desktop_itemlist.push_back(new_node)
			new_node.data = app.details
			
			new_node.onFocus = func(node:Control) -> void:
				for child in DesktopGrid.get_children():
					child.is_selected = child == node
					if child == node:
						selected_app = app
						selected_app_item = new_node
						
	# sets 
	await U.tick()
	BtnControls.offset = Vector2(5, 5)

	assign_default_btn_events()
	
	if currently_running_app == null:
		await BtnControls.reveal(true)
	
	freeze_inputs = false
# -----------------------------------
#endregion
# -----------------------------------

# -----------------------------------
func on_freeze_inputs_update() -> void:
	if !is_node_ready():return
	#TaskbarBtn.is_disabled = freeze_inputs
	
func toggle_show_taskbar(state:bool = !show_taskbar) -> void:
	show_taskbar = state
	freeze_inputs = true
	
	# pause any running apps
	if state:
		for app in RunningAppsContainer.get_children():
			app.pause() 

	# unpause only currently running app
	if !state and currently_running_app != null:
		currently_running_app.unpause()
		
	#TaskbarBtn.title = "TASKBAR"	if !show_taskbar else "RETURN"
	#TaskbarBtn.icon = SVGS.TYPE.CLEAR if show_taskbar else SVGS.TYPE.ARROW_DOWN
		
	if show_taskbar:		
		if currently_running_app == null:
			PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.MAIN_ACTIVE_VIEWPORT))
		PauseContainer.show()	
		Taskbar.set_show_taskbar(show_taskbar)
		await BtnControls.reveal(false)	
		
	else:
		await Taskbar.set_show_taskbar(false)		
		PauseContainer.hide()
		if Taskbar.BtnControl.item_index == 0:
			currently_running_app = null
			
			await BtnControls.reveal(true)
		
	freeze_inputs = false		
# -----------------------------------

# -----------------------------------
func switch_to() -> void:	
	BtnControls.reveal(true)
# -----------------------------------

# -----------------------------------
func assign_default_btn_events() -> void:
	BtnControls.a_btn_title = "SELECT"
	BtnControls.b_btn_title = "BACK"
	BtnControls.directional_pref = "LR"
	BtnControls.itemlist = desktop_itemlist
	BtnControls.item_index = previous_desktop_index	

	BtnControls.onAction = func() -> void:
		if selected_app.is_empty():return
		BtnControls.reveal(false)
		selected_app.events.open.call(selected_app.details)	
		
	BtnControls.onBack = func() -> void:		
		BtnControls.reveal(false)
		onBack.call()	
# -----------------------------------

# -----------------------------------
func assign_taskbar_btn_events() -> void:
	BtnControls.itemlist = []
	BtnControls.item_index = 0
		
	BtnControls.onAction = func() -> void:
		BtnControls.freeze_and_disable(true)
		await U.tween_node_property(TaskbarCornerPanel, "size:y", 150, 0.3, 0, Tween.TRANS_CIRC)
		BtnControls.freeze_and_disable(false)
		toggle_show_taskbar()
		BtnControls.hide_a_btn = false
		show_taskbar_preview = false
		
	BtnControls.onBack = func() -> void:
		BtnControls.freeze_and_disable(true)
		await U.tween_node_property(TaskbarCornerPanel, "size:y", 150, 0.3, 0, Tween.TRANS_CIRC)
		BtnControls.freeze_and_disable(false)
		BtnControls.hide_hint = false
		BtnControls.hide_a_btn = false
		show_taskbar_preview = false		
		assign_default_btn_events()
# -----------------------------------


# ------------------------------------------
var show_taskbar_preview:bool = false 
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or freeze_inputs or Taskbar.is_busy or Taskbar.show_taskbar:return		

	match input_data.key:
		"BACKSPACE":
			if !show_taskbar_preview:
				show_taskbar_preview = true
				previous_desktop_index = BtnControls.item_index
				
				BtnControls.hide_hint = true
				BtnControls.a_btn_title = "OPEN"
				BtnControls.b_btn_title = "CLOSE"
				BtnControls.freeze_and_disable(true)
				await U.tween_node_property(TaskbarCornerPanel, "size:y", 300, 0.3, 0, Tween.TRANS_CIRC)
				BtnControls.freeze_and_disable(false)
				assign_taskbar_btn_events()	
			else:
				BtnControls.freeze_and_disable(true)
				await U.tween_node_property(TaskbarCornerPanel, "size:y", 150, 0.3, 0, Tween.TRANS_CIRC)
				BtnControls.freeze_and_disable(false)
				toggle_show_taskbar()
				BtnControls.hide_a_btn = false
				show_taskbar_preview = false
# ------------------------------------------
