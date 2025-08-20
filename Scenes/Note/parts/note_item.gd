extends PanelContainer

@onready var SelectedControl:Control = $SelectedControl

@onready var Icon:Control = $MarginContainer/HBoxContainer/SVGIcon
@onready var CursorControl:Control = $Cursor/Control

@onready var NameContainer:Control = $MarginContainer/HBoxContainer/NameContainer
@onready var NameLabel:Label = $MarginContainer/HBoxContainer/NameContainer/HBoxContainer/NameLabel

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
	
	#label_settings_copy = CountLabel.label_settings.duplicate()
	#CountLabel.label_settings = label_settings_copy
	
	CursorControl.hide()
	#NoteControl.hide()
	
	on_is_selected_update()	
	on_node_ref_update()

func refresh(on_index:int) -> void:
	on_node_ref_update()
	on_show_notes_update(on_index)

func on_node_ref_update() -> void:
	if !is_node_ready():return


func on_is_selected_update() -> void:
	if !is_node_ready():return
	await U.tick()
	
	self.z_index = 2 if is_selected else 0
	
	#NameContainer.hide() #if is_selected else NameContainer.hide()
	CursorControl.show() if is_selected else CursorControl.hide()
	#NameContainer.hide() if !is_selected else NameContainer.show()
	#NameLabel.text = node_ref.name
	#
	stylebox_copy.bg_color = Color.GREEN if !is_selected else Color.BLACK	
	stylebox_copy.bg_color.a = 1.0 if is_selected else 0.8

	#label_settings_copy.font_color = Color.GREEN if is_selected else Color.BLACK
	Icon.icon_color = Color.GREEN if is_selected else Color.BLACK
	Icon.icon = SVGS.TYPE.TARGET if is_selected else SVGS.TYPE.INVESTIGATE
	


func set_selected_index(index:int) -> void:
	var item:Dictionary = get_items()[index]
	#RemoveBtn.is_disabled = item.is_locked
	#ComponentCount.text = str(index + 1, "/", all_notes.size())
	#
	#BackIcon.icon_color = Color.DARK_GREEN if index == 0 else Color.GREEN
	#MoreIcon.icon_color = Color.DARK_GREEN if index == all_notes.size() -1 else Color.GREEN

func on_show_notes_update(default_index:int = 0) -> void:
	if !is_node_ready():return
	#NoteControl.show() if show_notes else NoteControl.hide()
	#
	#for child in NoteList.get_children():
		#child.queue_free()
			
	#if show_notes:
		#for index in all_notes.size():
			#var note:Dictionary = all_notes[index]
			#var new_note_item:Control = NoteLineItemPreload.instantiate()
			#new_note_item.is_selected = index == default_index
			#new_note_item.content = note.content
			#new_note_item.is_locked = note.is_locked
			#NoteList.add_child(new_note_item)
			#
	#await U.tick()
	#NoNotesLabel.show() if all_notes.is_empty() else NoNotesLabel.hide()
	#CounterHBox.hide() if all_notes.is_empty() else CounterHBox.show()
	#NoteContainer.size = Vector2(1, 1)

func get_items() -> Array:
	var nodes:Array = []
	#var list:Array = NoteList.get_children()
	#for index in list.size():
		#var node:Control = list[index]
		#nodes.push_back({
			#"node": node, 
			#"is_locked": node.is_locked, 
			#"index": index,
			#"node_ref": node_ref
		#})
	#

	return nodes

#var time:float
#var spin_speed = 0.0
#var target_speed = 5.0 # degrees per second	
#func _process(delta: float) -> void:
	#if !is_node_ready():return
	#time += delta
	#spin_speed = lerp(spin_speed, 1.0, 2.0 * delta)
	#CursorControl.rotation += spin_speed * delta
	# Oscillating scale between 0.8 and 1.2
	#var scale_min = 0.8
	#var scale_max = 1.2
	#var scale_range = (scale_max - scale_min) / 2.0
	#var scale_mid = (scale_max + scale_min) / 2.0
#
	#var s = scale_mid + sin(time * 3.0) * scale_range
	#CursorControl.scale = Vector2(s, s)	

	
