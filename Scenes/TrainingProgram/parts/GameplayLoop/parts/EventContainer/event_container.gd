extends GameContainer

@onready var PanelRoot:PanelContainer = $"."
@onready var BtnControls:Control = $BtnControls
@onready var TransitionScreen:Control = $TransistionScreen
@onready var SuccessRoll:Control = $SuccessRoll
@onready var OptionItemTransitionControl:Control = $OptionItemTransitionControl
#@onready var RoomDetails:Control = $RoomDetails

@onready var ResourcePanel:PanelContainer = $ResourceContainer/PanelContainer
@onready var ResourceMargin:MarginContainer = $ResourceContainer/PanelContainer/MarginContainer
@onready var Vibes:Control = $ResourceContainer/PanelContainer/MarginContainer/VBoxContainer/Vibes
@onready var Economy:Control = $ResourceContainer/PanelContainer/MarginContainer/VBoxContainer/Economy

@onready var BGOutputTexture:PanelContainer = $BGContainer
@onready var ImageBG:TextureRect = $BGContainer/SubViewport/ImageBgTextureRect
@onready var image_bg_material_copy:ShaderMaterial = ImageBG.material.duplicate()

@onready var HeaderPanel:PanelContainer = $HeaderControl/PanelContainer
@onready var HeaderMargin:MarginContainer = $HeaderControl/PanelContainer/MarginContainer
@onready var HeaderTitle:Control = $HeaderControl/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HeaderTitle
@onready var HeaderSubTitle:Label = $HeaderControl/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer2/VBoxContainer/HeaderSubTitle
@onready var HeaderTextureRect:TextureRect = $HeaderControl/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer2/VBoxContainer/HeaderTextureRect

@onready var ContentPanel:PanelContainer = $ContentControl/PanelContainer
@onready var ContentMargin:MarginContainer = $ContentControl/PanelContainer/MarginContainer

@onready var DialogBtn:Control = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/DialogBtn
@onready var BodyContainer:Control = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer
@onready var BodyLabelBtm:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/PanelContainer/BodyLabelBtm
@onready var BodyLabelTop:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/PanelContainer/BodyLabelTop

@onready var OptionsContainer:Control = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/OptionsContainer
@onready var OptionsContainerList:HBoxContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/OptionsContainer/OptionsContainerList



# @onready var NoteContainer:VBoxContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/OptionsContainer/HBoxContainer/NoteContainer
enum MODE {HIDE, ACTIVE}
enum CONTROLS {FREEZE, TEXT_REVEAL, OPTIONS}

const OptionListItem:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/EventContainer/parts/OptionListItem.tscn")

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

var event_output:Dictionary = {}
var has_more:bool = true
var text_reveal_tween:Tween
var apply_dyslexia_to_content:bool = false

# debugging
var use_force_results:bool = false
var force_is_success:bool = false
var has_started:bool = false

signal text_phase_complete

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	ImageBG.material = image_bg_material_copy
	
	self.modulate = Color(1, 1, 1, 0)
		
	reset()
	reset_content_nodes()
	
	# RoomDetails.reveal(false)
	
	BtnControls.hide_c_btn = !DEBUG.get_val(DEBUG.GAMEPLAY_ENABLE_SCP_DEBUG)
	use_force_results = DEBUG.get_val(DEBUG.GAMEPLAY_ENABLE_SCP_DEBUG)
	
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
	
	control_pos[HeaderPanel] = {
		"show": 0,
		"hide": -HeaderMargin.size.x
	}
	
	control_pos[ResourcePanel] = {
		"show": 0,
		"hide": ResourceMargin.size.x
	}

	ContentPanel.position.y = control_pos[ContentPanel].hide	
	HeaderPanel.position.x = control_pos[HeaderPanel].hide
	ResourcePanel.position.x = control_pos[ResourcePanel].hide
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func reset() -> void:
	if !is_node_ready():return
	update_next_btn(false)
	
	BGOutputTexture.hide()
	
	HeaderTitle.hide()
	HeaderTitle.title = ""
	HeaderSubTitle.text = ""

	current_event_instruction = {} 
	current_instruction = {} 
	
	event_instruction_index = 0
	instruction_index = 0
	text_index = 0
	event_output = {}
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reset_content_nodes() -> void:
	BodyLabelBtm.text = ""
	BodyLabelTop.text = ""
	
	for node in [OptionsContainerList]:
		for child in node.get_children():
			child.queue_free()	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func start(new_event_data:Array) -> void:	
	# show
	BGOutputTexture.show()
	modulate.a = 1
		
	# fade in bg
	var current_color1:Color = image_bg_material_copy.get_shader_parameter("color1")
	var current_color2:Color = image_bg_material_copy.get_shader_parameter("color2")	
	U.tween_range(0, 0.7, 0.5, func(new_val:float):
		current_color1.a = new_val
		current_color2.a = new_val
		image_bg_material_copy.set_shader_parameter("color1", current_color1)
		image_bg_material_copy.set_shader_parameter("color2", current_color2)			
	).finished

	# transition in
	BtnControls.disable_back_btn = true
	BtnControls.onBack = func() -> void:pass
	BtnControls.onAction = func() -> void:pass	
	BtnControls.reveal(true)
	await TransitionScreen.start(1.0)	
	
	# set event data and continue	
	event_data = new_event_data

	if event_data.size() > 0:
		next_event()
	else:
		end()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:
	BtnControls.reveal(false)	
	await U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].hide )	
	await TransitionScreen.end( 0.5 )
	
	user_response.emit(event_output)
	queue_free()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_header(state:bool, duration:float = 0.3) -> void:
	if state:
		HeaderPanel.show()
	
	await U.tween_node_property(HeaderPanel, "position:x", control_pos[HeaderPanel].show if state else control_pos[HeaderPanel].hide, duration )
	
	if !state:
		HeaderPanel.hide()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_resources(state:bool, duration:float = 0.3) -> void:
	if state:
		ResourcePanel.show()
		
	await U.tween_node_property(ResourcePanel, "position:x", control_pos[ResourcePanel].show if state else control_pos[ResourcePanel].hide, duration )
	
	if !state:
		ResourcePanel.hide()
