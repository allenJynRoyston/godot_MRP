extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls
@onready var ContentPanelContainer:Control = $ContentControl/PanelContainer
@onready var ContentPanelMargin:MarginContainer = $ContentControl/PanelContainer/MarginContainer

@onready var TitleLabel:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/TitleLabel
@onready var ScpList:HBoxContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/ScpList
@onready var AvailableLabel:Label = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/AvailableLabel
@onready var LessBtn:BtnBase = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/LessBtn
@onready var MoreBtn:BtnBase = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MoreBtn

@onready var MiniCardPanel:PanelContainer = $MiniCardControl/MiniCardPanel
@onready var MiniCardMargin:MarginContainer = $MiniCardControl/MiniCardPanel/MarginContainer
@onready var ScpMiniCard:Control = $MiniCardControl/MiniCardPanel/MarginContainer/VBoxContainer/ScpMiniCard

@onready var TransitionScreen:Control = $TransitionScreen

enum MODE { HIDE, SELECT_SCP, CONFIRM_SCP, FINALIZE }

const ScpCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/SCP/ScpCard.tscn")
const cards_in_list:int = 3

var scp_active_index:int = -1 : 
	set(val):
		scp_active_index = val
		on_scp_active_index_update()
		
var selected_scp:int = -1 : 
	set(val):
		selected_scp = val
		on_selected_scp_update()		
			
var refs:Array = [] : 
	set(val):
		refs = val
		on_refs_update()
		
var current_mode:MODE = MODE.HIDE : 
	set(val):
		current_mode = val
		on_current_mode_update()

var btn_restore_pos:int
var is_animating:bool = true
var custom_min_size:Vector2
var overflow_count:int
var read_only:bool = false

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	on_refs_update()
	on_scp_active_index_update()
	
	self.modulate = Color(1, 1, 1, 0)
	
	BtnControls.onDirectional = on_key_input
# -----------------------------------------------

# -----------------------------------------------
func activate() -> void:
	show()
	await U.tick()

	control_pos_default[ContentPanelContainer] = ContentPanelContainer.position
	control_pos_default[MiniCardPanel] = MiniCardPanel.position

	update_control_pos()
	on_is_showing_update()
# -----------------------------------------------

# -----------------------------------------------
func start_selection(new_refs:Array) -> void:
	refs = new_refs
	TitleLabel.text = "SELECT AN SCP"
	current_mode = MODE.SELECT_SCP
	read_only = false
	TransitionScreen.start()
# -----------------------------------------------

# -----------------------------------------------
func start_read_only(new_refs:Array) -> void:	
	refs = new_refs 
	TitleLabel.text = "DETAILS"
	current_mode = MODE.SELECT_SCP
	read_only = true
	TransitionScreen.start()
# -----------------------------------------------	

# -----------------------------------------------
func end(made_selection:bool, selected_scp:int = -1) -> void:	
	current_mode = MODE.HIDE
	await hide_complete
	await TransitionScreen.end()
	user_response.emit({"made_selection": made_selection, "selected_scp": selected_scp})
# -----------------------------------------------	

# -----------------------------------------------
func clear_list() -> void:
	for node in [ScpList]:
		for child in node.get_children():
			child.queue_free()
# -----------------------------------------------		

# -----------------------------------------------
func on_refs_update() -> void:
	if !is_node_ready() or current_location.is_empty():return
	clear_list()
	
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
	var wing_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
	
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
			if is_animating or read_only:return
			match current_mode:
				MODE.SELECT_SCP:
					mark_scp_as_selected(index)
				MODE.CONFIRM_SCP:
					if index == selected_scp:
						on_confirm_scp()
					else:
						mark_scp_as_selected(index)
					
		ScpList.add_child(new_card)
		
		await U.tick()
		#if index < cards_in_list:
			#custom_min_size = ScpList.size + Vector2(10, 0)
	
	LessBtn.show() if refs.size() > cards_in_list else LessBtn.hide()
	MoreBtn.show() if refs.size() > cards_in_list else MoreBtn.hide()
	AvailableLabel.text = "Entries available: %s" % [refs.size()]
		
	#ListScrollContainer.custom_minimum_size = custom_min_size
	scp_active_index = 0
	BtnControls.itemlist = ScpList.get_children()
# -----------------------------------------------

