@tool
extends BtnBase

#@onready var RootPanel:PanelContainer = $"."
#
#@onready var IconBtn:Control = $MarginContainer/HBoxContainer/CostAndCooldown/MarginContainer/HBoxContainer/SVGIcon
#
#@onready var CostAndCooldown:Control = $MarginContainer/HBoxContainer/CostAndCooldown
#@onready var LvlLabel:Label = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Label
#@onready var NameLabel:Label = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/NameLabel
#
##@onready var SpecLabel:Label = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Spec
##@onready var TraitLabel:Label = $MarginContainer/HBoxContainer/Name/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Trait
###
#@export var panel_color:Color = Color("0e0e0ecb") : 
	#set(val):
		#panel_color = val
		#on_panel_color_update()		
#
#var preview_mode:bool = false
#var use_location:Dictionary = {}
#var room_details:Dictionary = {}
#
#var hired_lead_researchers:Array = []
#
#var researcher:Dictionary = {} : 
	#set(val):
		#researcher = val
		#on_researcher_update()
#
#var is_selected:bool = false : 
	#set(val):
		#is_selected = val
		#on_is_selected_update()
#
#var is_available:bool = true
#
#const LabelSettingsPreload:LabelSettings = preload("res://Fonts/font_1_black.tres")
#
## ------------------------------------------------------------------------------
#func _init() -> void:
	#super._init()
	#SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)
#
#func _exit_tree() -> void:
	#super._exit_tree()
	#SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
#
#func _ready() -> void:
	#super._ready()	
	#on_hired_lead_researchers_arr_update.call_deferred()
## ------------------------------------------------------------------------------
#
## ------------------------------------------------------------------------------
#func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers) -> void:
	#hired_lead_researchers = new_val
	#if room_details.is_empty():return
	#
	#var required_slot:Dictionary = RESEARCHER_UTIL.return_specialization_data(room_details.required_staffing[index])
#
	#var filtered:Array = hired_lead_researchers.filter(func(x):
		#var researcher_data:Dictionary = RESEARCHER_UTIL.get_user_object(x)
		#var assigned_room:Dictionary = researcher_data.props.assigned_to_room
		#var slot:int = researcher_data.props.slot
		#var specialization_ref:int = researcher_data.specialization.ref
#
		#var is_assigned_to_room:bool = !assigned_room.is_empty()
		#var matches_location:bool = assigned_room == use_location
		#var is_specialist_match:bool = specialization_ref == required_slot.ref
#
		#if required_slot.ref == RESEARCHER.SPECIALIZATION.ANY:
			#return (is_assigned_to_room and matches_location) and (slot == index)
		#
		#return  (is_assigned_to_room and matches_location) and (slot == index) and is_specialist_match
	#)
	#
	#researcher = RESEARCHER_UTIL.get_user_object(filtered[0]) if filtered.size() > 0 else {}
#
#func on_researcher_update() -> void:
	#if !is_node_ready():return
	#is_available = researcher.is_empty()
	#

	#update_all()
#
#func on_is_selected_update() -> void:
	#if !is_node_ready():return
	#U.debounce(str(self.name, "_update_all"), update_all)
#
#
#func update_all() -> void:
	#update_font_color()
	#on_panel_color_update()
	#update_text()	
#
#func update_font_color() -> void:
	#if !is_node_ready():return
	#var label_duplicate:LabelSettings = LabelSettingsPreload.duplicate()
	#var use_color:Color = COLORS.primary_black 
	#var altered:bool = false
	#
	#if !preview_mode:
		#if researcher.is_empty():
			#use_color = COLORS.disabled_color
			#altered = true
	#
	#use_color.a = 1 if is_selected else 0.7
	#
				#
	#label_duplicate.font_color = use_color
	#for node in [NameLabel]:
		#node.label_settings = label_duplicate	
	#IconBtn.icon_color = use_color
#
#func on_panel_color_update() -> void:
	#if !is_node_ready():return
	#var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()	
	#var use_color:Color = COLORS.primary_color 
	#var altered:bool = false
#
	#if !preview_mode:
		#if researcher.is_empty():
			#use_color = COLORS.primary_black
			#altered = true
		#
	#use_color.a = 1 if is_selected else 0.7		
		#
	#new_stylebox.bg_color = use_color
	#RootPanel.add_theme_stylebox_override("panel", new_stylebox)	
#
	#
#func update_text() -> void:
	#if !is_node_ready():return
	#var required_slot:Dictionary = RESEARCHER_UTIL.return_specialization_data(room_details.required_staffing[index])
		#
	#if researcher.is_empty():
		#CostAndCooldown.show()
		#IconBtn.icon = SVGS.TYPE.PLUS
		##LvlLabel.hide()
		#NameLabel.text = "ASSIGN %s" % [required_slot.name]
		#
		#hint_title = "HINT"
		#hint_icon = SVGS.TYPE.PLUS
		#hint_description = "This room requires a %s to be activated." % required_slot.name
		#return
	#
	#CostAndCooldown.show()
	#IconBtn.icon = SVGS.TYPE.ASSIGN
	#LvlLabel.text = str(researcher.level)
	##LvlLabel.show()
	#
	#NameLabel.text = researcher.name
	##SpecLabel.text = "" if researcher.is_empty() else researcher.specialization.details.name	
	##TraitLabel.text = "" if researcher.is_empty() else researcher.trait.details.name
	##
	#hint_title = "HINT"
	#hint_description = str("Slotted by ",  researcher.name, ".")
## ------------------------------------------------------------------------------
#
## ------------------------------------------------------------------------------	
#func on_focus(state:bool = is_focused) -> void:
	#super.on_focus(state)
	#if !is_node_ready():return
	#update_font_color()
	#on_panel_color_update()
## ------------------------------------------------------------------------------