# --------------------------------------------------------------------------------------------------		
		
# --------------------------------------------------------------------------------------------------		
#func reveal_outputtexture(state:bool, duration:float) -> void:
	#var start_val:float = 0 if state else 1.0
	#var end_val:float = 0.95 if state else 0
	#
	#if state:
		#BGOutputTexture.show()
	#
	#if duration == 0:
		#image_bg_material_copy.set_shader_parameter("opacity", end_val)
		#await U.tick()
	#else:
		#image_bg_material_copy.set_shader_parameter("opacity", start_val)
		#await U.tween_range(start_val, end_val, duration, func(val:float) -> void:
			#image_bg_material_copy.set_shader_parameter("opacity", val)
		#).finished
		#
	#if !state:
		#BGOutputTexture.hide()
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
	current_instruction = await current_event_instruction.event_instructions[instruction_index].call()
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
	if current_instruction.has("header"):
		HeaderTitle.title = "%s" % [current_instruction.header]
		HeaderTitle.show()
		reveal_header(true, 0.7)

		
	if current_instruction.has("subheader"):
		HeaderSubTitle.show()
		HeaderSubTitle.text = "%s" % [current_instruction.subheader]
	else:
		HeaderSubTitle.hide()

	if current_instruction.has("img_src"):	
		HeaderTextureRect.show()
		if HeaderTextureRect.texture != CACHE.fetch_image(current_instruction.img_src):
			HeaderTextureRect.texture = CACHE.fetch_image(current_instruction.img_src)
		#reveal_outputtexture(true, 0.3)
	else:
		HeaderTextureRect.hide()

	if current_instruction.has("set_return_val"):
		event_output = current_instruction.set_return_val.call()	
	# -----------------------------------

	# -----------------------------------
	if current_instruction.has("text"):
		BtnControls.reveal(true)

		U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].present, 0.7)
		
		if current_instruction.text.size() > 0:
			BtnControls.onAction = func() -> void:
				next_text(true)
			DialogBtn.icon = SVGS.TYPE.CONVERSATION
			BodyContainer.show()
			text_index = 0
			current_text = current_instruction.text[0]
			
			await text_phase_complete
	# -----------------------------------

	# -----------------------------------
	if current_instruction.has("options") and !current_instruction.options.is_empty():
		BtnControls.reveal(true)
		
		await U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].show, 0.7)
		await U.set_timeout(0.3)
		
		update_next_btn(false)
		# NoteContainer.hide()
		
		option_selected_index = 0
		DialogBtn.icon = SVGS.TYPE.QUESTION_MARK

		for child in OptionsContainerList.get_children():
			child.queue_free()			
		
		var options:Array = current_instruction.options
		var is_paranoid:bool = false 

		if is_paranoid:
			options.shuffle()
		
		for index in options.size():
			var option:Dictionary = options[index]
			var new_node:Control = OptionListItem.instantiate()
			var is_unavailable:bool = option.is_unavailable if "is_unavailable" in option else false
			var hint_description:String = option.hint_description if option.has("hint_description") else ""
			new_node.can_afford = true
			new_node.index = index
			new_node.hint_description = hint_description
			new_node.data = option
			new_node.is_selected = option_selected_index == index
			OptionsContainerList.add_child(new_node)
		
		BtnControls.onAction = func() -> void:
			on_option_select(options[option_selected_index])
	
		BtnControls.onUpdate = func(_node:Control) -> void:
			for index in OptionsContainerList.get_child_count():
				var node:Control = OptionsContainerList.get_child(index)
				node.is_selected = node == _node	
				if node == _node:
					var option:Dictionary = options[index]
					reveal_resources(option.has("cost"), 0.3 if option.has("cost") else 0)
					
					if option.has("cost"):
						if option.cost.has("currency"):
							Economy.show()
							for ref in option.cost.currency:
								var amount:int = option.cost.currency[ref]
								match ref:
									RESOURCE.CURRENCY.MONEY:
										Economy.money_offset = amount
									RESOURCE.CURRENCY.SCIENCE:
										Economy.research_offset = amount
									RESOURCE.CURRENCY.MATERIAL:
										Economy.material_offset = amount
									RESOURCE.CURRENCY.CORE:
										Economy.core_offset = amount
						else:
							Economy.hide()
						
						if option.cost.has("metrics"):
							Vibes.show()
							for ref in option.cost.metrics:
								var amount:int = option.cost.metrics[ref]
								match ref:
									RESOURCE.METRICS.MORALE:
										Vibes.offset_morale = amount
									RESOURCE.METRICS.SAFETY:
										Vibes.offset_safety = amount
									RESOURCE.METRICS.READINESS:
										Vibes.offset_readiness = amount
										
						else:
							Vibes.hide()
					
					# assign
					SelectedNode = node
					option_selected_index = index
					BtnControls.disable_active_btn = !node.is_selectable
					
				
		# add BtnControl funcs
		BtnControls.itemlist = OptionsContainerList.get_children()
		BtnControls.directional_pref = "LR"
		BtnControls.item_index = 0		

		update_next_btn(true)
		return
	# -----------------------------------
	
	# -----------------------------------
	if current_instruction.has("end") and current_instruction.end:
		BtnControls.reveal(true)
		BtnControls.a_btn_title = "CLOSE"
		BtnControls.onAction = func() -> void:
			end()
		has_more = false
		return 
	# -----------------------------------
	
	next_instruction(true)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_option_select(option:Dictionary) -> void:		
	await BtnControls.reveal(false)
	
	# update
	update_next_btn(false)	
	
	# fade out
	for index in OptionsContainerList.get_child_count():
		var node:Control = OptionsContainerList.get_child(index)
		node.fade_out() 
	
	# call onSelected
	if option.has("onSelected"):
		option.onSelected.call({
			"index": option_selected_index, 
			"option": option
		})
		
	# remove element from tree and place it where it can be transisitioned
	var SelectNodeCopy:Control = SelectedNode.duplicate()
	var node_pos:Vector2 = SelectedNode.global_position
	OptionItemTransitionControl.add_child(SelectNodeCopy)
	SelectNodeCopy.global_position = node_pos	
	
	# center selected
	var center_x:float = (GBL.game_resolution.x - SelectNodeCopy.size.x) / 2
	await U.tween_node_property(SelectNodeCopy, "global_position:x", center_x, 0.7, 0, Tween.TRANS_SINE)
	await U.set_timeout(1.0)
	
	# fade it out	
	reveal_resources(false)	
	await SelectNodeCopy.fade_out()		
	
	# clear all nodes
	for index in OptionsContainerList.get_child_count():
		var node:Control = OptionsContainerList.get_child(index)	
		node.queue_free()
	SelectNodeCopy.queue_free()
	
	# goto next
	next_instruction(true)
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
var time := 0.0
var trigger_time := randf_range(0.5, 1.0)
var rotation_accum: float = 0.0
var x_amplitude: float = 5.0   # how far it drifts left/right
var y_amplitude: float = 5.0   # how far it drifts up/down
var x_frequency: float = 0.5  # speed of oscillation (Hz)
var y_frequency: float = 0.5
var rotation_speed: float = 0.5 # radians per second (~30°/sec)
var color1_start:Color = COLORS.primary_color
var color2_start:Color = Color.PURPLE

