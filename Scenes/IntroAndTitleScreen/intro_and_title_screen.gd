extends PanelContainer

enum MODE {INIT, START, TITLESPLASH, DISPLAY_LOGO, DISPLAY_TITLE, DISPLAY_SIDE_TEXT, WAIT_FOR_INPUT, EXIT}

@onready var TextureRender:TextureRect = $Title/MarginContainer/TextureRender

@onready var RenderSubviewport:SubViewport = $Title/RenderSubviewport
@onready var SceneCamera:Camera3D = $Title/RenderSubviewport/Node3D/Camera3D

@onready var TitleSplash:PanelContainer = $TitleSplash

@onready var LogoControl:Control = $Logo
@onready var LogoPanel:MarginContainer = $Logo/MarginContainer
@onready var LogoTextureRect:TextureRect = $Logo/MarginContainer/CenterContainer/Control/TextureRect

@onready var TitleControl:Control = $Title
@onready var TitlePanel:MarginContainer = $Title/MarginContainer
@onready var TitleBG:ColorRect = $Title/MarginContainer/TitleBG
@onready var TitleBGLabel:Label = $Title/MarginContainer/CenterContainer/TitleBGLabel
@onready var TitleLetterContainers:HBoxContainer = $Title/MarginContainer/CenterContainer/TitleLetterContainers

@onready var CreditsControl:Control = $Credits
@onready var CreditsPanel:PanelContainer = $Credits/PanelContainer
@onready var CreditsMarginPanel:MarginContainer = $Credits/PanelContainer/MarginContainer
@onready var CreditLabel:Label = $Credits/PanelContainer/MarginContainer/HBoxContainer/CreditLabel

@onready var PressStart:Control = $PressStart
@onready var PressStartPanel:PanelContainer = $PressStart/PanelContainer
@onready var PressStartGameLabel:Label = $PressStart/PanelContainer/MarginContainer/VBoxContainer/GameTitle
@onready var PressStartMainPanel:MarginContainer = $PressStart/PanelContainer/MarginContainer

@onready var ScpControl:Control = $SCP

const game_title:String = "MEMORY RECOVERY PROTOCOL"
const BlurInLetterPreload:PackedScene = preload("res://Scenes/IntroAndTitleScreen/parts/BlurInLetter.tscn")

var control_pos:Dictionary = {}

var current_mode:MODE = MODE.INIT : 
	set(val):
		current_mode = val
		on_current_mode_update()

signal user_input
signal on_complete

# ---------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	
	SceneCamera.fov = 100
	for node in [LogoPanel, TitlePanel, CreditsPanel, PressStartPanel, TitleBGLabel]:
		node.modulate = Color(1, 1, 1, 0)	
	
	PressStartGameLabel.text = "SCP: %s" % [game_title]
	
	for child in TitleLetterContainers.get_children():
		child.queue_free()
	
	for letter in game_title:
		var new_label:Control = BlurInLetterPreload.instantiate()
		new_label.text = str(letter)
		new_label.modulate = Color(1, 1, 1, 0)
		TitleLetterContainers.add_child(new_label)
	
	await U.tick()
	
	control_pos[CreditsMarginPanel] = {
		"hide": 0, 
		"show": CreditsMarginPanel.position.y - 10
	}
	
	control_pos[PressStartMainPanel] = {
		"hide": PressStartMainPanel.position.y, 
		"show": PressStartMainPanel.position.y - 10
	}
	
	#on_current_mode_update()	
# ---------------------------------------------	

# ---------------------------------------------
func start() -> void:
	set_process(true)
	current_mode = MODE.START


func end() -> void:
	on_complete.emit()
	queue_free()
# ---------------------------------------------

