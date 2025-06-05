extends PanelContainer

enum MODE {INIT, START, DISPLAY_LOGO, DISPLAY_TITLE, DISPLAY_SIDE_TEXT, WAIT_FOR_INPUT, EXIT}

@onready var RenderSubviewport:SubViewport = $RenderSubviewport
@onready var TextureRender:TextureRect = $TextureRender
@onready var ColorBG:ColorRect = $ColorBG

@onready var SceneCamera:Camera3D = $RenderSubviewport/Node3D/Camera3D

@onready var LogoPanel:MarginContainer = $Logo/MarginContainer
@onready var LogoTextureRect:TextureRect = $Logo/MarginContainer/CenterContainer/Control/TextureRect

@onready var TitlePanel:MarginContainer = $Title/MarginContainer
@onready var TitleBGLabel:Label = $Title/MarginContainer/CenterContainer/TitleBGLabel
@onready var TitleLetterContainers:HBoxContainer = $Title/MarginContainer/CenterContainer/TitleLetterContainers

@onready var CreditsPanel:PanelContainer = $Credits/PanelContainer
@onready var CreditsMarginPanel:MarginContainer = $Credits/PanelContainer/MarginContainer
@onready var CreditLabel:Label = $Credits/PanelContainer/MarginContainer/HBoxContainer/CreditLabel

@onready var PressStartPanel:PanelContainer = $PressStart/PanelContainer
@onready var PressStartGameLabel:Label = $PressStart/PanelContainer/MarginContainer/VBoxContainer/GameTitle
@onready var PressStartMainPanel:MarginContainer = $PressStart/PanelContainer/MarginContainer

@onready var ScpControl:Control = $SCP

const game_title:String = "THE VOID LAYER"
const BlurInLetterPreload:PackedScene = preload("res://Scenes/IntroAndTitleScreen/parts/BlurInLetter.tscn")

var control_pos:Dictionary = {}

var current_mode:MODE = MODE.INIT : 
	set(val):
		current_mode = val
		on_current_mode_update()

signal user_input
signal on_continue

var on_end:Callable = func():pass

var containment_description:String = "Standard Containt Procedures:  If you are reading this, then you are currently under the influence of SCP-[  ] and subject to its effects.  Resistencing these effects is both important and nnecessary for your survival."
var script_description:String = "SCP-[   ] is an unknown entitity actively engaging with our reality.  How this is done, and the motives for doing so, are both unknown, but is considered to be an immediate and serious escalation."
var danger_description:String = "BREACH DETECTED, FRACTURE IMMINENENT"
# ---------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)


func _ready() -> void:
	_after_ready.call_deferred()
	on_current_mode_update()
# ---------------------------------------------

# ---------------------------------------------
func _after_ready() -> void:
	modulate = Color(1, 1, 1, 0)
	TitleBGLabel.modulate = Color(1, 1, 1, 0)
	#ScpControl.modulate = Color(1, 1, 1, 0)
	PressStartGameLabel.text = "SCP: %s" % [game_title]
	ColorBG.show()
	
	for child in TitleLetterContainers.get_children():
		child.queue_free()
	
	for letter in game_title:
		var new_label:Control = BlurInLetterPreload.instantiate()
		new_label.text = str(letter)
		new_label.modulate = Color(1, 1, 1, 0)
		TitleLetterContainers.add_child(new_label)
	
	await U.tick()
	control_pos[CreditsMarginPanel] = {"hide": CreditsMarginPanel.position.y, "show": CreditsMarginPanel.position.y - 10}
	control_pos[PressStartMainPanel] = {"hide": PressStartMainPanel.position.y, "show": PressStartMainPanel.position.y - 10}
# ---------------------------------------------	

# ---------------------------------------------
func start() -> void:
	set_process(true)
	show()
	current_mode = MODE.START

func end() -> void:
	set_process(false)
	hide()
	on_end.call()
	current_mode = MODE.INIT
# ---------------------------------------------