func _process(delta: float) -> void:
	if !is_node_ready():return
	time += delta
	var t:float = 0.5 + 0.5 * sin(time * 0.05 * TAU)
	var hue:float = fmod(time * 0.05, 1.0)  # 0.1 = speed of color change
	var current_color1:Color = Color.from_hsv(hue, 1.0, 0.5)  # Full saturation and value
	var current_color2:Color = Color.from_hsv(hue / 2.0, 0.5, 0.5)  # Full saturation and value

	rotation_accum += rotation_speed * delta * 0.01

	# Keep angle bounded (not required but keeps numbers small)
	if rotation_accum > TAU:
		rotation_accum -= TAU
				
	var sx:float = sin((time / 1000) * TAU * x_frequency) * x_amplitude
	var sy:float = sin((time / 1000) * TAU * y_frequency) * y_amplitude
	var current_size:float = lerp(10, 60, t * 0.5)

	image_bg_material_copy.set_shader_parameter("color1", current_color1)
	image_bg_material_copy.set_shader_parameter("color2", current_color2)
	image_bg_material_copy.set_shader_parameter("speed_x", sx * 0.2)
	image_bg_material_copy.set_shader_parameter("speed_y", sy * 0.2)
	image_bg_material_copy.set_shader_parameter("rotation", rotation_accum)
	image_bg_material_copy.set_shader_parameter("size", current_size)

	
# --------------------------------------------------------------------------------------------------	