# ---------------------------------------------
func on_current_mode_update() -> void:
	if !is_node_ready():return
	match current_mode:
		# ---------
		MODE.START:	
			U.tween_node_property(self, 'modulate', Color(1, 1, 1, 1))
			current_mode = MODE.TITLESPLASH			
		MODE.TITLESPLASH:	
			if !DEBUG.get_val(DEBUG.SKIP_SPLASH):
				TitleSplash.start()
				await TitleSplash.on_complete	
				await U.set_timeout(0.5)	
			current_mode = MODE.DISPLAY_LOGO	
		# ---------
		MODE.DISPLAY_LOGO:
			if !DEBUG.get_val(DEBUG.INTRO_SKIP_LOGO):
				SUBSCRIBE.music_data = {
					"selected": MUSIC.TRACK.INTRO,
				}	
					
				# fade in
				U.tween_node_property(LogoTextureRect, 'scale:x', 1.05, 1.0, 1.0, Tween.TRANS_LINEAR)
				U.tween_node_property(LogoTextureRect, 'scale:y', 1.05, 1.0, 1.0, Tween.TRANS_LINEAR)
				await U.tween_node_property(LogoPanel, 'modulate', Color(1, 1, 1, 1), 1.0, 0.3)
				
				await U.set_timeout(2.0)
				# fade out
				U.tween_node_property(LogoTextureRect, 'scale:x', 1, 1.0, 1.0, Tween.TRANS_LINEAR)
				U.tween_node_property(LogoTextureRect, 'scale:y', 1, 1.0, 1.0, Tween.TRANS_LINEAR)
				await U.tween_node_property(LogoPanel, 'modulate', Color(1, 1, 1, 0), 1.0)
				
			current_mode = MODE.DISPLAY_TITLE
		# ---------
		MODE.DISPLAY_TITLE:			
			if !DEBUG.get_val(DEBUG.INTRO_SKIP_TITLE):
				TitlePanel.modulate = Color(1, 1, 1, 1)
				await U.tween_node_property(TitleBG, 'color', Color(0, 0, 0, 0), 2.0)

				U.tween_node_property(SceneCamera, 'fov', 80, 10.0)
				await U.tween_node_property(TitleBGLabel, 'modulate', Color(1, 1, 1, 1), 2.0)
				
				for index in range(0, TitleLetterContainers.get_child_count()):
					var letter_node:Control = TitleLetterContainers.get_child(index)
					await letter_node.start()
				
				await U.set_timeout(1.0)
	
			current_mode = MODE.DISPLAY_SIDE_TEXT
		# ---------
		MODE.DISPLAY_SIDE_TEXT:			
			if !DEBUG.get_val(DEBUG.INTRO_SKIP_SEQUENCE):
				for item in [
						{"text": 'A GAME BY ALLEN ROYSTON', "wait": 0.3}, 
						{"text": 'CREATING SAVE FILE', "wait": 0.4}, 
						{"text": 'SAVE FILE LOADED.', "wait": 0.4}
					]:
					CreditsMarginPanel.position.y = control_pos[CreditsMarginPanel].hide
					CreditLabel.text = item.text
					CreditLabel.modulate = Color(1, 1, 1, 0)
					
					U.tween_node_property(CreditLabel, 'modulate', Color(1, 1, 1, 1), 0.3)
					U.tween_node_property(CreditsPanel, 'modulate', Color(1, 1, 1, 1), 0.3)
					
					await U.tween_node_property(CreditsMarginPanel, 'position:y', control_pos[CreditsMarginPanel].show + 5, 0.3, Tween.TRANS_LINEAR)
					await U.set_timeout(item.wait)
					U.tween_node_property(CreditsMarginPanel, 'position:y', control_pos[CreditsMarginPanel].show - 5, 0.3, Tween.TRANS_LINEAR)
					await U.tween_node_property(CreditLabel, 'modulate', Color(1, 1, 1, 0), 0.4)
				
				U.tween_node_property(SceneCamera, 'fov', 60, 4.0)
				U.tween_node_property(CreditsPanel, 'modulate', Color(1, 1, 1, 0), 0.5)
				
				await U.set_timeout(1.0)
				
				for index in range(0, TitleLetterContainers.get_child_count()):
					var letter_node:Control = TitleLetterContainers.get_child(index)
					await letter_node.end()
					
				await U.tween_node_property(TitleBGLabel, 'modulate', Color(1, 1, 1, 0), 2.0)				
				
			current_mode = MODE.WAIT_FOR_INPUT
		# ---------
		MODE.WAIT_FOR_INPUT:	
			if !DEBUG.get_val(DEBUG.INTRO_SKIP_STARTAT):

				U.tween_node_property(PressStartMainPanel, 'position:y', control_pos[PressStartMainPanel].show)
				await U.tween_node_property(PressStartPanel, 'modulate', Color(1, 1, 1, 1), 0.7)
				await user_input
			
				U.tween_node_property(PressStartMainPanel, 'position:y', control_pos[PressStartMainPanel].hide)
				await U.tween_node_property(PressStartPanel, 'modulate', Color(1, 1, 1, 0), 0.3)
				
				#GBL.find_node(REFS.AUDIO).fade_out(2.0)
				await U.tween_node_property(SceneCamera, 'fov', 100, 2.0)
			
			current_mode = MODE.EXIT
		# ---------
		MODE.EXIT:
			end()
# ---------------------------------------------

# ---------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or current_mode != MODE.WAIT_FOR_INPUT:return
	user_input.emit()
# ---------------------------------------------
