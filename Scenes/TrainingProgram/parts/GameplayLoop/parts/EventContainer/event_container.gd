extends GameContainer

@onready var PanelRoot:PanelContainer = $"."
@onready var BtnControls:Control = $BtnControls
@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var TransitionScreen:Control = $TransistionScreen
@onready var ResourceFloatingPanel:Control = $ResourceRequiredFloatingPanel
@onready var ConsequenceFloatingPanel:Control = $ConsequenceFloatingPanel
@onready var SuccessRoll:Control = $SuccessRoll
@onready var RoomDetails:Control = $RoomDetails

@onready var ResearcherPanel:PanelContainer = $ResearcherControl/PanelContainer
@onready var ResearcherMargin:MarginContainer = $ResearcherControl/PanelContainer/MarginContainer
@onready var ResearcherCard:Control = $ResearcherControl/PanelContainer/MarginContainer/ResearcherCard

@onready var ImagePanel:PanelContainer = $ImageControl/PanelContainer
@onready var ImageMargin:MarginContainer = $ImageControl/PanelContainer/MarginContainer
@onready var ImageOutputTextureRect:TextureRect = $ImageControl/PanelContainer/MarginContainer/OutputTexture
@onready var ImageTextureRect:TextureRect = $ImageControl/PanelContainer/MarginContainer/SubViewport/TextureRect
#@onready var ImageTitle:Label = $ImageControl/PanelContainer/MarginContainer2/VBoxContainer/Title
@onready var VHSLabel:Control = $ImageControl/PanelContainer/MarginContainer2/VBoxContainer/VHSLabel
@onready var ImageSubTitle:Label = $ImageControl/PanelContainer/MarginContainer2/VBoxContainer/Subtitle

@onready var ContentPanel:PanelContainer	 = $ContentControl/PanelContainer
@onready var ContentMargin:MarginContainer = $ContentControl/PanelContainer/MarginContainer

@onready var DialogBtn:Control = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BodyContainer/HBoxContainer/SVGIcon
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

var event_output:Dictionary = {}
var has_more:bool = true
var text_reveal_tween:Tween
var apply_dyslexia_to_content:bool = false

# debugging
var use_force_results:bool = false
var force_is_success:bool = false

signal text_phase_complete

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	self.modulate = Color(1, 1, 1, 0)
		
	reset()
	reset_content_nodes()
	
	RoomDetails.reveal(false)
	
	BtnControls.hide_c_btn = !DEBUG.get_val(DEBUG.GAMEPLAY_ENABLE_SCP_DEBUG)
	use_force_results = DEBUG.get_val(DEBUG.GAMEPLAY_ENABLE_SCP_DEBUG)
	
	BtnControls.onCBtn = func() -> void:
		force_is_success = !force_is_success
		BtnControls.c_btn_title = "FORCE %s" % ['SUCCESS' if force_is_success else 'FAILURE']
	
	# setup btn controls
	BtnControls.onUpdate = func(_node:Control) -> void:
		for index in OptionsListContainer.get_child_count():
			var node:Control = OptionsListContainer.get_child(index)
			node.is_selected = node == _node	
			if node == _node:
				# assign
				SelectedNode = node
				option_selected_index = index
				
				# apply special cases
				node.apply_dyslexia = current_instruction.selected_staff.trait.ref == RESEARCHER.TRAITS.DYSLEXIC if "selected_staff" in current_instruction else false 
				node.allow_for_hint = current_instruction.selected_staff.trait.ref == RESEARCHER.TRAITS.ANALYTICAL if "selected_staff" in current_instruction else false 
				
				# update and move floating resource 
				var has_cost:bool = "render_if" in node.data and "cost" in node.data.render_if
				ResourceFloatingPanel.reveal(has_cost)
				ResourceFloatingPanel.update(node.data.render_if.cost if has_cost else {})
				ResourceFloatingPanel.goto(node.global_position + node.size + Vector2(0, -node.size.y/2))
				
				# show negative consequence odds IF 
				var is_pessimisstic:bool = current_instruction.selected_staff.trait.ref == RESEARCHER.TRAITS.PESSIMIST if "selected_staff" in current_instruction else false 
				var is_optimistic:bool = current_instruction.selected_staff.trait.ref == RESEARCHER.TRAITS.OPTIMIST if "selected_staff" in current_instruction else false 
				var show_consequences:bool = is_pessimisstic or is_optimistic
				var type:String = "NEGATIVE" if is_pessimisstic else "POSITIVE" if is_optimistic else ""
				
				ConsequenceFloatingPanel.reveal(show_consequences)
				ConsequenceFloatingPanel.update(node.data if show_consequences else {}, type)
				ConsequenceFloatingPanel.goto(node.global_position + Vector2(0, node.size.y) + Vector2(0, -node.size.y/2))
				

				if node.data.has("room_ref"):
					RoomDetails.reveal(true)
					RoomDetails.room_ref = node.data.room_ref
				else:
					RoomDetails.reveal(false)

# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	await U.tick()
	
	# center elements
	control_pos[ContentPanel] = {
		"show": 0, 
		"present": 140,
		"hide": -ContentMargin.size.y
	}
	
	control_pos[ResearcherPanel] = {
		"show": 0,
		"hide": -ResearcherMargin.size.x
	}

	ContentPanel.position.y = control_pos[ContentPanel].hide	
	ResearcherPanel.position.x = control_pos[ResearcherPanel].hide
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------		
func reset() -> void:
	if !is_node_ready():return
	update_next_btn(false)
	reveal_outputtexture(false, 0.0)	
	
	VHSLabel.hide()
	VHSLabel.title = ""
	ImageSubTitle.text = ""
	
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
	TransitionScreen.start()	
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))
	
	await BtnControls.reveal(true)
	
	BtnControls.disable_back_btn = true
	BtnControls.onBack = func() -> void:pass
	BtnControls.onAction = func() -> void:pass

	
	event_data = new_event_data

	if event_data.size() > 0:
		next_event()
	else:
		end()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:
	BtnControls.reveal(false)	
	RoomDetails.reveal(false)	
	
	reveal_researcher(false)
	await U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].hide, 0.7	 )
	
	await TransitionScreen.end()
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.7 )
	await U.set_timeout(0.3)
	user_response.emit(event_output)
	queue_free()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_researcher(state:bool, duration:float = 0.7) -> void:
	if !state:
		ResearcherCard.reveal = false	
	await U.tween_node_property(ResearcherPanel, "position:x", control_pos[ResearcherPanel].show if state else control_pos[ResearcherPanel].hide, duration)
	if state:
		ResearcherCard.reveal = true

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

	# watch for certain strings to apply effects
	if ResearcherCard.uid != null:
		var staff_detail:Dictionary = RESEARCHER_UTIL.return_data_with_uid(ResearcherCard.uid)
		var delay:float = 1.0
		
		if !staff_detail.is_empty():
			# -------------------------------------------------	DAMAGE HP/SANITY
			# take 1 damage
			if current_text == str(staff_detail.name, " %s" % [EVT.get_consequence_str(EVT.CONSEQUENCE.HP_HURT)]):
				await ResearcherCard.shake(3)
				await U.set_timeout(delay)
				RESEARCHER_UTIL.take_damage(staff_detail.uid, 1)
			
			if current_text == str(staff_detail.name, " %s" % [EVT.get_consequence_str(EVT.CONSEQUENCE.SP_HURT)]):
				await ResearcherCard.shake(3)
				await U.set_timeout(delay)
				RESEARCHER_UTIL.damage_sanity(staff_detail.uid, 1)
				
			# -------------------------------------------------	RESTORE HP/SANITY
			# take 1 damage
			if current_text == str(staff_detail.name, " %s" % [EVT.get_consequence_str(EVT.CONSEQUENCE.HP_HEAL)]):
				await ResearcherCard.shake(3)
				await U.set_timeout(delay)
				RESEARCHER_UTIL.restore_health(staff_detail.uid, 1)
			
			if current_text == str(staff_detail.name, " %s" % [EVT.get_consequence_str(EVT.CONSEQUENCE.SP_HEAL)]):
				await ResearcherCard.shake(3)
				await U.set_timeout(delay)
				RESEARCHER_UTIL.restore_sanity(staff_detail.uid, 1)

			## -------------------------------------------------	CHANGE STATUS TO KILLED/INSANE
			if current_text == str(staff_detail.name, " %s" % [EVT.get_consequence_str(EVT.CONSEQUENCE.CHANGE_STATUS_TO_KIA)]):
				await ResearcherCard.shake(5)
				await U.set_timeout(delay)
				
				RESEARCHER_UTIL.change_status_to_kia(staff_detail.uid)
				ResearcherCard.reveal = false
				ResearcherCard.is_deselected = true
				
			if current_text == str(staff_detail.name, " %s" % [EVT.get_consequence_str(EVT.CONSEQUENCE.CHANGE_STATUS_TO_INSANE)]):
				await ResearcherCard.shake(5)
				await U.set_timeout(delay)
				
				RESEARCHER_UTIL.change_status_to_insane(staff_detail.uid)
				ResearcherCard.reveal = false
				ResearcherCard.is_deselected = true
			#
			## -------------------------------------------------	CHANGES TO MOOD
			# mood changed to
			if current_text == str(staff_detail.name, " %s" % [EVT.get_consequence_str(EVT.CONSEQUENCE.MOOD_CHANGED_TO_STABLE)]):
				await ResearcherCard.shake(5)
				await U.set_timeout(delay)
				RESEARCHER_UTIL.change_mood(staff_detail.uid, RESEARCHER.MOODS.STABLE)
				
			if current_text == str(staff_detail.name, " %s" % [EVT.get_consequence_str(EVT.CONSEQUENCE.MOOD_CHANGED_TO_FRIGHTENED)]):
				await ResearcherCard.shake(5)
				await U.set_timeout(delay)
				RESEARCHER_UTIL.change_mood(staff_detail.uid, RESEARCHER.MOODS.FRIGHTENED)
				
			if current_text == str(staff_detail.name, " %s" % [EVT.get_consequence_str(EVT.CONSEQUENCE.MOOD_CHANGED_TO_DEPRESSED)]):
				await ResearcherCard.shake(5)
				await U.set_timeout(delay)
				RESEARCHER_UTIL.change_mood(staff_detail.uid, RESEARCHER.MOODS.DEPRESSED)	
			
			if current_text == str(staff_detail.name, " %s" % [EVT.get_consequence_str(EVT.CONSEQUENCE.MOOD_CHANGED_TO_FRIGHTENED)]):
				await ResearcherCard.shake(5)
				await U.set_timeout(delay)
				RESEARCHER_UTIL.change_mood(staff_detail.uid, RESEARCHER.MOODS.FRIGHTENED)


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
		VHSLabel.title = "%s" % [current_instruction.title]
		VHSLabel.show()
		
	if "subtitle" in current_instruction:
		ImageSubTitle.text = "%s" % [current_instruction.subtitle]		

	if "img_src" in current_instruction:	
		if ImageTextureRect.texture != CACHE.fetch_image(current_instruction.img_src):
			ImageTextureRect.texture = CACHE.fetch_image(current_instruction.img_src)
			reveal_outputtexture(true, 0.3)
		
	if "scp_ref" in current_instruction:
		RoomDetails.scp_ref = current_instruction.scp_ref
		RoomDetails.show_scp_card = true
		RoomDetails.show_room_card = false
		RoomDetails.show_researcher_card = false
		RoomDetails.ScpCard.flip = true
		RoomDetails.disable_inputs = true
		await U.set_timeout(0.3)
		RoomDetails.reveal(true)
		
		
		
	if "selected_staff" in current_instruction:
		if ResearcherCard.uid != current_instruction.selected_staff.uid:
			ResearcherCard.uid = current_instruction.selected_staff.uid
			reveal_researcher(true)
			await U.set_timeout(1.5)
			ResearcherCard.flip = true

	if "set_return_val" in current_instruction:
		event_output = current_instruction.set_return_val.call()	
	# -----------------------------------

	# -----------------------------------
	if "use_success_roll" in current_instruction and current_instruction.use_success_roll:
		reveal_researcher(false)
		await U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].hide)
		await SuccessRoll.use(current_instruction.is_success if !use_force_results else force_is_success, 1.5)
		await BtnControls.reveal(true)
		if ResearcherCard.uid != null:
			reveal_researcher(true)
	# -----------------------------------

	# -----------------------------------
	if "text" in current_instruction:
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
	if "options" in current_instruction and !current_instruction.options.is_empty():
		BtnControls.reveal(true)
		
		await U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].show, 0.7)
		await U.set_timeout(0.3)
		
		update_next_btn(false)
		NoteContainer.hide()
		
		option_selected_index = 0
		DialogBtn.icon = SVGS.TYPE.QUESTION_MARK

		for child in OptionsListContainer.get_children():
			child.queue_free()			
		
		var options:Array = current_instruction.options
		var is_paranoid:bool = current_instruction.selected_staff.trait.ref == RESEARCHER.TRAITS.PARANOID if "selected_staff" in current_instruction else false 

		if is_paranoid:
			options.shuffle()
		
		for index in options.size():
			var option:Dictionary = options[index]
			var new_node:Control = OptionListItem.instantiate()
			var is_unavailable:bool = option.is_unavailable if "is_unavailable" in option else false
			var render_if:Dictionary = option.render_if if "render_if" in option else {}
			var show:bool = option.show if "show" in option else true
			var hint_description:String = option.hint_description if option.has("hint_description") else ""
						
			if !render_if.is_empty():
				if "show" in render_if:
					show = render_if.show
			
			if show:
				new_node.index = index
				new_node.hint_description = hint_description
				new_node.is_paranoid = is_paranoid
				new_node.data = option
				new_node.render_if = render_if
				new_node.is_hoverable = false
				new_node.onClick = func() -> void:
					if !new_node.is_available:return
					on_option_select(option)
					
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
	
	# -----------------------------------
	if "end" in current_instruction and current_instruction.end:
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
	RoomDetails.reveal(false)	
	await BtnControls.reveal(false)
	
	update_next_btn(false)	
	NoteContainer.hide()
	
	ResourceFloatingPanel.fade_out()
	ConsequenceFloatingPanel.fade_out()
	
	SuccessRoll.set_title(option.title)
	
	for index in OptionsListContainer.get_child_count():
		var node:Control = OptionsListContainer.get_child(index)
		node.fade_out(0 if node != SelectedNode else 1.0) 
	
	await U.set_timeout(1.0)

	if "onSelected" in option:
		if use_force_results and option.has('success_rate'):
			option.success_rate = 100 if force_is_success else 0
		
		option.onSelected.call({
			"index": option_selected_index, 
			"option": option
		})
		
	# goto next instruction
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


var time_accumulator := 0.0
var trigger_time := randf_range(0.5, 1.0)
func _process(delta: float) -> void:
	if !is_node_ready() or !apply_dyslexia_to_content:return
	time_accumulator += delta

	if time_accumulator >= trigger_time:
		time_accumulator = 0.0
		trigger_time = randf_range(0.5, 1.0)
		
		BodyLabelBtm.text = U.simulate_dyslexia(current_text)
		BodyLabelTop.text = U.simulate_dyslexia(current_text)
