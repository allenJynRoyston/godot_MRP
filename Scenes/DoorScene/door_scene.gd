extends PanelContainer

@onready var ColorBG:ColorRect = $ColorBG
@onready var TextureRender:TextureRect = $TextureRect
@onready var RenderSubviewport:SubViewport = $RenderSubviewport
@onready var SceneCamera:Camera3D = $RenderSubviewport/Node3D/Camera3D
@onready var IntroSubviewport:SubViewport = $SubViewport
@onready var IntroAndTitleScreen:Control = $SubViewport/IntroAndTitleScreen
@onready var SceneAnimationPlayer:AnimationPlayer = $RenderSubviewport/Node3D/SceneAnimationPlayer
@onready var ScreenTextureRect:TextureRect = $RenderSubviewport/Node3D/Desk/Screen/Sprite3D/SubViewport/TextureRect

@onready var BtnControls:Control = $BtnControls

@onready var StoryNarration:Control = $StoryNarration

enum MODE {INIT, START, START_AT_SCREEN}

var control_pos:Dictionary = {}

var current_mode:MODE = MODE.INIT : 
	set(val):
		current_mode = val
		on_current_mode_update()

var is_ready:bool = false
var onLogin:Callable = func():pass

#var story_chapters:Array[Dictionary] = [
	#{
		#"text": [
			#"Listen carefully.  My name is Researcher [   ] and I was tasked with recording these messages for Procedure-[   ]: the Memeory Recovery Protocol, the procedure that you are now currently undergoing.",
			#"The first thing I need to tell you is you are not safe, and your life is in danger.",
			#"Thats the bad news.  The good news, is, that you can change that.  You have control here.  But.  I still need you to be a little bit afraid.",
			#"Now this is hard to understand at first, but... you've done this before.  You've undergone this exact procedure, safetly, multiple times.  You've saved your life each time.",
			#"You just don't remember.",
			#"But it's more accurate to say that you just CAN'T remember.",
			#"The reason is you exposed yourself to an incredibly potent amnestic, a synthetic chemical agent used to suppress memory and [    ].",
			#"Your inability to remember who you are, who you REALLY are, is intentional.  What we don't understand is how the mind that, the mind of somebody not you... fills in that absense.  Whoever that is, you are target we are trying to reach.",
			#"And we believe that's who we're speaking to now.",
			#"Anyways, there's a computer in front of you. I just need you to complete the tutorial.  Once you do I'll tell you more."
		 #],
		#"objectives": [
			#{
				#"title": "Complete the tutorial", "is_completed": func():pass
			#}			
		#]
	#},
	#{
		#"text": [
			#"So like I said, we've done this a few times now.  Our success rate is actually [ ]%, which, you know... isn't that bad.  Considering.",
			#"But... what's really improves our odds is when you trust me.",
			#"And, unfortunately, that's going to be really difficult after I disclose the last message you sent me.",
			#"It simply said, and I quote: ",
			#"'You can't trust it.  It lies.'",
			#"End quote.",
			#"The thing is, you've sent me this exact message the last time you triggered the self destruct, but you couldn't remember what it meant, even after a successful recall.",
			#"That is... very uncomforable, to say the least.  And it leads me to only two conlusions: ",
			#"That some entity keeps forcing you to initiate the site self-destruct sequence unknowingly or worse.",  
			#"You WANT to do it, but that something keeps stopping you.",
			#"Eitherway, we need to know so we can help you.", 
			#"You've been emailed a program for the computer.  Install it and fufill the objectives and we'll talk more."
		#],
		#"objectives": [
			#{"title": "Contain 1 SCP by day 10.", "is_completed": func():pass}			
		#]
	#}	
#];


#var current_progress_val:int = 0
var story_progress_val:int = 0
var play_sequence:bool = true : 
	set(val):
		play_sequence = val
		on_play_sequence_update()

signal on_finish

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
	on_current_mode_update()	
	on_play_sequence_update()
	
	BtnControls.reveal(false)

	IntroAndTitleScreen.on_end = func() -> void:
		IntroSubviewport.set_process(false)
		IntroSubviewport.get_child(0).hide()
	
	BtnControls.onAction = func() -> void:
		if !is_ready:return
		await BtnControls.reveal(false)
		onLogin.call()
	
	BtnControls.onCBtn = func() -> void:
		if !is_ready:return
		await BtnControls.reveal(false)		
		play_story_sequence(true)
	
	BtnControls.onBack = func() -> void:
		pass
			
	
	await U.tick()
	if DEBUG.get_val(DEBUG.NEW_PROGRESS_FILE):
		FS.save_file(FS.FILE.PROGRESS, get_current_save_state())
		await U.tick()
	
	var res:Dictionary = FS.load_file(FS.FILE.PROGRESS)
	if res.success:
		parse_save_data(res.filedata.data)
	else:
		FS.save_file(FS.FILE.PROGRESS, get_current_save_state())
		
