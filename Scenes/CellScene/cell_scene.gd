extends PanelContainer

@onready var ColorBG:ColorRect = $ColorBG
@onready var TextureRender:TextureRect = $TextureRect
@onready var BtnControls:Control = $BtnControls
@onready var StoryNarration:Control = $StoryNarration
@onready var RenderSubviewport:SubViewport = $RenderSubviewport
@onready var CellSceneRender:Node3D = $RenderSubviewport/CellSceneRender
@onready var FadeOverlay:ColorRect = $FadeOverlay

enum FOCUS {COMPUTER, CENTER, TERMINAL, EXIT}

var MAIN_NODE:Control
var control_pos:Dictionary = {}

# new values
var story_progress:Dictionary = {}

var original_fov:float
var original_rotation_degrees:Vector3
var fast_animation:bool = false

var focus_arr:Array = [FOCUS.COMPUTER, FOCUS.CENTER, FOCUS.TERMINAL, FOCUS.EXIT]
var focus_index:int = FOCUS.CENTER : 
	set(val):
		focus_index = val
		on_focus_index_update()
	
var play_introduction:bool 
var gotoOs:Callable = func():pass
var gotoScp:Callable = func():pass
var transInFx:Callable = func():pass
var transOutFx:Callable = func():pass

signal on_finish
signal wait_for_story

# ---------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)
	GBL.subscribe_to_fullscreen(self)
	GBL.register_node(REFS.DOOR_SCENE, self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)
	GBL.unsubscribe_to_fullscreen(self)
	GBL.unregister_node(REFS.DOOR_SCENE)

func _ready() -> void:
	FadeOverlay.show()
	
	for subviewport in [ RenderSubviewport]:
		subviewport.set_process(false)

	for node in [ColorBG, TextureRender]:
		node.show()	

	MAIN_NODE = GBL.find_node(REFS.MAIN)	
	
	BtnControls.reveal(false, true)
	
	BtnControls.onBack = func() -> void:pass
	# 
	BtnControls.onDirectional = func(key:String):
		if !is_visible_in_tree() or !is_node_ready() or play_introduction:return
		match key:
			"A":
				if focus_index != 0:
					focus_index = U.min_max(focus_index - 1, 0, focus_arr.size() - 1)
			"D":
				if focus_index != focus_arr.size() - 1:
					focus_index = U.min_max(focus_index + 1, 0, focus_arr.size() - 1)
		
		check_btn_states()

	CellSceneRender.look_at_center()
# ---------------------------------------------

# ---------------------------------------------
func start(use_fast_animation:bool = false) -> void:
	play_introduction = GBL.active_user_profile.boot_count == 0		
	CellSceneRender.enable_ambient_lighting = true
	BtnControls.freeze_and_disable(true)

	show()	
	modulate.a = 1	
	RenderSubviewport.set_process(true)	
	TextureRender.texture = RenderSubviewport.get_texture()
	
	if play_introduction:
		await play_introduction_sequence()
	else:
		await normal_boot_sequence()

	await U.set_timeout(5.0)		
	GBL.find_node(REFS.AUDIO).fade_out(3.0)	
	await U.set_timeout(3.0)
	SUBSCRIBE.music_data = {
		"selected": OS_AUDIO.TRACK.LOADING,
	}	

func end() -> void:
	hide()
	on_finish.emit()
# ---------------------------------------------

# ---------------------------------------------
func play_introduction_sequence() -> void:	
	# setup controls
	BtnControls.a_btn_title = "???"
	BtnControls.hide_a_btn = true
	BtnControls.onAction = func() -> void:
		BtnControls.reveal(false)		
		end_introduction_sequence()
	
	# start with power out
	CellSceneRender.power_computer = false
	CellSceneRender.power_terminal = false
	
	await U.tween_node_property(self, "modulate:a", 1, 1.0)
	BtnControls.freeze_and_disable(true)
	await U.tween_node_property(FadeOverlay, "modulate:a", 0, 2.0)		
	await U.set_timeout(0.5)
	SUBSCRIBE.music_data = {
		"selected": OS_AUDIO.TRACK.OS_STARTUP_SFX,
	}
			
	CellSceneRender.power_computer = true
	CellSceneRender.computer_screen_color = Color.ORANGE
	await U.set_timeout(2.0)
	CellSceneRender.power_terminal = true	


	for duration in U.generate_flicker_pattern(10):
		await U.set_timeout(duration)
		CellSceneRender.enable_lowlevel_lighting = !CellSceneRender.enable_lowlevel_lighting
	CellSceneRender.enable_lowlevel_lighting = true	
	
	await U.set_timeout(1.0)	
	BtnControls.hide_a_btn = false
	BtnControls.freeze_and_disable(false)
# ---------------------------------------------	

