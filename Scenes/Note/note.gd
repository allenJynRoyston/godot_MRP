extends Control
@onready var BGTextureRect:TextureRect = $BackgroundTextureRect
@onready var TransitionScreen:Control = $TransitionScreen

@onready var SnapshotControl:Control = $SnapshotControl
@onready var SnapshotPanel:PanelContainer = $SnapshotControl/PanelContainer
@onready var SnapshotMargin:MarginContainer = $SnapshotControl/PanelContainer/Overlay
@onready var SnapshotRect:TextureRect = $SnapshotControl/PanelContainer/Overlay/TextureRect

@onready var TabPanel:PanelContainer = $TabControl/PanelContainer
@onready var TabMargin:MarginContainer = $TabControl/PanelContainer/MarginContainer
@onready var CloseTab:Control = $TabControl/PanelContainer/MarginContainer/HBoxContainer/CloseTab
@onready var NoteTab:Control = $TabControl/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/NoteTab
@onready var UnusedTab:Control = $TabControl/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/UnusedTab

@onready var PreviewPanel:PanelContainer = $PreviewControl/PanelContainer
@onready var PreviewMargin:MarginContainer = $PreviewControl/PanelContainer/MarginContainer
@onready var PinControl:Control = $PreviewControl/PanelContainer/MarginContainer/Pins

@onready var NoteControl:Control = $NoteControl
@onready var NoteComponent:PanelContainer = $NoteControl/NoteComponent
@onready var NoteList:VBoxContainer = $NoteControl/NoteComponent/VBoxContainer/Content/ContentContainer/HBoxContainer/VBoxContainer/NoteList
@onready var NoNotesLabel:Label = $NoteControl/NoteComponent/VBoxContainer/Content/ContentContainer/HBoxContainer/VBoxContainer/NoNotesLabel
@onready var NoteBackIcon:Control = $NoteControl/NoteComponent/VBoxContainer/Content/ContentContainer/HBoxContainer/NoteBackIcon
@onready var NoteNextIcon:Control = $NoteControl/NoteComponent/VBoxContainer/Content/ContentContainer/HBoxContainer/NoteNextIcon
@onready var NoteCountLabel:Label = $NoteControl/NoteComponent/VBoxContainer/Header/MarginContainer/HBoxContainer/HBoxContainer/NoteCountLabel

@onready var CreateNoteControl:Control = $CreateNoteControl
@onready var CreatePanel:PanelContainer = $CreateNoteControl/PanelContainer
@onready var CreateMargin:MarginContainer = $CreateNoteControl/PanelContainer/MarginContainer
@onready var CreateLineEdit:LineEdit = $CreateNoteControl/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/ColorRect/MarginContainer/LineEdit

@onready var SaveNoteBtn:Control = $CreateNoteControl/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer2/HBoxContainer/SaveNoteBtn
@onready var CloseNoteBtn:Control = $CreateNoteControl/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer2/HBoxContainer/CloseNoteBtn

@onready var TabList:Array = [NoteTab, UnusedTab, CloseTab]

enum STATE {NONE, TAB_SELECT, SELECT_NOTE, READ_NOTE, CREATE_NOTE}

const NoteItemPreload:PackedScene = preload("res://Scenes/Note/parts/NoteItem.tscn")
const NoteLineItemPreload:PackedScene = preload("res://Scenes/Note/parts/NoteLineItem.tscn")

var current_state:STATE = STATE.NONE : 
	set(val):
		current_state = val
		on_current_state_update()

var onOpen:Callable = func():pass
var onClose:Callable = func():pass

var control_pos:Dictionary
var is_animating:bool = false 
var is_opened:bool = false

var tab_index:int = 0 : 
	set(val):
		tab_index = val
		on_tab_index_update()
	
var note_index:int = 0 : 
	set(val):
		note_index = val
		on_note_index_update()
		
var note_item_index:int = 0: 
	set(val):
		note_item_index = val
		on_note_item_index_update()

var SelectedNoteNode:Control
var SelectedNoteItemNode:Control
var notes:Array = []
var note_copy:Array = []
var note_items:Array = []
var selectable_nodes:Array = []

# -----------------------------------	
func _init() -> void:
	SUBSCRIBE.subscribe_to_notes(self)
	GBL.subscribe_to_control_input(self)	

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_notes(self)
	GBL.unsubscribe_to_control_input(self)	

