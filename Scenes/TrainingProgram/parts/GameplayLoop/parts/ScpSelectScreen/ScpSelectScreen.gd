extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls
@onready var ContentPanelContainer:Control = $ContentControl/PanelContainer
@onready var ContentPanelMargin:MarginContainer = $ContentControl/PanelContainer/MarginContainer

@onready var TitleLabel:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/TitleLabel
@onready var ScpList:HBoxContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/ScpList
@onready var AvailableLabel:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/AvailableLabel

@onready var TransitionScreen:Control = $TransitionScreen

enum MODE { SELECT_SCP, CONFIRM_SCP }

const ScpCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/SCP/ScpCard.tscn")

var scp_active_index:int = -1 : 
	set(val):
		scp_active_index = val
		on_scp_active_index_update()
		
var refs:Array = [] : 
	set(val):
		refs = val
		on_refs_update()
		
var current_mode:MODE : 
	set(val):
		current_mode = val
		on_current_mode_update()

var is_animating:bool = true

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	on_refs_update()
	on_scp_active_index_update()
	
	self.modulate = Color(1, 1, 1, 0)
	
	BtnControls.onDirectional = on_key_input
# -----------------------------------------------

# -----------------------------------------------
func activate(new_refs:Array = []) -> void:
	await U.tick()
	
	control_pos_default[ContentPanelContainer] = ContentPanelContainer.position
	
	await U.tick()
	control_pos[ContentPanelContainer] = {
		"show": control_pos_default[ContentPanelContainer].y, 
		"hide": control_pos_default[ContentPanelContainer].y - ContentPanelMargin.size.y
	}
	
	await U.tick()
	ContentPanelContainer.position.y = control_pos[ContentPanelContainer].hide

	await U.tick()
	refs = new_refs	
# -----------------------------------------------

# -----------------------------------------------
func start() -> void:
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))
	current_mode = MODE.SELECT_SCP
	await TransitionScreen.start()	
	TitleLabel.text = "SELECT AN SCP"
# -----------------------------------------------

# -----------------------------------------------
func end(ref:int = -1) -> void:	
	await BtnControls.reveal(false)
	
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.3)	
	await TransitionScreen.end()
	user_response.emit(ref)
	queue_free()
# -----------------------------------------------	

# -----------------------------------------------
func clear_list() -> void:
	for node in [ScpList]:
		for child in node.get_children():
			child.queue_free()
# -----------------------------------------------		

# -----------------------------------------------		
func reveal_content(state:bool) -> void:
	await U.tween_node_property(ContentPanelContainer, "position:y", control_pos[ContentPanelContainer].show if state else control_pos[ContentPanelContainer].hide, 0.3)
# -----------------------------------------------		

# -----------------------------------------------
func on_refs_update() -> void:
	if !is_node_ready() or current_location.is_empty():return
	clear_list()
	
	# fills in the scp cards
	for index in refs.size():
		var ref:int = refs[index]
		var new_card:Control = ScpCardPreload.instantiate()
		new_card.use_location = current_location.duplicate(true)
		#new_card.current_metrics = wing_data.metrics	
		new_card.ref = ref
		new_card.index = index
		
		new_card.onFocus = func(_node:Control):			
			match current_mode:
				MODE.SELECT_SCP:
					scp_active_index = index
					
		new_card.onClick = func():
			if is_animating:return
			match current_mode:
				MODE.SELECT_SCP:
					mark_scp_as_selected(index)
				MODE.CONFIRM_SCP:
					end(refs[scp_active_index])

					
		ScpList.add_child(new_card)
		
		await U.tick()

	
	AvailableLabel.text = "Entries available: %s" % [refs.size()]
		
	scp_active_index = 0
	BtnControls.itemlist = ScpList.get_children()
# -----------------------------------------------

# -----------------------------------------------
func mark_scp_as_selected(selected_index:int) -> void:
	if !is_node_ready() or refs.size() == 0:return	
	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		node.is_selected = selected_index == index
				
	current_mode = MODE.CONFIRM_SCP
# -----------------------------------------------		

# -----------------------------------------------
func flip_card() -> void:
	if !is_node_ready() or refs.size() == 0:return	

	for node in ScpList.get_children():
		node.flip = !node.flip 
# -----------------------------------------------

# -----------------------------------------------
func unflip_cards() -> void:
	if !is_node_ready() or refs.size() == 0:return	

	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		if node.flip:
			node.flip = false
# -----------------------------------------------
		
# -----------------------------------------------
func show_details() -> void:
	if !is_node_ready() or refs.size() == 0:return	
	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		if scp_active_index == index:
			node.flip = !node.flip
# -----------------------------------------------	

# -----------------------------------------------
func on_scp_active_index_update() -> void:
	if !is_node_ready() or refs.size() == 0 or scp_active_index == -1:return		

	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		node.is_active = scp_active_index == index
# -----------------------------------------------	

# -----------------------------------------------
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	is_animating = true
	
	match current_mode:
		# --------------
		MODE.SELECT_SCP:	
			for index in ScpList.get_child_count():
				var node:Control = ScpList.get_child(index)
				node.is_selected = false
								
			BtnControls.a_btn_title = "SELECT"	
			BtnControls.b_btn_title = "BACK"
			BtnControls.hide_c_btn = false
			
			reveal_content(true)
			
			await BtnControls.reveal(true)
			
			BtnControls.onBack = func() -> void:
				end()
			BtnControls.onCBtn = func() -> void:
				flip_card()
			BtnControls.onAction = func() -> void:
				unflip_cards()
				
		# --------------
		MODE.CONFIRM_SCP:
			BtnControls.a_btn_title = "CONFIRM"
			BtnControls.b_btn_title = "CLEAR"	

			BtnControls.onBack = func() -> void:
				current_mode = MODE.SELECT_SCP

	

	is_animating = false
# -----------------------------------------------

# -----------------------------------------------
func on_key_input(key:String) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs or is_animating: 
		return

	match key:
		"A":
			if current_mode == MODE.SELECT_SCP:
				scp_active_index = U.min_max(scp_active_index - 1, 0, ScpList.get_child_count() - 1)
		"D":
			if current_mode == MODE.SELECT_SCP:
				scp_active_index = U.min_max(scp_active_index + 1, 0, ScpList.get_child_count() - 1)
# -----------------------------------------------