# ---------------------------------------------

# ---------------------------------------------
func play_story_sequence(skip_delay:bool) -> void:	
	StoryNarration.text_list = STORY.chapters[story_progress_val].text 
	await StoryNarration.reveal(true)
	await StoryNarration.on_end
	BtnControls.reveal(true)
		
	play_sequence = false
# ---------------------------------------------

# ---------------------------------------------
func update_progress_and_update_objective() -> Array:
	var RootNode:Control = GBL.find_node(REFS.OS_ROOT)
	var next_progress_val:int = story_progress_val + 1		
	RootNode.current_layer = RootNode.LAYER.DOOR_LAYER
	print("add door layer control so you can play next objective")
	await U.set_timeout(3.0)
	
	# update story progress val 
	var res:Dictionary = FS.load_file(FS.FILE.PROGRESS)
	var progress_data:Dictionary = res.filedata.data
	progress_data.story_progress_val = next_progress_val
	FS.save_file(FS.FILE.PROGRESS, progress_data)
	
	# wait for user input
	RootNode.current_layer = RootNode.LAYER.OS_lAYER
	
	# return new objectives
	return STORY.get_objectives(next_progress_val)
# ---------------------------------------------
		
# ---------------------------------------------
func parse_save_data(save_data:Dictionary) -> void:
	story_progress_val = save_data.story_progress_val
	GBL.progres_save_data = save_data
# ---------------------------------------------

# ---------------------------------------------
func get_current_save_state() -> Dictionary:
	return {
		"story_progress_val": DEBUG.get_val(DEBUG.STORY_PROGRESS_VAL) if DEBUG.get_val(DEBUG.DEBUG_STORY_PROGRESS) else story_progress_val,
	}	
# ---------------------------------------------



# ---------------------------------------------
func on_play_sequence_update() -> void:
	if !is_node_ready():return
	BtnControls.c_btn_title = "REPLAY MESSAGE" if !play_sequence else "PLAY MESSAGE"
	BtnControls.hide_a_btn = play_sequence
# ---------------------------------------------
	
# ---------------------------------------------
func start() -> void:
	show()	
	await U.tick()	
	current_mode = MODE.START

func fastfoward() -> void:
	await U.tick()	
	current_mode = MODE.START_AT_SCREEN
	show()	

func end() -> void:
	hide()
	current_mode = MODE.INIT
	on_finish.emit()

func switch_to() -> void:
	if current_mode == MODE.INIT:return
	is_ready = false	
	await BtnControls.reveal(true)
	is_ready = true
# ---------------------------------------------

# ---------------------------------------------
func on_current_mode_update() -> void:
	if !is_node_ready():return
	match current_mode:
		# ---------
		MODE.INIT:
			for subviewport in [IntroSubviewport, RenderSubviewport]:
				subviewport.set_process(false)

			for node in [ColorBG, TextureRender]:
				node.show()

			ColorBG.color = Color.BLACK			
		
		# ---------
		MODE.START:
			U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
			IntroAndTitleScreen.start()
			await IntroAndTitleScreen.on_continue
			IntroAndTitleScreen.queue_free()

			RenderSubviewport.set_process(true)

			U.tween_node_property(SceneCamera, "fov", 77, 4.0, 0, Tween.TRANS_EXPO)
			TextureRender.texture = RenderSubviewport.get_texture()
			#ScreenTextureRect.texture = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))
			
			await U.tween_node_property(SceneCamera, "rotation_degrees:y", 1, 0.7, 2.5)
			SceneAnimationPlayer.active = true
			SceneAnimationPlayer.play("LightsOn")			
			BtnControls.reveal(true)

		# ---------
		MODE.START_AT_SCREEN:
			U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0)
			IntroAndTitleScreen.queue_free()

			RenderSubviewport.set_process(true)
			U.tween_node_property(SceneCamera, "fov", 77, 0)
			TextureRender.texture = RenderSubviewport.get_texture()
			#ScreenTextureRect.texture = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))
			
			U.tween_node_property(SceneCamera, "rotation_degrees:y", 1, 0)
			SceneAnimationPlayer.active = true
			SceneAnimationPlayer.play("LightsOn")			
			
			BtnControls.reveal(true)

		# ---------
	
	is_ready = true
# ---------------------------------------------	
