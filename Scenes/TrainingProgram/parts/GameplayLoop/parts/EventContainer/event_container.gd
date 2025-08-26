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
@onready var Buffs:Control = $ResourceContainer/PanelContainer/MarginContainer/VBoxContainer/Buffs
@onready var BuffList:Control = $ResourceContainer/PanelContainer/MarginContainer/VBoxContainer/Buffs/VBoxContainer/Content/MarginContainer/BuffList
@onready var Debuffs:Control = $ResourceContainer/PanelContainer/MarginContainer/VBoxContainer/Debuffs
@onready var DebuffList:Control = $ResourceContainer/PanelContainer/MarginContainer/VBoxContainer/Debuffs/VBoxContainer/Content/MarginContainer/DebuffList

@onready var BGOutputTexture:PanelContainer = $BGContainer
@onready var ImageBG:TextureRect = $BGContainer/SubViewport/ImageBgTextureRect
@onready var image_bg_material_copy:ShaderMaterial = ImageBG.material.duplicate()

@onready var HeaderPanel:PanelContainer = $HeaderControl/PanelContainer
@onready var HeaderMargin:MarginContainer = $HeaderControl/PanelContainer/MarginContainer
@onready var HeaderTitle:Control = $HeaderControl/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HeaderTitle
@onready var HeaderSubTitle:Label = $HeaderControl/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer2/VBoxContainer/HeaderSubTitle
@onready var HeaderTextureRect:TextureRect = $HeaderControl/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer2/VBoxContainer/HeaderTextureRect
@onready var StaticTextureRect:TextureRect = $HeaderControl/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer2/VBoxContainer/HeaderTextureRect/StaticTexture

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

const OptionListItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/EventContainer/parts/OptionListItem.tscn")
const BuffOrDebuffItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/EventContainer/parts/BuffOrDebuffItem.tscn")

var SelectedNode:Control
var event_data:Array = [] 	
var event_instructions:Array = []
var option_selected_index:int = 0

var impacted_metrics:Dictionary = {}
var impacted_currency:Dictionary = {}
var impacted_buffs:Array = []
var impacted_debuffs:Array = []

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
		"present": 150,
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
	
	impacted_metrics = {}
	impacted_currency = {}
	impacted_buffs = []
	impacted_debuffs = []
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
	await TransitionScreen.start(1.0)	
	BtnControls.reveal(true)
	
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
		if HeaderTextureRect.texture != CACHE.fetch_image(current_instruction.img_src):
			HeaderTextureRect.texture = CACHE.fetch_image(current_instruction.img_src)
		StaticTextureRect.hide()
	else:
		StaticTextureRect.show()

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
			var new_node:Control = OptionListItemPreload.instantiate()
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
				
				# clear list
				for list in [BuffList, DebuffList]:
					for list_node in list.get_children():
						list_node.queue_free()
				
				# then add impact
				if node == _node:
					var option:Dictionary = options[index]
					reveal_resources(option.has("impact"), 0.3 if option.has("impact") else 0)
	
					if option.has("impact"):
						if option.impact.has("buff"):
							Buffs.show()
							for ref in option.impact.buff:
								var buff_data:Dictionary = BASE_UTIL.return_buff(ref)
								var new_node:Control = BuffOrDebuffItemPreload.instantiate()
								new_node.title = buff_data.name
								new_node.description = buff_data.description
								BuffList.add_child(new_node)
						else:
							Buffs.hide()
							
						if option.impact.has("debuff"):
							Debuffs.show()
							for ref in option.impact.debuff:
								var buff_data:Dictionary = BASE_UTIL.return_debuff(ref)
								var new_node:Control = BuffOrDebuffItemPreload.instantiate()
								new_node.title = buff_data.name
								new_node.description = buff_data.description								
								DebuffList.add_child(new_node)
						else:
							Debuffs.hide()							
							
						
						if option.impact.has("currency"):
							Economy.show()
							for ref in option.impact.currency:
								var amount:int = option.impact.currency[ref]
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
						
						if option.impact.has("metrics"):
							Vibes.show()
							for ref in option.impact.metrics:
								var amount:int = option.impact.metrics[ref]
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
	
	if current_instruction.has("tally") and current_instruction.tally:
		# tally changes
		await GAME_UTIL.open_tally(impacted_currency, impacted_metrics)
		
		# add buffs/debuffs
		for buff in impacted_buffs:
			GAME_UTIL.add_buff_to_base(buff, 7)
			
		for debuff in impacted_debuffs:
			GAME_UTIL.add_debuff_to_base(debuff, 7)
		
		# reset
		impacted_metrics = {}
		impacted_currency = {}
		impacted_buffs = []
		impacted_debuffs = []
	
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
	
	#
	var outcome_index:int = 0	
	if option.has("outcomes"):
		var outcome_dict:Dictionary
		var total_chance:int = 0
		for item in option.outcomes.list:
			var chance_val:int = item.chance if item.has('chance') else 1
			outcome_dict[total_chance + chance_val] = item
			total_chance += chance_val
		var roll:int = randi() % total_chance
		var outcome:Dictionary
		for val in outcome_dict:		
			if roll <= int(val):
				outcome = outcome_dict[val]
				break
			else:
				outcome_index += 1		

	# call onSelected
	if option.has("onSelected"):
		option.onSelected.call({			
			"index": option_selected_index, 
			"outcome_index": outcome_index,
			"option": option,
		})
		
		
	# combine top level impact with local one
	var option_selected:Dictionary = option.outcomes.list[outcome_index]
	
	# add to tally
	# top level impact
	if option.has("impact"):
		if option.impact.has("metrics"):
			for ref in option.impact.metrics:
				if ref not in impacted_metrics:
					impacted_metrics[ref] = 0
				impacted_metrics[ref] += option.impact.metrics[ref]
		if option.impact.has("currency"):
			for ref in option.impact.currency:
				if ref not in impacted_metrics:
					impacted_currency[ref] = 0
				impacted_currency[ref] = option.impact.currency[ref]
		if option.impact.has("buff"):
			for ref in option.impact.buff:
				impacted_buffs.push_back(ref)
		if option.impact.has("debuff"):
			for ref in option.impact.debuff:
				impacted_debuffs.push_back(ref)

	# global impact
	if option_selected.has("impact"):
		if option_selected.impact.has("metrics"):
			for ref in option_selected.impact.metrics:
				if ref not in impacted_metrics:
					impacted_metrics[ref] = 0
				impacted_metrics[ref] += option_selected.impact.metrics[ref]
		if option_selected.impact.has("currency"):
			for ref in option_selected.impact.currency:
				if ref not in impacted_currency:
					impacted_currency[ref] = 0
				impacted_currency[ref] += option_selected.impact.currency[ref]
		if option_selected.impact.has("buff"):
			for ref in option_selected.impact.buff:
				impacted_buffs.push_back(ref)
		if option_selected.impact.has("debuff"):
			for ref in option_selected.impact.debuff:
				impacted_debuffs.push_back(ref)
	
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
