extends GameContainer

@onready var PanelRoot:PanelContainer = $"."
@onready var BtnControls:Control = $BtnControls
@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var TransitionScreen:Control = $TransistionScreen

@onready var ImagePanel:PanelContainer = $ImageControl/PanelContainer
@onready var ImageMargin:MarginContainer = $ImageControl/PanelContainer/MarginContainer
@onready var ImageOutputTextureRect:TextureRect = $ImageControl/PanelContainer/MarginContainer/OutputTexture
@onready var ImageTextureRect:TextureRect = $ImageControl/PanelContainer/MarginContainer/SubViewport/TextureRect
@onready var ImageTitle:Label = $ImageControl/PanelContainer/MarginContainer2/VBoxContainer/Title
@onready var ImageSubTitle:Label = $ImageControl/PanelContainer/MarginContainer2/VBoxContainer/Subtitle
@onready var ContentPanel:PanelContainer	 = $ContentControl/PanelContainer
@onready var ContentMargin:MarginContainer = $ContentControl/PanelContainer/MarginContainer

@onready var DialogBtn:Control = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/DialogBtn
@onready var BodyContainer:Control = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer
@onready var BodyLabelBtm:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/PanelContainer/BodyLabelBtm
@onready var BodyLabelTop:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/PanelContainer/BodyLabelTop

@onready var OptionsContainer:Control = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/OptionsContainer
@onready var OptionsListContainer:VBoxContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/OptionsContainer/HBoxContainer/OptionListContainer
@onready var NoteContainer:VBoxContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/OptionsContainer/HBoxContainer/NoteContainer

@onready var ImageBG:TextureRect = $ImageControl/PanelContainer/MarginContainer/OutputTexture/SubViewport/TextureRect

enum MODE {HIDE, ACTIVE}
enum CONTROLS {FREEZE, TEXT_REVEAL, OPTIONS}

const OptionListItem:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/EventContainer/parts/OptionListItem.tscn")
const OptionNoteItem:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/EventContainer/parts/OptionNoteItem.tscn")

var SelectedNode:Control
var event_data:Array = [] 	
var event_instructions:Array = []
var option_selected_index:int = 0

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

#var current_mode:MODE = MODE.HIDE : 
	#set(val):
		#current_mode = val
		#on_current_mode_update()
		
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
	
	# setup btn controls
	BtnControls.onUpdate = func(_node:Control) -> void:
		for index in OptionsListContainer.get_child_count():
			var node:Control = OptionsListContainer.get_child(index)
			option_selected_index = index
			node.is_selected = node == _node	
			if node == _node:
				SelectedNode = node
		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	await U.tick()
	
	# center elements
	control_pos[ContentPanel] = {
		"show": 0, 
		"present": 100,
		"hide": -ContentMargin.size.y
		
	}

	ContentPanel.position.y = control_pos[ContentPanel].hide	

# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------		
func reset() -> void:
	if !is_node_ready():return
	update_next_btn(false)
	reveal_outputtexture(false, 0.0)	
	
	for node in [ImageTitle, ImageSubTitle]:
		node.text = ""	

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
	U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1))	
	await BtnControls.reveal(true)
	
	BtnControls.disable_back_btn = true
	BtnControls.onBack = func() -> void:pass
	BtnControls.onAction = func() -> void:pass

	await TransitionScreen.start()	
	
	event_data = new_event_data

	if event_data.size() > 0:
		next_event()
	else:
		end()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:
	BtnControls.reveal(false)
	TransitionScreen.end()
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 0) )
	
	user_response.emit(event_output)
	queue_free()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_outputtexture(state:bool, duration:float) -> void:
	var material_duplication:Material = ImageOutputTextureRect.material.duplicate()
	ImageOutputTextureRect.material = material_duplication
	
	var start_val:float = 0 if state else 1.0
	var end_val:float = 0.95 if state else 0
	
	if duration == 0:
		ImageOutputTextureRect.material.set_shader_parameter("opacity", end_val)
		await U.tick()
	else:
		ImageOutputTextureRect.material.set_shader_parameter("opacity", start_val)
		await U.tween_range(start_val, end_val, duration, func(val:float) -> void:
			ImageOutputTextureRect.material.set_shader_parameter("opacity", val)
		).finished
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
	if "title" in current_instruction:
		ImageTitle.text = "%s" % [current_instruction.title]
		
	if "subtitle" in current_instruction:
		ImageSubTitle.text = "%s" % [current_instruction.subtitle]		

	if "img_src" in current_instruction:		
		ImageTextureRect.texture = CACHE.fetch_image(current_instruction.img_src)
		reveal_outputtexture(true, 2.0)
	# -----------------------------------

	# -----------------------------------
	if "set_return_val" in current_instruction:
		event_output = current_instruction.set_return_val.call()
	# -----------------------------------

	# -----------------------------------
	if "text" in current_instruction:
		U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].present, 0.7)
		
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
		await U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].show, 0.7)
		await U.set_timeout(0.3)
		
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
			var is_unavailable:bool = option.is_unavailable if "is_unavailable" in option else false
			var render_if:Dictionary = option.render_if if "render_if" in option else {}

			new_node.data = option
			new_node.index = index 
			new_node.render_if = render_if
			new_node.is_hoverable = false
			new_node.onClick = func() -> void:
				if !new_node.is_available:return
				on_option_select()
				
			OptionsListContainer.add_child(new_node)
		
		await U.tick()
		
		# fade in options
		for index in OptionsListContainer.get_child_count():
			var option:Control = OptionsListContainer.get_child(index)
			option.start()
		
		# add BtnControl funcs
		BtnControls.itemlist = OptionsListContainer.get_children()
		BtnControls.directional_pref = "UD"
		
		await U.tick()
		BtnControls.item_index = 0
		
		update_next_btn(true)
		return
		
	# -----------------------------------
	next_instruction(true)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_option_select() -> void:	
	update_next_btn(false)
	
	var option:Dictionary = current_instruction.options[option_selected_index]
	NoteContainer.hide()
	
	for index in OptionsListContainer.get_child_count():
		var node:Control = OptionsListContainer.get_child(index)
		node.fade_out(0 if node != SelectedNode else 1.0) 
	
	await U.set_timeout(1.5)
	await U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].present, 0.7)

	if "onSelected" in option:
		# if selected val property is available, send it
		option.onSelected.call({"index": option_selected_index, "option": option})
		
	# goto next instruction
	next_instruction(true)
# --------------------------------------------------------------------------------------------------		

## --------------------------------------------------------------------------------------------------		
#func on_option_selected_index() -> void:
	#if !is_node_ready():return
	#
	#var options:Array = current_instruction.options
	#var option:Dictionary = options[option_selected_index]
#
	#for child in NoteContainer.get_children():
		#child.queue_free()	
	#NoteContainer.hide()
	#
	#if "notes" in option:
		#NoteContainer.show()
		#for data in option.notes:
			#var new_node:Control = OptionNoteItem.instantiate()
			#new_node.data = data
			#NoteContainer.add_child(new_node)
## --------------------------------------------------------------------------------------------------		

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
