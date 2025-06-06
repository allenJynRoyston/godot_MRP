extends Control

@onready var NarrationBG:ColorRect = $NarrationBG
@onready var StoryPanel:PanelContainer = $PanelContainer
@onready var BtnControls:Control = $BtnControls

@onready var PortraitPanel:PanelContainer = $PortraitPanel
@onready var PortraitMargin:MarginContainer = $PortraitPanel/MarginContainer

@onready var TextContainer:MarginContainer = $PanelContainer/TextContainer
@onready var TopLabel:Label = $PanelContainer/TextContainer/Control/TopLabel
@onready var BtmLabel:Label = $PanelContainer/TextContainer/BtmLabel

signal narration_complete

var control_pos:Dictionary = {}
var text_list:Array = [] : 
	set(val):
		text_list = val
		on_text_list_update()

var interupt:bool = false

signal on_end

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	pass

func _exit_tree() -> void:
	pass

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	await U.tick()
	
	control_pos[StoryPanel] = {
		"show": 0, 
		"hide": 20
	}
	
	control_pos[PortraitPanel]= {
		"show": 0, 
		"hide": 0 - PortraitMargin.size.x
	}
	
	
	TextContainer.modulate = Color(1, 1, 1, 0)
	NarrationBG.modulate = Color(1, 1, 1, 0)
	PortraitPanel.position.x = control_pos[PortraitPanel].hide
	StoryPanel.position.y = control_pos[StoryPanel].hide
	
	await U.tick()
	
	BtnControls.onBack = func() -> void:
		await BtnControls.reveal(false)		
		await reveal(false)		
		on_end.emit()
		
	BtnControls.onAction = func() -> void:
		interupt = true
		await U.tick()
		interupt = false
			
	
	BtnControls.reveal(false, true)
	reveal(false, true)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal(state:bool, skip_animation:bool = false) -> void:
	var new_val:int = control_pos[StoryPanel].show if state else control_pos[StoryPanel].hide
	var duration:float = 0 if skip_animation else 0.3

	
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), duration)
	U.tween_node_property(TextContainer, "modulate", Color(1, 1, 1, 0 if new_val else 1), duration)
	U.tween_node_property(StoryPanel, "position:y", new_val, duration)
		
	if state:
		show()
	
		U.tween_node_property(NarrationBG, "modulate", Color(1, 1, 1, 1), duration)
		await U.tween_node_property(PortraitPanel, "position:x", control_pos[PortraitPanel].show if state else control_pos[PortraitPanel].hide, 0.7, 1)
		fill_message()
		BtnControls.reveal(state)
				

	if !state:
		await U.tween_node_property(PortraitPanel, "position:x", control_pos[PortraitPanel].hide, 0.7 )
		await U.tween_node_property(NarrationBG, "modulate", Color(1, 1, 1, 0), duration)	#BtnControls.reveal(state)
		BtnControls.reveal(state)
		reset_message()
		hide()

	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_text_list_update() -> void:
	if !is_node_ready():return
	var message:String = ""
	for text in text_list:
		message += str(text, '\r\r')
	TopLabel.text = message
	BtmLabel.text = message
	
	TopLabel.visible_ratio = 0
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reset_message() -> void:
	if !is_node_ready():return
	TopLabel.visible_ratio = 0
	
	BtnControls.c_btn_title = "SKIP"
	
	BtnControls.onCBtn = func() -> void:
		interupt = true
		await U.tick()
		interupt = false		
	
func fill_message() -> void:
	var count:int = 0
	var message:String = TopLabel.text
	for letter in message:
		count += 1
		if interupt:
			TextContainer.position.y = control_pos[PortraitPanel].show
			PortraitPanel.position.x = control_pos[PortraitPanel].show
			TopLabel.visible_characters = message.length()
			# kill tweens
			break
		match letter:
			".":
				await U.set_timeout(0.4)
			",":
				await U.set_timeout(0.2)
			":":
				await U.set_timeout(0.2)					
			_:
				await U.tick()
		TopLabel.visible_characters = count
	
	BtnControls.c_btn_title = "CLOSE"
	
	BtnControls.onCBtn = func() -> void:
		await BtnControls.reveal(false)		
		await reveal(false)		
		on_end.emit()
	

# --------------------------------------------------------------------------------------------------
	
