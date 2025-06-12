extends GameContainer

@onready var PanelRoot:PanelContainer = $"."
@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var RightControlPanel:PanelContainer = $RightControl/PanelContainer
@onready var RightControlMargin:MarginContainer = $RightControl/PanelContainer/MarginContainer

#@onready var LeftControlPanel:PanelContainer = $LeftControl/PanelContainer
@onready var ContentControlPanel:MarginContainer	 = $ContentControl/MarginContainer
@onready var TransitionScreen:Control = $TransistionScreen

@onready var LeftHeaderLabel:Label = $LeftControl/PanelContainer/MarginContainer/VBoxContainer/OutputTexture/MarginContainer/HeaderLabel
@onready var LeftTextureRect:TextureRect = $LeftControl/PanelContainer/MarginContainer/VBoxContainer/OutputTexture/SubViewport/TextureRect
@onready var LeftFooterLabel:Label = $LeftControl/PanelContainer/MarginContainer/VBoxContainer/FooterLabel

@onready var RightHeaderLabel:Label = $RightControl/PanelContainer/MarginContainer/VBoxContainer/OutputTexture/MarginContainer/HeaderLabel
@onready var RightTextureRect:TextureRect = $RightControl/PanelContainer/MarginContainer/VBoxContainer/OutputTexture/SubViewport/TextureRect
@onready var RightFooterLabel:Label = $RightControl/PanelContainer/MarginContainer/VBoxContainer/FooterLabel

@onready var DialogBtn:Control = $ContentControl/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/DialogBtn
@onready var ContentVBox:VBoxContainer = $ContentControl/MarginContainer/VBoxContainer
@onready var ContentHeaderLabel:Label = $ContentControl/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Header/ContentHeaderLabel
@onready var ContentProfileTextureRect:TextureRect = $ContentControl/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ProfileOutput/SubViewport/ContentProfileTextureRect
@onready var BodyContainer:Control = $ContentControl/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer
@onready var BodyLabelBtm:Label = $ContentControl/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/PanelContainer/BodyLabelBtm
@onready var BodyLabelTop:Label = $ContentControl/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/PanelContainer/BodyLabelTop

@onready var OptionsContainer:Control = $ContentControl/MarginContainer/VBoxContainer/OptionsContainer
@onready var OptionsListContainer:VBoxContainer = $ContentControl/MarginContainer/VBoxContainer/OptionsContainer/HBoxContainer/OptionListContainer
@onready var NoteContainer:VBoxContainer = $ContentControl/MarginContainer/VBoxContainer/OptionsContainer/HBoxContainer/NoteContainer

@onready var BtnControls:Control = $BtnControls

enum MODE {HIDE, ACTIVE}
enum CONTROLS {FREEZE, TEXT_REVEAL, OPTIONS}

const OptionListItem:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/EventContainer/parts/OptionListItem.tscn")
const OptionNoteItem:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/EventContainer/parts/OptionNoteItem.tscn")

var event_data:Array = [] 	
var event_instructions:Array = []
var option_selected_index:int = 0 : 
	set(val):
		option_selected_index = val
		on_option_selected_index()


var event_instruction_index:int = 0
var current_event_instruction:Dictionary = {} : 
	set(val):
		current_event_instruction = val
		if !current_event_instruction.is_empty():
			on_current_event_instruction_update()

var instruction_index:int = 0
var current_instruction:Dictionary = { } : 
	set(val):
		current_instruction = val
		on_current_instruction_update()

var text_index:int = 0
var current_text:String = "" : 
	set(val):
		current_text = val
		on_current_text_update()

var current_mode:MODE = MODE.HIDE : 
	set(val):
		current_mode = val
		on_current_mode_update()
		
#var current_controls:CONTROLS = CONTROLS.FREEZE 
var event_output:Dictionary = {}
var has_more:bool = true
var text_reveal_tween:Tween