# ---------------------------------------------	
func end_introduction_sequence() -> void:
	#REFS.OS_LAYOUT .has_started
	await transInFx.call()
	await zoom_into_screen(true, 2)
	await play_current_story_sequence()

	CellSceneRender.enable_lowlevel_lighting = false		
	CellSceneRender.enable_interogation_lighting = true			
				
	zoom_into_screen(false)			
	check_btn_states()
	BtnControls.reveal(true)
	
	GBL.active_user_profile.boot_count += 1
	GBL.update_and_save_user_profile()
	play_introduction = false
# ---------------------------------------------	

# ---------------------------------------------	
func normal_boot_sequence() -> void:
	BtnControls.reveal(false, true)	
	await U.tween_node_property(self, "modulate:a", 1, 1.0)
	await U.tween_node_property(FadeOverlay, "modulate:a", 0, 2.0)		
	await U.set_timeout(1.0)
	BtnControls.reveal(true)
# ---------------------------------------------		

# ---------------------------------------------
func play_current_story_sequence() -> void:	
	var on_chapter:int = GBL.get_current_chapter()
	
	StoryNarration.text_list = STORY.chapters[on_chapter].story_message 
	await StoryNarration.reveal(true)
	await StoryNarration.on_end

	GBL.mark_messages_played(on_chapter)
# ---------------------------------------------

# ---------------------------------------------
func play_next_sequence() -> void:
	var on_chapter:int = GBL.get_current_chapter()

	# update available buttons
	await BtnControls.reveal(true)	
	check_btn_states()
	
	# change the root node to show this scene...
	MAIN_NODE.current_layer = MAIN_NODE.LAYER.CELLBLOCK_LAYER

	# wait for story sequence to complete
	await wait_for_story
	GBL.mark_messages_played(on_chapter)
	
	# ... then revert to os scene
	MAIN_NODE.current_layer = MAIN_NODE.LAYER.OS_lAYER
	
	await U.set_timeout(0.3)
# ---------------------------------------------

# ---------------------------------------------
func on_focus_index_update() -> void:
	BtnControls.freeze_and_disable(true)

	match focus_index:
		FOCUS.COMPUTER:
			await CellSceneRender.look_at_computer()
		FOCUS.CENTER:
			await CellSceneRender.look_at_center()			
		FOCUS.TERMINAL:
			await CellSceneRender.look_at_terminal()
		FOCUS.EXIT:
			await CellSceneRender.look_at_exit()			
	
	
	BtnControls.freeze_and_disable(false)
	check_btn_states()
# ---------------------------------------------	

# ---------------------------------------------
func check_btn_states() -> void:	
	match focus_index:
		# ------------------------
		FOCUS.COMPUTER:
			BtnControls.a_btn_title = "LOGIN"
				
			BtnControls.onAction = func() -> void:				
				BtnControls.reveal(false)
				await transInFx.call()
				await zoom_into_screen(true, 4)
				CellSceneRender.computer_screen_color = Color.SKY_BLUE
				gotoOs.call()			
		# ------------------------
		FOCUS.CENTER:
			var on_chapter:int = GBL.get_current_chapter()
			var has_story_message:bool = "story_message" in STORY.chapters[on_chapter]
			var message_has_been_played:bool = GBL.has_message_been_played(on_chapter)
						
			# modify on action so it skips
			BtnControls.a_btn_title = "PLAY MESSAGE" if !message_has_been_played else "REPLAY MESSAGE"
				
			BtnControls.onAction = func() -> void:				
				BtnControls.reveal(false)
				await transInFx.call()
				await zoom_into_screen(true, 2)				
				await play_current_story_sequence()
				check_btn_states()
				zoom_into_screen(false)
				BtnControls.reveal(true)
				
		# ------------------------
		FOCUS.TERMINAL:
			BtnControls.a_btn_title = "INVESTIGATE"
			
			BtnControls.onAction = func() -> void:				
				BtnControls.reveal(false)
				await transInFx.call()
				await zoom_into_screen(true, 4)
				gotoScp.call()
				
		# ------------------------
		FOCUS.EXIT:
			BtnControls.a_btn_title = "STARE INTO THE DARK"
			
			BtnControls.onAction = func() -> void:
				await transInFx.call()
				BtnControls.reveal(false)
				await zoom_into_screen(true)
				await U.set_timeout(4.0)
				await zoom_into_screen(false, 4)
				BtnControls.reveal(true)
				
# ---------------------------------------------

# ---------------------------------------------
func zoom_into_screen(state:bool, zoom_in_val:int = 1) -> void:
	await CellSceneRender.zoom(state, zoom_in_val)	
	if state:
		GBL.find_node(REFS.MAIN).TransitionScreen.start(0.3, true)
# ---------------------------------------------

# ---------------------------------------------
func switch_to() -> void:	
	await zoom_into_screen(false)	
	BtnControls.reveal(true)
# ---------------------------------------------