func _ready() -> void:
	# CreateNoteControl.hide()
	await U.tick()
	
	control_pos[SnapshotPanel] = {
		"show": 0, 
		"hide": -SnapshotMargin.size.y
	}
	
	control_pos[TabPanel] = {
		"show": 0,
		"hide": -TabMargin.size.y
	}
	
	control_pos[PreviewPanel] = {
		"show": 0, 
		"hide": -PreviewPanel.size.y 
	}
	
	control_pos[CreatePanel] = {
		"show": 0, 
		"hide": -CreateMargin.size.y 
	}
	
	TabPanel.position.y = control_pos[TabPanel].hide	
	SnapshotPanel.position.y = control_pos[SnapshotPanel].hide
	PreviewPanel.position.y = control_pos[PreviewPanel].hide
	CreatePanel.position.y = control_pos[CreatePanel].hide
	
	NoteControl.hide()

	reveal_snapshot(false, true)
	reveal_preview(false, true)
	reveal_create_note(false, true)
	reveal_tabs(false, true)

	on_note_index_update()
	on_tab_index_update()

func end() -> void:
	reveal_preview(false)
	reveal_create_note(false)
	reveal_tabs(false)
	await reveal_snapshot(false)
	BGTextureRect.texture =	null
	onClose.call()	
	tab_index = 0
	note_index = 0
	note_copy = []
	note_items = []	
	selectable_nodes = []
	SelectedNoteNode = null
	current_state = STATE.NONE	
	is_opened = false
# -----------------------------------	

# -----------------------------------	
func on_note_update(new_val:Array) -> void:
	notes = new_val

func open_notes() -> void:
	# create copies of the node, place them in their global position
	var list:Array = []
	for index in note_copy.size():
		var node:Control = note_copy[index]
		var note_item:Control = NoteItemPreload.instantiate()
		note_item.global_position = node.global_position + Vector2(0 if node.global_position.x > GBL.game_resolution.x/2 else 50, 50)
		note_item.node_ref = node
		note_item.is_selected = index == note_index
		list.push_back(note_item)
		PinControl.add_child(note_item)	
	selectable_nodes = list
	await U.tick()	
	current_state = STATE.SELECT_NOTE
	
func on_note_index_update() -> void:
	selectable_nodes = selectable_nodes.filter(func(x): return x != null)
	if selectable_nodes.is_empty():return
	SelectedNoteNode = selectable_nodes[note_index]
	SelectedNoteNode.show_notes = false
	for child in PinControl.get_children():
		child.is_selected = SelectedNoteNode == child
	TransitionScreen.start(0.2, true, REFS.MAIN_TERMINAL_VIEWPORT)

func on_note_item_index_update() -> void:
	if note_items.is_empty():
		NoteCountLabel.text = "None"
		NoNotesLabel.show()
		NoteList.hide()
		return
	for index in NoteList.get_child_count():
		var note_node:Control = NoteList.get_child(index)
		note_node.is_selected = note_item_index == index
		if note_item_index == index:
			SelectedNoteItemNode = note_node
	NoteCountLabel.text = "%s/%s" % [note_item_index + 1, NoteList.get_child_count()]
	NoNotesLabel.hide()
	NoteList.show()

func on_tab_index_update() -> void:	
	for index in TabList.size():
		var node:Control = TabList[index]
		node.is_selected = index == tab_index
# -----------------------------------	
	
# -----------------------------------		
func get_background() -> void:
	BGTextureRect.texture = U.get_viewport_texture(GBL.find_node(REFS.MAIN_FINAL_COMPOSITION_VIEWPORT))
	SnapshotRect.texture = U.get_viewport_texture(GBL.find_node(REFS.MAIN_FINAL_COMPOSITION_VIEWPORT))

func reveal_snapshot(state:bool, skip_animation:bool = false) -> void:
	if !is_node_ready():return
	is_animating = true
	await U.tween_node_property(SnapshotPanel, "position:y", control_pos[SnapshotPanel].show if state else control_pos[SnapshotPanel].hide, 0.3 if !skip_animation else 0.02, 0, Tween.TRANS_CIRC)
	is_animating = false
	
