@tool
extends VBoxContainer

@onready var TitleLabel:Label = $PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TitleLabel
@onready var List:VBoxContainer = $PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/List

@onready var ApLabel:Label = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer2/ApLabel
@onready var ApDiffLabel:Label = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer2/ApDiffLabel

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

@onready var extract_data:Dictionary : 
	set(val):
		extract_data = val
		on_extract_data_update()

const str_len:int = 18

# --------------------
func _ready() -> void:
	on_extract_data_update()
# --------------------

# --------------------
func on_extract_data_update() -> void:
	if !is_node_ready() or extract_data.is_empty():return
	clear_list()

	#var test:String 
	#if extract_data.room.is_empty():
		#hide()
		#return
	#
	#show()
	#
	#var active_abilities:Array = extract_data.room.abilities
	#var passive_abilities:Array = extract_data.room.passive_abilities

	#for index in active_abilities.size():
		#var ability:Dictionary = active_abilities[index]
		##if upgrade_level >= ability.available_at_lvl:
		#var new_btn:Control = TextBtnPreload.instantiate()
		#new_btn.is_hoverable = false
		#new_btn.panel_color = Color.TRANSPARENT
		#new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#new_btn.title = ability.name if ability.name.length() <= str_len else str(ability.name.substr(0, str_len), "...")
		##new_btn.is_disabled = ap < ability.ap_cost
		##new_btn.icon = SVGS.TYPE.CLEAR if ap < ability.ap_cost else SVGS.TYPE.NEXT
		#List.add_child(new_btn)
		#
	##for index in passive_abilities.size():
		##var ability:Dictionary = passive_abilities[index]
		###if upgrade_level >= ability.available_at_lvl:
		##var new_btn:Control = TextBtnPreload.instantiate()
		##new_btn.is_hoverable = false
		##new_btn.panel_color = Color.TRANSPARENT
		##new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		##new_btn.title = ability.name if ability.name.length() <= str_len else str(ability.name.substr(0, 20), "...")
		###new_btn.is_disabled = ability.available_at_lvl < upgrade_level
		##new_btn.icon = SVGS.TYPE.CHECKBOX if index in room_state.passives_enabled else SVGS.TYPE.EMPTY_CHECKBOX
		##List.add_child(new_btn)		
	#
	#TitleLabel.text =  " %s" % ["PASSIVE ABILITIES" if passive_abilities.size() > 0 else "ABILITIES"]
	
	#ApLabel.text = str(ap)
	#ApDiffLabel.text = str(ap_diff)
# --------------------

# --------------------
func clear_list() -> void:
	if !is_node_ready() or Engine.is_editor_hint():return
	for child in List.get_children():
		child.free()
# --------------------
