extends GameContainer

@onready var SelectIcon:BtnBase = $Control/SelectIcon
@onready var List:HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/List

#@onready var DetailsBtn:BtnBase = $BtnContainer/MarginContainer/HBoxContainer/Details
#@onready var SelectBtn:BtnBase = $BtnContainer/MarginContainer/HBoxContainer/SelectBtn
#@onready var BackBtn:BtnBase = $BtnContainer/MarginContainer/HBoxContainer/BackBtn

enum MODE { SELECT, CONFIRM }

const ScpCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/SCP/ScpCard.tscn")

var select_index:int = -1 : 
	set(val):
		select_index = val
		on_select_index_update()

var refs:Array = [] : 
	set(val):
		refs = val
		on_refs_update()
		
var current_mode:MODE = MODE.SELECT : 
	set(val):
		current_mode = val
		on_current_mode_update()

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	SelectIcon.hide()
	on_refs_update()
	on_select_index_update()
	#
	#SelectBtn.onClick = func() -> void:
		#pass
		#
	#DetailsBtn.onClick = func() -> void:
		#show_details()
		#
	#BackBtn.onClick = func() -> void:
		#if current_mode == MODE.CONFIRM:
			#revert_confirm()
	
	GameplayNode = GBL.find_node(REFS.GAMEPLAY_LOOP) 
# -----------------------------------------------

# -----------------------------------------------
func start(new_refs:Array) -> void:
	await U.set_timeout(0.5)
	refs = new_refs
	
# -----------------------------------------------

# -----------------------------------------------
func clear_list() -> void:
	for child in List.get_children():
		child.queue_free()
# -----------------------------------------------		

# -----------------------------------------------
func on_refs_update() -> void:
	if !is_node_ready():return
	clear_list()
	
	for index in refs.size():
		var ref:int = refs[index]
		var new_card:Control = ScpCardPreload.instantiate()
		new_card.ref = ref
		new_card.index = index
		new_card.onFocus = func(_node:Control):
			match current_mode:
				MODE.SELECT:
					select_index = index
		new_card.onClick = func():
			match current_mode:
				MODE.SELECT:
					confirm_selection()
				MODE.CONFIRM:
					finalize_confirm()
		List.add_child(new_card)
		new_card.reveal = true

	select_index = 0
# -----------------------------------------------

# -----------------------------------------------
func unflip_cards() -> void:
	if !is_node_ready() or refs.size() == 0:return	
	for index in List.get_child_count():
		var node:Control = List.get_child(index)
		node.flip = false
# -----------------------------------------------
		
# -----------------------------------------------
func show_details() -> void:
	if !is_node_ready() or refs.size() == 0:return	
	for index in List.get_child_count():
		var node:Control = List.get_child(index)
		if select_index == index:
			node.flip = !node.flip
# -----------------------------------------------	

# -----------------------------------------------
func on_select_index_update() -> void:
	if !is_node_ready() or refs.size() == 0:return	
	SelectIcon.hide() if select_index == -1 else SelectIcon.show()
	if select_index == -1:return
	var card_node:Control = List.get_child(select_index)
	SelectIcon.global_position = card_node.global_position + card_node.size + Vector2(-card_node.size.x/2 + -SelectIcon.size.x/2, 20)
	
	for index in List.get_child_count():
		var node:Control = List.get_child(index)
		node.is_selected = select_index == index
# -----------------------------------------------	

# -----------------------------------------------
func on_is_showing_update() -> void:	
	super.on_is_showing_update()
	show() if is_showing else hide()
# -----------------------------------------------

# -----------------------------------------------
func revert_confirm() -> void:
	current_mode = MODE.SELECT
	
	for index in List.get_child_count():
		var node:Control = List.get_child(index)
		node.reveal = true
		node.is_selected = select_index == index	
# -----------------------------------------------

# -----------------------------------------------
func confirm_selection() -> void:
	current_mode = MODE.CONFIRM
	
	for index in List.get_child_count():
		var node:Control = List.get_child(index)
		if select_index != index:
			node.reveal = false
# -----------------------------------------------

# -----------------------------------------------
func on_current_mode_update() -> void:
	pass
	#SelectIcon.icon = SVGS.TYPE.LOCK if current_mode == MODE.CONFIRM else SVGS.TYPE.UP_ARROW
	#SelectBtn.title = "CONFIRM" if current_mode == MODE.CONFIRM else "SELECT"
	#DetailsBtn.show() if current_mode != MODE.CONFIRM else DetailsBtn.hide()
	#BackBtn.show() if current_mode == MODE.CONFIRM else BackBtn.hide()
# -----------------------------------------------

# -----------------------------------------------
func finalize_confirm() -> void:
	freeze_inputs = true

	for index in List.get_child_count():
		var node:Control = List.get_child(index)
		node.reveal = false
		
	await U.set_timeout(1.0)
	
	scp_data.available_list.push_back({
		"ref": refs[select_index], 
		"days_until_expire": 14, 
		"is_new": true,
		"transfer_status": {
			"state": false, 
			"days_till_complete": -1,
			"location": {}
		}
	})
	SUBSCRIBE.scp_data = scp_data	
	
	user_response.emit()
# -----------------------------------------------	

# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs: 
		return

	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"A":
			if current_mode == MODE.SELECT:
				unflip_cards()
				select_index = U.min_max(select_index - 1, 0, List.get_child_count() - 1)
		"D":
			if current_mode == MODE.SELECT:
				unflip_cards()
				select_index = U.min_max(select_index + 1, 0, List.get_child_count() - 1)
		"R":
			if current_mode == MODE.SELECT:
				show_details()
		"E":
			match current_mode:
				MODE.SELECT:
					confirm_selection()
				MODE.CONFIRM:
					finalize_confirm()
		"B":
			if current_mode == MODE.CONFIRM:
				revert_confirm()
# -----------------------------------		
