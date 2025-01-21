@tool
extends GameContainer

@onready var PanelRoot:PanelContainer = $SubViewport/PanelContainer
@onready var HeaderLabel:Label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HeaderLabel

@onready var DialogBtn:Control = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/DialogBtn
@onready var ImageContainer:Control = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ImageContainer
@onready var ImageTextureRect:TextureRect = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ImageContainer/MarginContainer/ImageTextureRect

@onready var PortraitContainer:Control = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PortraitContainer
@onready var PortraitNameLabel:Label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PortraitContainer/HBoxContainer/PortraitNameLabel
@onready var PortraitTextureRect:TextureRect = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PortraitContainer/MarginContainer/PortraitTexture

@onready var BodyContainer:Control = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer
@onready var BodyLabelBtm:Label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/PanelContainer/BodyLabelBtm
@onready var BodyLabelTop:Label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/PanelContainer/BodyLabelTop

@onready var OptionsContainer:Control = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/OptionsContainer
@onready var OptionsListContainer:VBoxContainer = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/OptionsContainer/HBoxContainer/OptionListContainer
@onready var NoteContainer:VBoxContainer = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/OptionsContainer/HBoxContainer/NoteContainer

@onready var NextBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/NextBtn

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

var current_controls:CONTROLS = CONTROLS.FREEZE 
var event_output:Dictionary = {}

var text_reveal_tween:Tween

signal text_phase_complete

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	reset()
	reset_content_nodes()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_is_showing_update() -> void:
	super.on_is_showing_update()
	if !is_showing:
		reset()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reset() -> void:
	if !is_node_ready():return
	update_next_btn(false)
	NextBtn.title = ""
	PanelRoot.modulate = Color.TRANSPARENT
	
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
	for node in [OptionsContainer, ImageContainer, BodyContainer, NoteContainer, OptionsContainer, PortraitContainer]:
		node.hide()
	PanelRoot.modulate = Color(1, 1, 1, 0)
	HeaderLabel.text = ""
	BodyLabelBtm.text = ""
	BodyLabelTop.text = ""
	
	for node in [NoteContainer, OptionsListContainer]:
		for child in node.get_children():
			child.queue_free()	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func start() -> void:
	if event_data.size() > 0:
		next_event()
	else:
		end()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:
	current_controls = CONTROLS.FREEZE
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
		
	if current_event_instruction.is_empty() or instruction_index >= current_event_instruction.event_instructions.size():
		next_event(true)	
	else:
		current_event_instruction = event_data[event_instruction_index]
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func next_text(inc:bool = false) -> void:
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
	NextBtn.static_color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE if is_active else COLORS.TEXT.INVALID_INACTIVE)
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
		HeaderLabel.text = "%s" % [current_instruction.header]
	# -----------------------------------
	
	# -----------------------------------
	if "img_src" in current_instruction:
		ImageContainer.show()
		ImageTextureRect.texture = CACHE.fetch_image(current_instruction.img_src)
	# -----------------------------------
	
	# -----------------------------------
	if "portrait" in current_instruction:
		var p_details:Dictionary = current_instruction.portrait
		PortraitContainer.show()
		PortraitNameLabel.text = p_details.title if "title" in p_details else "[REDACTED]"
		PortraitTextureRect.texture = CACHE.fetch_image(p_details.img_src if "img_src" in p_details else "")
	# -----------------------------------

	# -----------------------------------
	if "set_return_val" in current_instruction:
		event_output = current_instruction.set_return_val.call()
	# -----------------------------------

	# -----------------------------------
	if "text" in current_instruction:
		if current_instruction.text.size() > 0:
			DialogBtn.icon = SVGS.TYPE.CONVERSATION
			BodyContainer.show()
			text_index = 0
			current_text = current_instruction.text[0]
			# change controls to wait for input 
			current_controls = CONTROLS.TEXT_REVEAL
			# wait for all texts in array to finish before being allowed to continue
			await text_phase_complete
	#else:
		#BodyContainer.hide()
		#BodyLabelBtm.text = ""
		#BodyLabelTop.text = ""
	# -----------------------------------
	
	# -----------------------------------
	if "options" in current_instruction:
		update_next_btn(false)
		OptionsContainer.show()
		NoteContainer.hide()
		
		option_selected_index = 0
		DialogBtn.icon = SVGS.TYPE.QUESTION_MARK
		
		for child in OptionsListContainer.get_children():
			child.queue_free()			
		
		var options:Array = current_instruction.options
		for index in options.size():
			var option:Dictionary = options[index]
			var new_node:Control = OptionListItem.instantiate()
			var include:bool = option.include if "include" in option else true
			var completed:bool = option.completed if "completed" in option else false
			var locked:bool = option.locked if "locked" in option else false
			
			if include:
				new_node.data = option
				new_node.index = index 
				new_node.is_selected = option_selected_index == index
				new_node.onFocus = func(node:Control) -> void:
					if node == new_node:
						option_selected_index = index
				new_node.onClick = func() -> void:
					on_option_select()
				OptionsListContainer.add_child(new_node)
			
		
		await U.set_timeout(0.5)
		
		# wait for input
		current_controls = CONTROLS.OPTIONS
		update_next_btn(true)
		
	# -----------------------------------
	else:
		next_instruction(true)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_option_select() -> void:
	current_controls = CONTROLS.FREEZE
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
		if "val" in current_instruction.options[option_selected_index]:
			var val = current_instruction.options[option_selected_index].val
			current_instruction.options[option_selected_index].onSelected.call(val)
		# else, send the index
		else:
			current_instruction.options[option_selected_index].onSelected.call(option_selected_index)
	
	await U.set_timeout(1.0)
	
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
	if !is_showing:return
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match current_controls:
		CONTROLS.TEXT_REVEAL:
			match key:
				"ENTER":
					next_text(true)
				"E":
					next_text(true)
					
		CONTROLS.OPTIONS:
			match key:
				"ENTER":
					on_option_select()
				"E":
					on_option_select()
				"S":
					option_selected_index = U.min_max(option_selected_index + 1, 0, current_instruction.options.size() - 1, true)
				"W":
					option_selected_index = U.min_max(option_selected_index - 1, 0, current_instruction.options.size() - 1, true)
# --------------------------------------------------------------------------------------------------	