signal text_phase_complete

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	self.modulate = Color(1, 1, 1, 0)
		
	reset()
	reset_content_nodes()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	# center elements
	control_pos[ContentControlPanel] = {
		"show": 0, 
		"hide": -ContentControlPanel.size.y
	}


	control_pos[RightControlPanel] = {
		"show": 0, 
		"hide": RightControlMargin.size.y
	}	


	ContentControlPanel.position.y = control_pos[ContentControlPanel].hide	
	RightControlPanel.position.y = control_pos[RightControlPanel].hide
	
	await U.tick()
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return	
	var duration:float = 0 if skip_animation else 0.3
	
	match current_mode:
		# ---------
		MODE.ACTIVE:
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1), duration)				
			U.tween_node_property(ContentControlPanel, "position:y", control_pos[ContentControlPanel].show, duration)			
			await BtnControls.reveal(true)
			BtnControls.disable_back_btn = true
			BtnControls.onBack = func() -> void:pass
			BtnControls.onAction = func() -> void:pass
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reset() -> void:
	if !is_node_ready():return
	update_next_btn(false)
	
	#current_controls = CONTROLS.FREEZE
	current_event_instruction = {} 
	current_instruction = {} 
	
	event_instruction_index = 0
	instruction_index = 0
	text_index = 0
	event_output = {}
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reset_content_nodes() -> void:
	#HeaderLabel.text = ""
	BodyLabelBtm.text = ""
	BodyLabelTop.text = ""
	
	for node in [NoteContainer, OptionsListContainer]:
		for child in node.get_children():
			child.queue_free()	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func start(new_event_data:Array) -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))				
	await TransitionScreen.start()	
	
	event_data = new_event_data
	current_mode = MODE.ACTIVE
	if event_data.size() > 0:
		next_event()
	else:
		end()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:
	BtnControls.reveal(false)
	U.tween_node_property(RightControlPanel, "position:y", control_pos[RightControlPanel].hide)
	#U.tween_node_property(LeftControlPanel, "position:y", control_pos[LeftControlPanel].hide)
	await U.tween_node_property(ContentControlPanel, "position:y", control_pos[ContentControlPanel].hide)
	
	TransitionScreen.end()	
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 0) )
	
	user_response.emit(event_output)
	queue_free()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func next_event(inc:bool = false) -> void:
	if inc:
		event_instruction_index += 1

	
	if event_instruction_index >= event_data.size():
		end()
	else:
		reset_content_nodes()
		instruction_index = 0
		current_event_instruction = event_data[event_instruction_index]
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func next_instruction(inc:bool = false) -> void:
	if inc:
		instruction_index += 1
	
	if instruction_index + 1 >= current_event_instruction.event_instructions.size():
		BtnControls.a_btn_title = "CLOSE"
		BtnControls.onAction = func() -> void:
			end()
		has_more = false
	else:
		has_more = true
		
	if current_event_instruction.is_empty() or instruction_index >= current_event_instruction.event_instructions.size():
		next_event(true)	
	else:
		current_event_instruction = event_data[event_instruction_index]
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func next_text(inc:bool = false) -> void:
	if text_reveal_tween == null:return
	
	if text_reveal_tween.is_running():
		text_reveal_tween.stop()
		BodyLabelTop.visible_ratio = 1.0
		update_next_btn(true)
		return

	if inc:
		text_index += 1
		
	
	if text_index >= current_instruction.text.size():		
		text_phase_complete.emit()
	else:
		current_text = current_instruction.text[text_index]
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func update_next_btn(is_active:bool) -> void:	
	if has_more:
		BtnControls.a_btn_title = "NEXT" if is_active else "SKIP"
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_event_instruction_update() -> void:
	current_instruction = current_event_instruction.event_instructions[instruction_index].call()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_text_update() -> void:
	update_next_btn(false)
	BodyLabelBtm.text = current_text
	BodyLabelTop.text = current_text
	await tween_text_reveal(current_text.length() * 0.01)
	update_next_btn(true)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_instruction_update() -> void:
	if !is_node_ready() or current_instruction.is_empty():return
	update_next_btn(false)
	
	# allows for a smoother transition in
	tween_reveal(PanelRoot, "modulate", Color(1, 1, 1, 1), 0.7)
	BtnControls.itemlist = []
	BtnControls.onAction = func() -> void:pass			
	
	# -----------------------------------
	if "header" in current_instruction:
		ContentHeaderLabel.text = "%s" % [current_instruction.header]
	# -----------------------------------
	
	# -----------------------------------
	if "img_src" in current_instruction:		
		RightTextureRect.texture = CACHE.fetch_image(current_instruction.img_src)
		RightHeaderLabel.text = "VIDEO FEED"
		RightFooterLabel.text = "" # not currently used
		await U.tween_node_property(RightControlPanel, "position:y", control_pos[RightControlPanel].show)
	else:
		await U.set_timeout(0.3)
	# -----------------------------------
	
	# -----------------------------------
	if "portrait" in current_instruction:
		var p_details:Dictionary = current_instruction.portrait
		ContentProfileTextureRect.texture = CACHE.fetch_image(p_details.img_src if "img_src" in p_details else "")
		ContentHeaderLabel.text = p_details.title if "title" in p_details else "[REDACTED]"
		#await U.tween_node_property(LeftControlPanel, "position:y", control_pos[LeftControlPanel].show)
	# -----------------------------------

	# -----------------------------------
	if "set_return_val" in current_instruction:
		event_output = current_instruction.set_return_val.call()
	# -----------------------------------

	# -----------------------------------
	if "text" in current_instruction:
		if current_instruction.text.size() > 0:
			BtnControls.onAction = func() -> void:
				next_text(true)
			DialogBtn.icon = SVGS.TYPE.CONVERSATION
			BodyContainer.show()
			text_index = 0
			current_text = current_instruction.text[0]
			# change controls to wait for input 
			# wait for all texts in array to finish before being allowed to continue
			await text_phase_complete
	# -----------------------------------

	# -----------------------------------
	if "options" in current_instruction:
		update_next_btn(false)
		NoteContainer.hide()
		
		option_selected_index = 0
		DialogBtn.icon = SVGS.TYPE.QUESTION_MARK

		for child in OptionsListContainer.get_children():
			child.queue_free()			
		
		var options:Array = current_instruction.options
		
		var compromised_count:int = 0
		for index in options.size():
			var option:Dictionary = options[index]
			var new_node:Control = OptionListItem.instantiate()
			var include:bool = option.include if "include" in option else true
			var completed:bool = option.completed if "completed" in option else false
			var locked:bool = option.locked if "locked" in option else false
			var show_description:bool = true
			
			if include:
				new_node.data = option
				new_node.index = index 
				new_node.is_locked = locked
				new_node.show_description = show_description
				new_node.is_selected = option_selected_index == index
				new_node.onFocus = func(node:Control) -> void:
					option_selected_index = index
				new_node.onClick = func() -> void:
					option_selected_index = index
					on_option_select()
					
				OptionsListContainer.add_child(new_node)
		
		await U.tick()
		var expand_current_val:float = ContentVBox.get('theme_override_constants/separation')
		U.tween_node_property(OptionsContainer, "modulate", Color(1, 1, 1, 1))
		await U.tween_range(expand_current_val, 10.0, 0.7, func(val:float) -> void:
			ContentVBox.set("theme_override_constants/separation", val)
		).finished 		

		# wait for input
		#current_controls = CONTROLS.OPTIONS
		
		BtnControls.itemlist = OptionsListContainer.get_children()
		BtnControls.directional_pref = "UD"
		
		update_next_btn(true)
		
	# -----------------------------------
	else:
		var expand_current_val:float = ContentVBox.get('theme_override_constants/separation')
		if expand_current_val != -200:
			U.tween_node_property(OptionsContainer, "modulate", Color(1, 1, 1, 0))
			await U.tween_range(expand_current_val, -200, 0.7, func(val:float) -> void:
				ContentVBox.set("theme_override_constants/separation", val)
			).finished 
			
			for child in OptionsListContainer.get_children():
				child.free()
		next_instruction(true)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_option_select() -> void:
	if option_selected_index == -1 or option_selected_index > OptionsListContainer.get_child_count() or OptionsListContainer.get_child(option_selected_index).is_locked:return
	
	update_next_btn(false)
	
	var option:Dictionary = current_instruction.options[option_selected_index]
	NoteContainer.hide()
	
	for index in OptionsListContainer.get_child_count():
		var node:Control = OptionsListContainer.get_child(index)
		node.is_enabled = false
		if index != option_selected_index:
			node.fade_out() 

	if "onSelected" in option:
		# if selected val property is available, send it
		option.onSelected.call({"index": option_selected_index, "option": option})
		
	await U.set_timeout(0.3)
	
	# goto next instruction
	next_instruction(true)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_option_selected_index() -> void:
	if !is_node_ready():return
	for child in OptionsListContainer.get_children():
		child.is_selected = option_selected_index == child.index
	
	var options:Array = current_instruction.options
	var option:Dictionary = options[option_selected_index]

	for child in NoteContainer.get_children():
		child.queue_free()	
	NoteContainer.hide()
	
	if "notes" in option:
		NoteContainer.show()
		for data in option.notes:
			var new_node:Control = OptionNoteItem.instantiate()
			new_node.data = data
			NoteContainer.add_child(new_node)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func tween_reveal(node:Control, property:String, val:Color, duration:float = 0.5) -> void:
	var new_tween = create_tween()
	new_tween.tween_property(node, property, val, duration).set_trans(Tween.TRANS_LINEAR)
	new_tween.play()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func tween_text_reveal(duration:float = 0.3) -> void:
	BodyLabelTop.visible_ratio = 0
	text_reveal_tween = create_tween()
	text_reveal_tween.tween_property(BodyLabelTop, "visible_ratio", 1, duration).set_trans(Tween.TRANS_LINEAR).set_delay(0.3)
	text_reveal_tween.play()
	await text_reveal_tween.finished
	await U.set_timeout(0.5)
# --------------------------------------------------------------------------------------------------	