func reveal_tabs(state:bool, skip_animation:bool = false) -> void:
	if !is_node_ready():return
	is_animating = true
	await U.tween_node_property(TabPanel, "position:y", control_pos[TabPanel].show if state else control_pos[TabPanel].hide, 0.3 if !skip_animation else 0.02, 0, Tween.TRANS_CIRC)
	is_animating = false
	
func reveal_preview(state:bool, skip_animation:bool = false) -> void:
	if !is_node_ready():return
	is_animating = true
	await U.tween_node_property(PreviewPanel, "position:y", control_pos[PreviewPanel].show if state else control_pos[PreviewPanel].hide, 0.3 if !skip_animation else 0.02, 0, Tween.TRANS_CIRC)
	is_animating = false
	
func reveal_create_note(state:bool, skip_animation:bool = false) -> void:
	if !is_node_ready():return
	is_animating = true
	await U.tween_node_property(CreatePanel, "position:y", control_pos[CreatePanel].show if state else control_pos[PreviewPanel].hide, 0.3 if !skip_animation else 0.02, 0, Tween.TRANS_CIRC)
	is_animating = false
	
func execute_prompt() -> void:
	match TabList[tab_index]:
		NoteTab:
			await reveal_tabs(false)
			reveal_preview(true)
			open_notes()
		CloseTab:
			end()

func on_current_state_update() -> void:
	if !is_node_ready():return
	
	match current_state:
		STATE.TAB_SELECT:
			NoteControl.hide()
			SelectedNoteNode = null
			for child in PinControl.get_children():
				child.queue_free()	
	
		STATE.SELECT_NOTE:			
			NoteControl.hide()
			for child in PinControl.get_children():
				child.show()
			on_note_index_update()				
			
		STATE.READ_NOTE:
			NoteControl.show()
			CreateNoteControl.hide()
			CreateLineEdit.release_focus()
			for child in PinControl.get_children():
				if SelectedNoteNode == child:
					child.show()
				else:
					child.hide()			
			populate_notes()
			
		STATE.CREATE_NOTE:
			for node in [SaveNoteBtn, CloseNoteBtn]:
				node.is_disabled = false
			CreateNoteControl.show()
			CreateLineEdit.clear()
			CreateLineEdit.grab_focus()
# -----------------------------------	

# -----------------------------------	
func populate_notes() -> void:
	for note in NoteList.get_children():
		note.queue_free()
	
	var note_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].note_data
	var all_notes := []	
	var node_ref:Control = SelectedNoteNode.node_ref

	## first, get any default notes 
	if "tutorial_notes" in node_ref:
		for content in node_ref.tutorial_notes:
			all_notes.push_back({"is_locked": true, "content": content})
	
	## then pull any saved by the user...
	if node_ref.name in note_data:
		for content in note_data[node_ref.name]:
			all_notes.push_back({"is_locked": false, "content": content})	
			
	# add notes
	for index in all_notes.size():
		var new_note_item:Control = NoteLineItemPreload.instantiate()
		var note:Dictionary = all_notes[index]
		new_note_item.is_selected = note_item_index == index
		new_note_item.content = note.content
		new_note_item.is_locked = note.is_locked
		NoteList.add_child(new_note_item)	

	# hide/show 
	for icon in [NoteBackIcon, NoteNextIcon]:
		if !NoteList.get_child_count() == 0:
			icon.show() 
		else:
			icon.hide()
	
	# reset position
	var new_pos: Vector2 = SelectedNoteNode.global_position + Vector2(0, 45)
	var detail_size:Vector2 = NoteComponent.size
	
	# smart resposition
	if new_pos.x + detail_size.x + 50 > GBL.game_resolution.x:
		new_pos.x = SelectedNoteNode.global_position.x - detail_size.x + SelectedNoteNode.size.x
	elif new_pos.x < 0:
		new_pos.x = 0
	if new_pos.y + detail_size.y > GBL.game_resolution.y:
		new_pos.y = SelectedNoteNode.global_position.y - detail_size.y - 50
	elif new_pos.y < 0:
		new_pos.y = 0
	
	var show_position:Vector2 = new_pos + Vector2(0, 10)
	NoteComponent.global_position = new_pos
	U.tween_node_property(NoteComponent, "global_position", show_position)			
	TransitionScreen.start(0.2, true, REFS.MAIN_TERMINAL_VIEWPORT)
	
	await U.tick()
	# set for indexing
	note_items = all_notes
	note_item_index = 0
