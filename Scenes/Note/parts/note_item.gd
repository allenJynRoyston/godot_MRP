extends PanelContainer

@onready var SelectedControl:Control = $SelectedControl

@onready var Icon:Control = $MarginContainer/HBoxContainer/SVGIcon
@onready var CountLabel:Label = $MarginContainer/HBoxContainer/MarginContainer/CountLabel



@onready var NoteControl:Control = $NoteControl
@onready var NoteContainer:PanelContainer = $NoteControl/PanelContainer/NoteContainer
@onready var ComponentName:Label = $NoteControl/PanelContainer/NoteContainer/VBoxContainer/MarginContainer3/HBoxContainer/ComponentName
@onready var ComponentCount:Label = $NoteControl/PanelContainer/NoteContainer/VBoxContainer/MarginContainer3/HBoxContainer/Counter/ComponentCount
@onready var CounterHBox:HBoxContainer = $NoteControl/PanelContainer/NoteContainer/VBoxContainer/MarginContainer3/HBoxContainer/Counter
@onready var BackIcon:Control = $NoteControl/PanelContainer/NoteContainer/VBoxContainer/MarginContainer3/HBoxContainer/Counter/BackIcon
@onready var MoreIcon:Control = $NoteControl/PanelContainer/NoteContainer/VBoxContainer/MarginContainer3/HBoxContainer/Counter/MoreIcon
@onready var NoteList:VBoxContainer = $NoteControl/PanelContainer/NoteContainer/VBoxContainer/MarginContainer/VBoxContainer/NoteList
@onready var CreateBtn:Control = $NoteControl/PanelContainer/NoteContainer/VBoxContainer/MarginContainer2/HBoxContainer/CreateBtn
@onready var RemoveBtn:Control = $NoteControl/PanelContainer/NoteContainer/VBoxContainer/MarginContainer2/HBoxContainer/RemoveBtn
@onready var NoNotesLabel:Label = $NoteControl/PanelContainer/NoteContainer/VBoxContainer/MarginContainer/VBoxContainer/NoNotesLabel

const NoteLineItemPreload:PackedScene = preload("res://Scenes/Note/parts/NoteLineItem.tscn")

var stylebox_copy:StyleBoxFlat
var label_settings_copy:LabelSettings
var all_notes:Array = []

var node_ref:Control : 
	set(val):
		node_ref = val
		on_node_ref_update()

var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
	
var show_notes:bool = false : 
	set(val):
		show_notes = val
		on_show_notes_update()
		
func _ready() -> void:
	stylebox_copy = $".".get("theme_override_styles/panel").duplicate()
	$".".set("theme_override_styles/panel", stylebox_copy)
	
	label_settings_copy = CountLabel.label_settings.duplicate()
	CountLabel.label_settings = label_settings_copy
	
	SelectedControl.hide()
	NoteControl.hide()
	
	on_is_selected_update()	
	on_node_ref_update()

func refresh(on_index:int) -> void:
	on_node_ref_update()
	on_show_notes_update(on_index)

func on_node_ref_update() -> void:
	if !is_node_ready():return
	var note_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].note_data
	all_notes = []
	
	# first, get any default notes 
	if "tutorial_notes" in node_ref:
		for content in node_ref.tutorial_notes:
			all_notes.push_back({"is_locked": true, "content": content})
	
	# then pull any saved by the user...
	if node_ref.name in note_data:
		for content in note_data[node_ref.name]:
			all_notes.push_back({"is_locked": false, "content": content})

	NoteList.hide() if all_notes.is_empty() else NoteList.show()

	ComponentName.text = node_ref.name
	CountLabel.text = str(all_notes.size())
	

func on_is_selected_update() -> void:
	if !is_node_ready():return
	await U.tick()
	SelectedControl.show() if is_selected else SelectedControl.hide()
	stylebox_copy.bg_color = Color.GREEN if !is_selected else Color.BLACK	
	stylebox_copy.bg_color.a = 1.0 if is_selected else 0.8

	label_settings_copy.font_color = Color.GREEN if is_selected else Color.BLACK
	Icon.icon_color = Color.GREEN if is_selected else Color.BLACK
	Icon.icon = SVGS.TYPE.INFO if is_selected else SVGS.TYPE.QUESTION_MARK
	

func set_selected_index(index:int) -> void:
	var item:Dictionary = get_items()[index]
	RemoveBtn.is_disabled = item.is_locked
	ComponentCount.text = str(index + 1, "/", all_notes.size())
	
	BackIcon.icon_color = Color.DARK_GREEN if index == 0 else Color.GREEN
	MoreIcon.icon_color = Color.DARK_GREEN if index == all_notes.size() -1 else Color.GREEN

func on_show_notes_update(default_index:int = 0) -> void:
	if !is_node_ready():return
	NoteControl.show() if show_notes else NoteControl.hide()
	
	for child in NoteList.get_children():
		child.queue_free()
			
	if show_notes:
		for index in all_notes.size():
			var note:Dictionary = all_notes[index]
			var new_note_item:Control = NoteLineItemPreload.instantiate()
			new_note_item.is_selected = index == default_index
			new_note_item.content = note.content
			new_note_item.is_locked = note.is_locked
			NoteList.add_child(new_note_item)
			
	await U.tick()
	NoNotesLabel.show() if all_notes.is_empty() else NoNotesLabel.hide()
	CounterHBox.hide() if all_notes.is_empty() else CounterHBox.show()
	NoteContainer.size = Vector2(1, 1)

func get_items() -> Array:
	var nodes:Array = []
	var list:Array = NoteList.get_children()
	for index in list.size():
		var node:Control = list[index]
		nodes.push_back({
			"node": node, 
			"is_locked": node.is_locked, 
			"index": index,
			"node_ref": node_ref
		})
	

	return nodes
	
