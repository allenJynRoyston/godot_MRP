extends Control

@onready var Snapshot:Control = $Snapshot
@onready var SnapshotRect:TextureRect = $Snapshot/SubViewport/SnapshotTextureRect

@onready var PreviewControl:Control = $PreviewControl
@onready var PromptContainer:PanelContainer = $PromptControl/PanelContainer
@onready var PromptLabel:Label = $PromptControl/PanelContainer/Terminal/MarginContainer/HBoxContainer/PromptLabel

@onready var CreateNoteControl:Control = $CreateNoteControl
@onready var CreateLineEdit:LineEdit = $CreateNoteControl/CenterContainer/PanelContainer/VBoxContainer/ColorRect/MarginContainer/LineEdit

enum STATE {PROMPT, SELECT_NOTE, READ_NOTE, CREATE_NOTE}

const NoteItemPreload:PackedScene = preload("res://Scenes/Note/parts/NoteItem.tscn")

var current_state:STATE = STATE.PROMPT : 
	set(val):
		current_state = val
		on_current_state_update()

var prompts:Array = [
	{
		"title": "close",
		"func": end
	},
	{
		"title": "note.exe",
		"func": open_notes
	}
]

var onOpen:Callable = func():pass
var onClose:Callable = func():pass

var control_pos:Dictionary
var is_animating:bool = false 
var is_opened:bool = false

var prompt_index:int = 1 : 
	set(val):
		prompt_index = val
		on_prompt_index_update()
		
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
	CreateNoteControl.hide()
	
	await U.tick()
	control_pos[PromptContainer] = {
		"show": 0,
		"hide": -(PromptContainer.size.x + 20)
	}
	
	PromptContainer.position.x = control_pos[PromptContainer].hide
	reveal(false, true)
	on_prompt_index_update()
	on_note_index_update()

func end() -> void:
	await reveal(false)
	is_opened = false
	prompt_index = 1
	note_index = 0
	note_copy = []
	selectable_nodes = []
	note_items = []
	SelectedNoteNode = null
	current_state = STATE.PROMPT
	onClose.call()	
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
		note_item.global_position = (node.global_position + node.size)/2
		note_item.node_ref = node
		note_item.is_selected = index == note_index
		list.push_back(note_item)
		PreviewControl.add_child(note_item)	
	selectable_nodes = list
	await U.tick()	
	current_state = STATE.SELECT_NOTE
	

func on_note_index_update() -> void:
	selectable_nodes = selectable_nodes.filter(func(x): return x != null)
	if selectable_nodes.is_empty():return
	SelectedNoteNode = selectable_nodes[note_index]
	SelectedNoteNode.show_notes = false
	for child in PreviewControl.get_children():
		child.is_selected = SelectedNoteNode == child
	

func on_note_item_index_update() -> void:
	if note_items.is_empty():return
	for index in note_items.size():
		var item:Dictionary = note_items[index]
		item.node.is_selected = note_item_index == index
		if note_item_index == index:
			SelectedNoteItemNode = item.node
			SelectedNoteNode.set_selected_index(index)
# -----------------------------------	
	
# -----------------------------------		
func get_background() -> void:
	SnapshotRect.texture = U.get_viewport_texture(GBL.find_node(REFS.MAIN_FINAL_COMPOSITION_VIEWPORT))

func reveal(state:bool, skip_animation:bool = false) -> void:
	if !is_node_ready():return
	
	if state:
		Snapshot.show()	
		
	is_animating = true
	await U.tween_node_property(PromptContainer, "position:x", control_pos[PromptContainer].show if state else control_pos[PromptContainer].hide, 0.7 if !skip_animation else 0.02, 0, Tween.TRANS_CIRC)
	is_animating = false
	
	if !state:
		Snapshot.hide()

func execute_prompt() -> void:
	prompts[prompt_index].func.call()

func on_prompt_index_update() -> void:
	if !is_node_ready():return
	PromptLabel.text = prompts[prompt_index].title
	
func on_current_state_update() -> void:
	if !is_node_ready():return
	
	match current_state:
		STATE.PROMPT:
			SelectedNoteNode = null
			for child in PreviewControl.get_children():
				child.queue_free()	
	
		STATE.SELECT_NOTE:			
			for child in PreviewControl.get_children():
				child.show()
			on_note_index_update()				
			
		STATE.READ_NOTE:
			CreateNoteControl.hide()
			CreateLineEdit.release_focus()
			
		STATE.CREATE_NOTE:
			CreateNoteControl.show()
			CreateLineEdit.clear()
			CreateLineEdit.grab_focus()
# -----------------------------------	

# -----------------------------------	
func remove_note(index:int) -> void:
	var note_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].note_data
	if SelectedNoteNode.node_ref.name not in note_data:
		return
	
	note_data[SelectedNoteNode.node_ref.name].remove_at(index - 1)
	GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].note_data = note_data
	GBL.update_and_save_user_profile()	
	SelectedNoteNode.refresh()	
	await U.tick()
	note_items = SelectedNoteNode.get_items() 
	note_item_index = index
	
func save_note() -> void:
	var note_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].note_data
	if SelectedNoteNode.node_ref.name not in note_data:
		note_data[SelectedNoteNode.node_ref.name] = []
	note_data[SelectedNoteNode.node_ref.name].push_back(CreateLineEdit.text)
	GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].note_data = note_data
	GBL.update_and_save_user_profile()	
	SelectedNoteNode.refresh()	
	await U.tick()
	note_items = SelectedNoteNode.get_items() 
	note_item_index = note_items.size() - (2 if note_items.size() > 1 else 1)
# -----------------------------------	

# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:	
	if !is_node_ready() or is_animating:return
	var key:String = input_data.key	
	
	if !is_opened:
		match key:
			"SPACE":			
				is_opened = true
				# get background
				get_background()
				# get copy of notes (as it will be empty once the onOpen is called)
				note_copy = notes.duplicate()
				# reveal
				await reveal(true)
				# hide other scenes
				onOpen.call()
				# open notes by default
				execute_prompt()
		return

	match current_state:
		# -------------------
		STATE.PROMPT:
			match key:
				"W":
					prompt_index = U.min_max(prompt_index - 1, 0, prompts.size() - 1, true)
				"S":
					prompt_index = U.min_max(prompt_index + 1, 0, prompts.size() - 1, true)
				"B":
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
					prompt_index = 0
					current_state = STATE.PROMPT
				"E":
					if SelectedNoteNode == null:return
					current_state = STATE.READ_NOTE
					
					for child in PreviewControl.get_children():
						if SelectedNoteNode == child:
							child.show()
						else:
							child.hide()
					SelectedNoteNode.show_notes = true
					
					# set to first item (should always have one)
					await U.tick()
					note_items = SelectedNoteNode.get_items() 
					note_item_index = 0	
					
		# -------------------
		STATE.READ_NOTE:
			match key:
				"W":
					note_item_index = U.min_max(note_item_index - 1, 0, note_items.size() - 1, true)
				"S":
					note_item_index = U.min_max(note_item_index + 1, 0, note_items.size() - 1, true)
				"B":
					note_item_index = 0
					note_items = []
					for child in PreviewControl.get_children():
						child.show_notes = false
					current_state = STATE.SELECT_NOTE
				"E":
					var item:Dictionary = note_items[note_item_index]
					match item.action:
						'delete':
							remove_note(item.index)							
						"create":
							current_state = STATE.CREATE_NOTE
		# -------------------
		STATE.CREATE_NOTE:
			match key:
				"TAB":
					current_state = STATE.READ_NOTE
				"ENTER":
					await save_note()
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
