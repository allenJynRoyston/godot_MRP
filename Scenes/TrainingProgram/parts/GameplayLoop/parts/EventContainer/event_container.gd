extends GameContainer

@onready var PanelRoot:PanelContainer = $"."
@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var RightControlPanel:PanelContainer = $RightControl/PanelContainer
@onready var LeftControlPanel:PanelContainer = $LeftControl/PanelContainer
@onready var ContentControlPanel:MarginContainer	 = $ContentControl/MarginContainer

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

@onready var BtnControlPanel:MarginContainer = $BtnControl/MarginContainer
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var NextBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/NextBtn
@onready var SelectBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/SelectBtn

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
		
var current_controls:CONTROLS = CONTROLS.FREEZE 
var event_output:Dictionary = {}
var has_more:bool = true
var text_reveal_tween:Tween


signal text_phase_complete

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	reset()
	reset_content_nodes()
	
	for btn in [SelectBtn, NextBtn]:
		btn.onClick = func() -> void:
			match current_controls:
				CONTROLS.TEXT_REVEAL:
					next_text(true)
				CONTROLS.OPTIONS:					
					on_option_select()
	
	hide()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()
	
	control_pos_default[BtnControlPanel] = BtnControlPanel.position
	control_pos_default[RightControlPanel] = RightControlPanel.position
	control_pos_default[LeftControlPanel] = LeftControlPanel.position
	control_pos_default[ContentControlPanel] = ContentControlPanel.position
	
	update_control_pos()
	on_is_showing_update()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos() -> void:	
	await U.tick()
	var h_diff:int = (1080 - 720) # difference between 1080 and 720 resolution - gives you 360
	var y_diff =  (0 if !GBL.is_fullscreen else h_diff) if !initalized_at_fullscreen else (0 if GBL.is_fullscreen else -h_diff)
	
	# center elements
	control_pos[ContentControlPanel] = {
		"show": control_pos_default[ContentControlPanel].y, 
		"hide": control_pos_default[ContentControlPanel].y - ContentControlPanel.size.y
	}
		
	# for elements in the bottom left corner
	control_pos[BtnControlPanel] = {
		"show": control_pos_default[BtnControlPanel].y + y_diff, 
		"hide": control_pos_default[BtnControlPanel].y + y_diff + BtnControlPanel.size.y
	}
	
	control_pos[LeftControlPanel] = {
		"show": control_pos_default[LeftControlPanel].y + y_diff, 
		"hide": control_pos_default[LeftControlPanel].y + y_diff + LeftControlPanel.size.y
	}
	
	# for eelements in the top right
	control_pos[RightControlPanel] = {
		"show": control_pos_default[RightControlPanel].y, 
		"hide": control_pos_default[RightControlPanel].y - RightControlPanel.size.y
	}	

	on_current_mode_update(true)
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------		
func on_is_showing_update() -> void:
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return	
	match current_mode:
		MODE.HIDE:
			for btn in [SelectBtn, NextBtn]:
				btn.is_disabled = true
			await U.tween_node_property(RightControlPanel, "position:y", control_pos[RightControlPanel].hide, 0 if skip_animation else 0.3)
			await U.tween_node_property(LeftControlPanel, "position:y", control_pos[LeftControlPanel].hide, 0 if skip_animation else 0.3)
			await U.tween_node_property(ContentControlPanel, "position:y", control_pos[ContentControlPanel].hide, 0 if skip_animation else 0.3)
			await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide, 0 if skip_animation else 0.3)
			await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0), 0 if skip_animation else 0.3)
			is_showing = false
		MODE.ACTIVE:
			for btn in [SelectBtn, NextBtn]:
				btn.is_disabled = false				
			SelectBtn.hide()
			await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1), 0 if skip_animation else 0.3)				
			await U.tween_node_property(ContentControlPanel, "position:y", control_pos[ContentControlPanel].show, 0 if skip_animation else 0.3)			
			U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show, 0 if skip_animation else 0.3)

# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reset() -> void:
	if !is_node_ready():return
	update_next_btn(false)
	
	current_controls = CONTROLS.FREEZE
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
func start() -> void:
	current_mode = MODE.ACTIVE
	current_controls = CONTROLS.TEXT_REVEAL
	if event_data.size() > 0:
		next_event()
	else:
		end()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:
	current_mode = MODE.HIDE
	await U.set_timeout(1.5)
	user_response.emit(event_output)
	update_next_btn(true)
	reset()
	reset_content_nodes()	
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
		NextBtn.title = "CLOSE"
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
		NextBtn.title = "NEXT" if is_active else "SKIP"
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
	# -----------------------------------
	
	# -----------------------------------
	if "portrait" in current_instruction:
		var p_details:Dictionary = current_instruction.portrait
		ContentProfileTextureRect.texture = CACHE.fetch_image(p_details.img_src if "img_src" in p_details else "")
		ContentHeaderLabel.text = p_details.title if "title" in p_details else "[REDACTED]"
		await U.tween_node_property(LeftControlPanel, "position:y", control_pos[LeftControlPanel].show)
	# -----------------------------------

	# -----------------------------------
	if "set_return_val" in current_instruction:
		event_output = current_instruction.set_return_val.call()
	# -----------------------------------

	# -----------------------------------
	if "text" in current_instruction:
		if current_instruction.text.size() > 0:
			current_controls = CONTROLS.TEXT_REVEAL
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
		
		NextBtn.hide()
		SelectBtn.show()

		for child in OptionsListContainer.get_children():
			child.queue_free()			
		
		var readiness_level:int = 1 #room_config.floor[current_location.floor].ring[current_location.ring].metrics[RESOURCE.BASE_METRICS.READINESS]
		var options:Array = current_instruction.options
		
		var compromised_count:int = 0
		for index in options.size():
			var option:Dictionary = options[index]
			var new_node:Control = OptionListItem.instantiate()
			var include:bool = option.include if "include" in option else true
			var completed:bool = option.completed if "completed" in option else false
			var locked:bool = option.locked if "locked" in option else false
			var show_description:bool = readiness_level >= 1
			
			# AT READINESS BELOW 0, OPTIONS HAVE DEBUFFS
			#if readiness_level < 0 and options.size() > 1 and option.val != -1:
				#if index <= absi(readiness_level):
					#option.title = "??? [READINESS COMPROMISED]"
					#option.icon = SVGS.TYPE.LOCK
					#if readiness_level <= -3:
						#option.title = "UNAVAILABLE [READINESS COMPROMISED]"
						#locked = true
				
			if include:
				new_node.data = option
				new_node.index = index 
				new_node.is_locked = locked
				new_node.show_description = show_description
				new_node.is_selected = option_selected_index == index
				new_node.onFocus = func(node:Control) -> void:
					if node == new_node:
						option_selected_index = index
				new_node.onClick = func() -> void:
					on_option_select()
				OptionsListContainer.add_child(new_node)
		
		await U.tick()
		var expand_current_val:float = ContentVBox.get('theme_override_constants/separation')
		U.tween_node_property(OptionsContainer, "modulate", Color(1, 1, 1, 1))
		await U.tween_range(expand_current_val, 10.0, 0.7, func(val:float) -> void:
			ContentVBox.set("theme_override_constants/separation", val)
		).finished 		

		# wait for input
		current_controls = CONTROLS.OPTIONS
		
		update_next_btn(true)
		
	# -----------------------------------
	else:
		NextBtn.show()
		SelectBtn.hide()
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
	if option_selected_index == -1 or OptionsListContainer.get_child(option_selected_index).is_locked:return
	
	current_controls = CONTROLS.FREEZE
	update_next_btn(false)
	
	var option:Dictionary = current_instruction.options[option_selected_index]
	
	NextBtn.show()
	SelectBtn.hide()	
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

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree():return
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match current_controls:
		CONTROLS.OPTIONS:
			match key:
				"S":
					option_selected_index = U.min_max(option_selected_index + 1, 0, current_instruction.options.size() - 1, true)
				"W":
					option_selected_index = U.min_max(option_selected_index - 1, 0, current_instruction.options.size() - 1, true)
# --------------------------------------------------------------------------------------------------	