# -----------------------------------------------
func mark_scp_as_selected(selected_index:int) -> void:
	if !is_node_ready() or refs.size() == 0:return	
	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		node.is_selected = selected_index == index
				
	selected_scp = selected_index
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
		
	var relative_index:int = scp_active_index - overflow_count		
	
	if relative_index > 2:
		if scp_active_index >= cards_in_list:
			overflow_count += 1
			next_set()
	
	if relative_index < 0:
		if overflow_count > 0:
			overflow_count -= 1
			back_set()
					
	for index in ScpList.get_child_count():
		var node:Control = ScpList.get_child(index)
		node.is_hoverable = index >= overflow_count and index < overflow_count + cards_in_list
		
	ScpMiniCard.ref = scp_active_index
# -----------------------------------------------	

# -----------------------------------------------
func next_set() -> void:
	pass
	#is_animating = true
	#var current_scroll:int = ListScrollContainer.scroll_horizontal
	#await U.tween_range(current_scroll, current_scroll + custom_min_size.x/cards_in_list, 0.2, func(val:float) -> void:
		#ListScrollContainer.scroll_horizontal = val		
	#).finished  
	#is_animating = false
# -----------------------------------------------	

# -----------------------------------------------
func back_set() -> void:
	pass
	#is_animating = true
	#var current_scroll:int = ListScrollContainer.scroll_horizontal
	#await U.tween_range(current_scroll, current_scroll - custom_min_size.x/cards_in_list, 0.2, func(val:float) -> void:
		#ListScrollContainer.scroll_horizontal = val
	#).finished  
	#is_animating = false
# -----------------------------------------------	

# -----------------------------------------------
func on_selected_scp_update() -> void:
	if !is_node_ready():return
	pass
# -----------------------------------------------	

# -----------------------------------------------	
func on_confirm_scp() -> void:
	await U.tick()
	current_mode = MODE.FINALIZE
# -----------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func update_control_pos() -> void:
	await U.tick()

	control_pos[ContentPanelContainer] = {
		"show": control_pos_default[ContentPanelContainer].y, 
		"hide": control_pos_default[ContentPanelContainer].y - ContentPanelMargin.size.y
	}
	
	control_pos[MiniCardPanel] = {
		"show": control_pos_default[MiniCardPanel].x, 
		"hide": control_pos_default[MiniCardPanel].x - MiniCardMargin.size.x
	}

	
	on_current_mode_update(true)
# --------------------------------------------------------------------------------------------------		

# -----------------------------------------------
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	var duration:float = 0 if skip_animation else 0.3
	is_animating = true
	

	match current_mode:
		# --------------
		MODE.HIDE:			
			await BtnControls.reveal(false)
			hide_complete.emit()
		# --------------
		MODE.SELECT_SCP:	
			for index in ScpList.get_child_count():
				var node:Control = ScpList.get_child(index)
				node.is_selected = false
							
			await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))
			#U.tween_node_property(ContentPanelContainer, "position:y", control_pos[ContentPanelContainer].show, duration)
			#await U.tween_node_property(MiniCardPanel, "position:x", control_pos[MiniCardPanel].show, duration)
			
			
			BtnControls.a_btn_title = "SELECT"	
			BtnControls.b_btn_title = "BACK"
			BtnControls.hide_c_btn = false
			
			BtnControls.reveal(true)
			
			BtnControls.onBack = func() -> void:
				end(false)
			BtnControls.onCBtn = func() -> void:
				flip_card()
		# --------------
		MODE.CONFIRM_SCP:
			BtnControls.a_btn_title = "CONFIRM"
			BtnControls.b_btn_title = "CLEAR"	

			BtnControls.onBack = func() -> void:
				current_mode = MODE.SELECT_SCP
		# --------------
		MODE.FINALIZE:
			end(true, selected_scp)
	
	await U.set_timeout(0.3)
	is_animating = false
# -----------------------------------------------

# -----------------------------------------------
func on_inc() -> void:
	unflip_cards()
	scp_active_index = U.min_max(scp_active_index - 1, 0, ScpList.get_child_count() - 1)

func on_dec() -> void:
	unflip_cards()
	scp_active_index = U.min_max(scp_active_index + 1, 0, ScpList.get_child_count() - 1)
# -----------------------------------------------

# -----------------------------------------------
func on_key_input(key:String) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs or is_animating: 
		return

	match key:
		"A":
			if current_mode == MODE.SELECT_SCP:
				on_inc()
		"D":
			if current_mode == MODE.SELECT_SCP:
				on_dec()
# -----------------------------------------------
