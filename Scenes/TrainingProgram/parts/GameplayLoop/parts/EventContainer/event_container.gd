@tool
extends GameContainer

@onready var HeaderLabel:Label = $PanelContainer/MarginContainer/VBoxContainer/HeaderLabel

@onready var ImageContainer:Control = $PanelContainer/MarginContainer/VBoxContainer/ImageContainer
@onready var ImageTextureRect:TextureRect = $PanelContainer/MarginContainer/VBoxContainer/ImageContainer/MarginContainer/ImageTextureRect

@onready var BodyContainer:Control = $PanelContainer/MarginContainer/VBoxContainer/BodyContainer
@onready var BodyLabelBtm:Label = $PanelContainer/MarginContainer/VBoxContainer/BodyContainer/HBoxContainer/PanelContainer/BodyLabelBtm
@onready var BodyLabelTop:Label = $PanelContainer/MarginContainer/VBoxContainer/BodyContainer/HBoxContainer/PanelContainer/BodyLabelTop

@onready var OptionsContainer:Control = $PanelContainer/MarginContainer/VBoxContainer/OptionsContainer
@onready var OptionsListContainer:VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/OptionsContainer/OptionListContainer

@onready var NextBtn:BtnBase = $PanelContainer/MarginContainer/VBoxContainer/NextBtn

enum CONTROLS {FREEZE, PROGRESSION, TEXT, OPTIONS}

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var event_data:Array = [] : 
	set(val):
		event_data = val

var is_busy:bool = true : 
	set(val):
		is_busy = val
		on_is_busy_update()
		
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

signal text_phase_complete

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	reset()
	reset_content_nodes()
	on_is_busy_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_is_showing_update() -> void:
	super.on_is_showing_update()
	if !is_showing:
		reset()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reset() -> void:
	current_event_instruction = {} 
	current_instruction = {} 
	
	event_instruction_index = 0
	instruction_index = 0
	text_index = 0
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reset_content_nodes() -> void:
	for node in [OptionsContainer, ImageContainer, BodyContainer]:
		node.hide()
	
	BodyLabelBtm.text = ""
	BodyLabelTop.text = ""
	
	for child in OptionsListContainer.get_children():
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
	user_response.emit()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func next_event(inc:bool = false) -> void:
	if inc:
		event_instruction_index += 1
		
	#is_busy = true
	
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
		
	#is_busy = true
	
	if instruction_index >= current_event_instruction.event_instructions.size():
		next_event(true)	
	else:
		current_event_instruction = event_data[event_instruction_index]
		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func next_text(inc:bool = false) -> void:
	if inc:
		text_index += 1
		
	if text_index >= current_instruction.text.size():
		text_phase_complete.emit()
	else:
		current_text = current_instruction.text[text_index]
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------		
func on_is_busy_update() -> void:
	if !is_node_ready():return
	NextBtn.static_color = COLOR_UTIL.get_text_color(COLORS.TEXT.INACTIVE if is_busy else COLORS.TEXT.ACTIVE)
# --------------------------------------------------------------------------------------------------		
	

# --------------------------------------------------------------------------------------------------		
func on_current_event_instruction_update() -> void:
	if "event_instructions" in current_event_instruction and current_event_instruction.event_instructions.size() > 0:
		current_instruction = current_event_instruction.event_instructions[instruction_index].call()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_text_update() -> void:
	BodyLabelBtm.text = current_text
	BodyLabelTop.text = current_text
	await tween_text_reveal(current_text.length() * 0.01)
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------		
func on_current_instruction_update() -> void:
	if !is_node_ready():return
	
	if "img_src" in current_instruction:
		ImageContainer.show()
		ImageTextureRect.texture = CACHE.fetch_image(current_instruction.img_src)
	
	if "text" in current_instruction:
		BodyContainer.show()
		text_index = 0
		current_controls = CONTROLS.TEXT
		current_text = current_instruction.text[0]
		await text_phase_complete
		next_instruction(true)
	else:
		BodyContainer.hide()
		BodyLabelBtm.text = ""
		BodyLabelTop.text = ""
		
	if "options" in current_instruction:
		OptionsContainer.show()
		option_selected_index = 0
		var options:Array = current_instruction.options
		for index in options.size():
			var option:Dictionary = options[index]
			var new_node:BtnBase = TextBtnPreload.instantiate()
			new_node.title = "%s: %s" % [index, option.title]
			new_node.icon = SVGS.TYPE.DOT if option_selected_index == index else SVGS.TYPE.NONE
			new_node.index = index 
			new_node.onFocus = func(node:Control) -> void:
				if node == new_node:
					option_selected_index = index
			new_node.onClick = func() -> void:
				on_option_select()
			OptionsListContainer.add_child(new_node)
		current_controls = CONTROLS.OPTIONS
	
	if "clear_options" in current_instruction and current_instruction.clear_options:
		OptionsContainer.hide()
		for child in OptionsListContainer.get_children():
			child.queue_free()			
	
	#is_busy = false
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_option_select() -> void:
	for index in OptionsListContainer.get_child_count():
		var node:Control = OptionsListContainer.get_child(index)
		node.is_hoverable = false
		if index != option_selected_index:
			tween_option_color(node, Color.RED, 0.5)
	
	if "onSelected" in current_instruction.options[option_selected_index]:
		# if selected val property is available, send it
		if "val" in current_instruction.options[option_selected_index]:
			var val = current_instruction.options[option_selected_index].val
			current_instruction.options[option_selected_index].onSelected.call(val)
		# else, send the index
		else:
			current_instruction.options[option_selected_index].onSelected.call(option_selected_index)
	
	await U.set_timeout(0.5)
	
	#current_controls = CONTROLS.PROGRESSION
	#next_instruction(true)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_option_selected_index() -> void:
	if !is_node_ready():return
	for child in OptionsListContainer.get_children():
		child.icon = SVGS.TYPE.DOT if option_selected_index == child.index else SVGS.TYPE.NONE
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func tween_option_color(node:Node, new_color:Color, duration:float = 0.3) -> void:
	var tween:Tween = create_tween()
	tween.tween_property(node, "static_color", new_color, duration).set_trans(Tween.TRANS_QUAD)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func tween_text_reveal(duration:float = 0.3) -> void:
	BodyLabelTop.visible_ratio = 0
	var tween:Tween = create_tween()
	tween.tween_property(BodyLabelTop, "visible_ratio", 1, duration).set_trans(Tween.TRANS_LINEAR).set_delay(0.5)
	await tween.finished
	await U.set_timeout(0.5)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing:return
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match current_controls:
		CONTROLS.PROGRESSION:
			match key:
				"ENTER":	
					next_instruction(true)
					
		CONTROLS.TEXT:
			match key:
				"ENTER":
					next_text(true)
					
		CONTROLS.OPTIONS:
			match key:
				"ENTER":
					on_option_select()
# --------------------------------------------------------------------------------------------------	
