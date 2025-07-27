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

	BtnControls.reveal(false)
	
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
func generate_flicker_pattern(count := 10) -> Array:
	var flickers := []
	for i in count:
		# Quick flick (off/on)
		if randi() % 2 == 0:
			flickers.append(randf_range(0.02, 0.05))  # fast blink
		else:
			flickers.append(randf_range(0.1, 0.2))   # slightly slower
	return flickers
# ---------------------------------------------

# ---------------------------------------------
func start(use_fast_animation:bool = false) -> void:
	play_introduction = GBL.active_user_profile.boot_count == 0		
	CellSceneRender.enable_ambient_lighting = true
		
	show()	
	RenderSubviewport.set_process(true)	
	TextureRender.texture = RenderSubviewport.get_texture()
	
	if play_introduction:
		BtnControls.hide_a_btn = true

		BtnControls.onAction = func() -> void:
			BtnControls.reveal(false)		
			await transInFx.call()
			await zoom_into_screen(true)
			await play_current_story_sequence()
			
			zoom_into_screen(false)			
			BtnControls.reveal(true)
			GBL.active_user_profile.boot_count += 1
			GBL.update_and_save_user_profile()
			play_introduction = false
			CellSceneRender.enable_lowlevel_lighting = false		
			CellSceneRender.enable_interogation_lighting = true			
			check_btn_states()

		await U.tween_node_property(self, "modulate:a", 1, 2.0)
		await U.tween_node_property(FadeOverlay, "modulate:a", 0, 2.0)		
	
		await U.set_timeout(3.0)		
		
		for duration in generate_flicker_pattern(10):
			await U.set_timeout(duration)
			CellSceneRender.enable_lowlevel_lighting = !CellSceneRender.enable_lowlevel_lighting
		BtnControls.hide_a_btn = false
		CellSceneRender.enable_lowlevel_lighting = true
		await U.set_timeout(3.0)
		BtnControls.freeze_and_disable(false)


			


	await U.tick()

	SUBSCRIBE.music_data = {
		"selected": OS_AUDIO.TRACK.LOADING
	}
	
	fast_animation = use_fast_animation
	await U.tween_node_property(self, "modulate:a", 1, 1.0)
	await U.tween_node_property(FadeOverlay, "modulate:a", 0, 1.0)
	BtnControls.reveal(true)

func end() -> void:
	hide()
	on_finish.emit()
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
				await zoom_into_screen(true)
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
				await zoom_into_screen(true)				
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
				await zoom_into_screen(true)
				gotoScp.call()
				
		# ------------------------
		FOCUS.EXIT:
			BtnControls.a_btn_title = "STARE INTO THE DARK"
			
			BtnControls.onAction = func() -> void:
				await transInFx.call()
				BtnControls.reveal(false)
				await zoom_into_screen(true)
				await U.set_timeout(4.0)
				await zoom_into_screen(false)
				BtnControls.reveal(true)
				
# ---------------------------------------------

# ---------------------------------------------
func zoom_into_screen(state:bool, duration:float = 2.0) -> void:
	await CellSceneRender.zoom(state)	
# ---------------------------------------------

# ---------------------------------------------
func switch_to() -> void:	
	await zoom_into_screen(false)	
	BtnControls.reveal(true)
# ---------------------------------------------