# ---------------------------------------------
func on_current_mode_update() -> void:
	if !is_node_ready():return
	match current_mode:
		# ---------
		MODE.INIT:
			RenderSubviewport.set_process(false)
			RenderSubviewport.get_child(0).hide()
			
			for node in [ColorBG, TextureRender]:
				node.show()

			ColorBG.color = Color.BLACK			
		# ---------
		MODE.START:	
			RenderSubviewport.get_child(0).show()
			SceneCamera.fov = 100
			for node in [LogoPanel, TitlePanel, CreditsPanel, PressStartPanel]:
				node.modulate = Color(1, 1, 1, 0)
							
			modulate = Color(1, 1, 1, 1)
			await U.tick()
			current_mode = MODE.DISPLAY_LOGO			
		# ---------
		MODE.DISPLAY_LOGO:
			if !DEBUG.get_val(DEBUG.INTRO_SKIP_LOGO):
				# fade in
				U.tween_node_property(LogoTextureRect, 'scale:x', 1.05, 4.0, 1.0, Tween.TRANS_LINEAR)
				U.tween_node_property(LogoTextureRect, 'scale:y', 1.05, 4.0, 1.0, Tween.TRANS_LINEAR)
				await U.tween_node_property(LogoPanel, 'modulate', Color(1, 1, 1, 1), 5.0, 0.3)
				
				await U.set_timeout(1.0)
				# fade out
				U.tween_node_property(LogoTextureRect, 'scale:x', 1, 4.0, 1.0, Tween.TRANS_LINEAR)
				U.tween_node_property(LogoTextureRect, 'scale:y', 1, 4.0, 1.0, Tween.TRANS_LINEAR)
				await U.tween_node_property(LogoPanel, 'modulate', Color(1, 1, 1, 0), 5.0)
			
			current_mode = MODE.DISPLAY_TITLE
		# ---------
		MODE.DISPLAY_TITLE:
			RenderSubviewport.set_process(true)
			TextureRender.show()
			TitlePanel.get_parent().show()
			U.tween_node_property(TitlePanel, 'modulate', Color(1, 1, 1, 1), 3.0)
			await U.tween_node_property(ColorBG, 'modulate', Color(1, 1, 1, 0), 3.0)
			U.tween_node_property(SceneCamera, 'fov', 80, 10.0)
			
			if !DEBUG.get_val(DEBUG.INTRO_SKIP_TITLE):
				await U.tween_node_property(TitleBGLabel, 'modulate', Color(1, 1, 1, 1), 2.0)
				for index in range(0, TitleLetterContainers.get_child_count()):
					var letter_node:Control = TitleLetterContainers.get_child(index)
					await letter_node.start()
				await U.set_timeout(2.0)
				for index in range(0, TitleLetterContainers.get_child_count()):
					var letter_node:Control = TitleLetterContainers.get_child(index)
					await letter_node.end()
				await U.tween_node_property(TitleBGLabel, 'modulate', Color(1, 1, 1, 0), 2.0)
				
				TitlePanel.get_parent().hide()
				
			current_mode = MODE.DISPLAY_SIDE_TEXT
		# ---------
		MODE.DISPLAY_SIDE_TEXT:
			CreditsPanel.get_parent().show()
			
			if !DEBUG.get_val(DEBUG.INTRO_SKIP_SEQUENCE):
				for item in [{"text": 'A GAME BY ALLEN ROYSTON', "wait": 0.6}, {"text": 'CREATING SAVE FILE', "wait": 0.8}, {"text": 'SAVE FILE LOADED.', "wait": 0.8}]:
					CreditsMarginPanel.position.y = control_pos[CreditsMarginPanel].hide
					CreditLabel.text = item.text
					CreditLabel.modulate = Color(1, 1, 1, 0)
					
					await U.tick()
					U.tween_node_property(CreditLabel, 'modulate', Color(1, 1, 1, 1), 0.4)
					U.tween_node_property(CreditsPanel, 'modulate', Color(1, 1, 1, 1), 0.7)
					await U.tween_node_property(CreditsMarginPanel, 'position:y', control_pos[CreditsMarginPanel].show, 0.4, Tween.TRANS_LINEAR)
					await U.set_timeout(item.wait)
					U.tween_node_property(CreditsMarginPanel, 'position:y', control_pos[CreditsMarginPanel].show - 10, 0.4, Tween.TRANS_LINEAR)
					await U.tween_node_property(CreditLabel, 'modulate', Color(1, 1, 1, 0), 0.4)
				
				U.tween_node_property(SceneCamera, 'fov', 60, 4.0)
				await U.tween_node_property(CreditsPanel, 'modulate', Color(1, 1, 1, 0), 0.5)
				
			CreditsPanel.get_parent().hide()
			current_mode = MODE.WAIT_FOR_INPUT
		# ---------
		MODE.WAIT_FOR_INPUT:
			PressStartPanel.get_parent().show()
			
			U.tween_node_property(PressStartMainPanel, 'position:y', control_pos[PressStartMainPanel].show, 0.7)
			if !DEBUG.get_val(DEBUG.INTRO_SKIP_STARTAT):
				await U.tween_node_property(PressStartPanel, 'modulate', Color(1, 1, 1, 1), 0.7)
				await user_input
			
			U.tween_node_property(PressStartMainPanel, 'position:y', control_pos[PressStartMainPanel].hide, 0.7)			
			U.tween_node_property(PressStartPanel, 'modulate', Color(1, 1, 1, 0), 0.7, 0.3)
			await U.set_timeout(1.0)
			U.tween_node_property(SceneCamera, 'fov', 100, 4.0)
			await U.set_timeout(2.5)
			on_continue.emit()			
			await U.tween_node_property(ColorBG, 'modulate', Color(1, 1, 1, 1), 3.0)
			
			current_mode = MODE.EXIT
		# ---------
		MODE.EXIT:
			await U.set_timeout(2.0)
			end()

# ---------------------------------------------

# ---------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or current_mode != MODE.WAIT_FOR_INPUT:return
	user_input.emit()
# ---------------------------------------------