# -----------------------------------	

	

# -----------------------------------	
func remove_note(index:int) -> void:
	var note_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].note_data
	if SelectedNoteNode.node_ref.name not in note_data:
		return
	note_data[SelectedNoteNode.node_ref.name].remove_at(index)
	GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].note_data = note_data
	GBL.update_and_save_user_profile()	
	SelectedNoteNode.refresh(index -1)	
	await U.tick()
	note_items = SelectedNoteNode.get_items() 
	note_item_index = U.min_max(index - 1, 0, note_items.size() - 1) 
	
func save_note() -> void:
	var note_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].note_data
	if SelectedNoteNode.node_ref.name not in note_data:
		note_data[SelectedNoteNode.node_ref.name] = []
	note_data[SelectedNoteNode.node_ref.name].push_back(CreateLineEdit.text)
	GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].note_data = note_data
	GBL.update_and_save_user_profile()	
	SelectedNoteNode.refresh(note_items.size())	
	await U.tick()
	note_items = SelectedNoteNode.get_items() 
	note_item_index = note_items.size() - 1
# -----------------------------------	

# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:	
	if !is_node_ready() or is_animating:return
	var key:String = input_data.key	
	
	
	match current_state:
		STATE.NONE:
			match key:
				"SPACE":
					if !is_opened:
						is_opened = true
						current_state = STATE.TAB_SELECT
						get_background()
						note_copy = notes.filter(func(x): return x != null).duplicate()
						await reveal_snapshot(true)
						reveal_preview(true)
						open_notes()
						onOpen.call()
		# -------------------
		STATE.TAB_SELECT:
			match key:
				"A":
					tab_index = U.min_max(tab_index - 1, 0, TabList.size() - 1, true)
				"D":
					tab_index = U.min_max(tab_index + 1, 0, TabList.size() - 1, true)
				"B":
					current_state = STATE.NONE	
					end()
				"E":
					execute_prompt()
				"ENTER":
					execute_prompt()

		# -------------------
		STATE.SELECT_NOTE:
			match key:
				"A":
					note_index = U.min_max(note_index - 1, 0, selectable_nodes.size() - 1, true)
				"D":
					note_index = U.min_max(note_index + 1, 0, selectable_nodes.size() - 1, true)
				"W":
					note_index = U.min_max(note_index - 1, 0, selectable_nodes.size() - 1, true)
				"S":
					note_index = U.min_max(note_index + 1, 0, selectable_nodes.size() - 1, true)
				"B":					
					await reveal_preview(false)
					reveal_tabs(true)
					current_state = STATE.TAB_SELECT
					
				"E":
					if SelectedNoteNode == null:return
					current_state = STATE.READ_NOTE

		# -------------------
		STATE.READ_NOTE:
			match key:
				"A":
					note_item_index = U.min_max(note_item_index - 1, 0, note_items.size() - 1)
				"D":
					note_item_index = U.min_max(note_item_index + 1, 0, note_items.size() - 1)
				"B":
					note_item_index = 0
					note_items = []
					for child in PinControl.get_children():
						child.show_notes = false
					current_state = STATE.SELECT_NOTE
				"R":
					remove_note(note_item_index)
				"E":
					reveal_create_note(true)
					current_state = STATE.CREATE_NOTE
# -------------------
		STATE.CREATE_NOTE:
			match key:
				"TAB":
					await reveal_create_note(false)
					current_state = STATE.READ_NOTE
				"ENTER":
					for node in [SaveNoteBtn, CloseNoteBtn]:
						node.is_disabled = true
					await U.set_timeout(0.3)
					await save_note()
					await reveal_create_note(false)	
					current_state = STATE.READ_NOTE

			
			# add characters...
			var new_chr:String = OS.get_keycode_string(input_data.keycode)
			match new_chr.to_upper():
				"PERIOD":
					CreateLineEdit.text += "."
				"COMMA":
					CreateLineEdit.text += ","
				"SPACE":
					CreateLineEdit.text += " "
				"BACKSPACE":
					CreateLineEdit.text = CreateLineEdit.text.substr(0, CreateLineEdit.text.length() - 1)
				_:
					if new_chr.length() == 1:
						CreateLineEdit.text +=  new_chr	
# -----------------------------------				
