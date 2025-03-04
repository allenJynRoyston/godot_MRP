extends GameContainer

@onready var OptionList:VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer2/VBoxContainer/OptionList

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

enum MODE { SELECT, CONFIRM }

var uid:String = "" 

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
	on_refs_update()
	on_select_index_update()
# -----------------------------------------------

# -----------------------------------------------
func start() -> void:	
	uid = hired_lead_researchers_arr[0][0]
	refs = [0, 1, 2]
# -----------------------------------------------

# -----------------------------------------------
func clear_list() -> void:
	for child in OptionList.get_children():
		child.queue_free()
# -----------------------------------------------		

# -----------------------------------------------
func on_refs_update() -> void:
	if !is_node_ready() or refs.size() == 0:return
	clear_list()

	select_index = 0
	for index in refs.size():
		var ref:int = refs[index]
		var btn_node:Control = TextBtnPreload.instantiate()
		btn_node.index = index
		btn_node.title = "title"
		btn_node.icon = SVGS.TYPE.MEDIA_PLAY if select_index == index else SVGS.TYPE.NONE
		btn_node.onFocus = func(_node:Control):
			match current_mode:
				MODE.SELECT:
					select_index = index
		btn_node.onClick = func():
			match current_mode:
				MODE.SELECT:
					confirm_selection()
				MODE.CONFIRM:
					finalize_confirm()
		OptionList.add_child(btn_node)

	
# -----------------------------------------------


# -----------------------------------------------
func on_select_index_update() -> void:
	if !is_node_ready() or refs.size() == 0:return	
	if select_index == -1:return

	for index in OptionList.get_child_count():
		var btn_node:Control = OptionList.get_child(index)
		btn_node.icon = SVGS.TYPE.MEDIA_PLAY if select_index == index else SVGS.TYPE.NONE
# -----------------------------------------------	

# -----------------------------------------------
func on_is_showing_update() -> void:	
	super.on_is_showing_update()
	show() if is_showing else hide()
# -----------------------------------------------

# -----------------------------------------------
func revert_confirm() -> void:
	current_mode = MODE.SELECT
	
	for index in OptionList.get_child_count():
		var node:Control = OptionList.get_child(index)
# -----------------------------------------------

# -----------------------------------------------
func confirm_selection() -> void:
	current_mode = MODE.CONFIRM
	
	for index in OptionList.get_child_count():
		var node:Control = OptionList.get_child(index)
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

	for index in OptionList.get_child_count():
		var btn_node:Control = OptionList.get_child(index)
		# animate out
		
	SUBSCRIBE.hired_lead_researchers_arr = hired_lead_researchers_arr.map(func(i):
		if i[0] == uid:
			# add trait
			i[2].push_back(refs[select_index])
			# change promotion flag
			i[9].can_promote = false
		return i
	)

	await U.set_timeout(1.0)
	
	user_response.emit()
# -----------------------------------------------	

## -----------------------------------	
#func on_control_input_update(input_data:Dictionary) -> void:
	#if !is_visible_in_tree() or !is_node_ready() or freeze_inputs: 
		#return
#
	#var key:String = input_data.key
	#var keycode:int = input_data.keycode
	#
	#match key:
		#"A":
			#if current_mode == MODE.SELECT:
				#unflip_cards()
				#select_index = U.min_max(select_index - 1, 0, List.get_child_count() - 1)
		#"D":
			#if current_mode == MODE.SELECT:
				#unflip_cards()
				#select_index = U.min_max(select_index + 1, 0, List.get_child_count() - 1)
		#"R":
			#if current_mode == MODE.SELECT:
				#show_details()
		#"E":
			#match current_mode:
				#MODE.SELECT:
					#confirm_selection()
				#MODE.CONFIRM:
					#finalize_confirm()
		#"B":
			#if current_mode == MODE.CONFIRM:
				#revert_confirm()
## -----------------------------------		
