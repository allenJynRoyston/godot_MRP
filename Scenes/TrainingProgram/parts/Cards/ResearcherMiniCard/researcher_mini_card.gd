extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var AniPlayer:AnimationPlayer = $AnimationPlayer
@onready var Portrait:TextureRect = $VBoxContainer/PanelContainer/HBoxContainer/PanelContainer/Portrait
@onready var TitleLabel:Label = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/TitleLabel
@onready var SpecLabel:Label = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/MarginContainer2/HBoxContainer/SpecLabel

@onready var NoBonusLabel:Label = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/NoBonusLabel
@onready var LvlBonus:Label = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/OutputContainer/MarginContainer2/VBoxContainer2/LvlBonus
@onready var SelectedIcon:BtnBase = $Control/IconBtn

@onready var TraitContainer:VBoxContainer = $VBoxContainer/TraitContainer
@onready var TraitList:VBoxContainer = $VBoxContainer/TraitContainer/VBoxContainer/TraitList

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")

var uid:String = "" : 
	set(val):
		uid = val
		on_uid_update()

var researcher:Dictionary = {} : 
	set(val):
		researcher = val
		on_researcher_update()
		
var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

var room_config:Dictionary

func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	
func _ready() -> void:
	on_uid_update()
	on_researcher_update()
	on_is_selected_update()
	
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	on_researcher_update()
	
func on_uid_update() -> void:
	if !is_node_ready() or uid.is_empty():return
	researcher = RESEARCHER_UTIL.return_data_with_uid(uid)

func on_researcher_update() -> void:
	if !is_node_ready() or room_config.is_empty():return
	for node in TraitList.get_children():
		node.queue_free()	
			
	if researcher.is_empty():
		hide()
		return
	
	show()
	TitleLabel.text = researcher.name
	Portrait.texture = CACHE.fetch_image("res://Media/images/redacted.png" if researcher.is_empty() else researcher.img_src)
	SpecLabel.text = "" if researcher.is_empty() else RESEARCHER_UTIL.return_specialization_data(researcher.specializations[0]).name
	
	for ref in researcher.traits:
		var card:Control = TraitCardPreload.instantiate()
		card.ref = ref
		
		if !researcher.props.assigned_to_room.is_empty():
			var extract_data:Dictionary = GAME_UTIL.extract_room_details(researcher.props.assigned_to_room)
			var has_pairing:bool = ROOM_UTIL.check_for_room_pair(extract_data.room.details.ref, researcher.specializations)
			LvlBonus.show() if has_pairing else LvlBonus.hide()
			card.effect = RESEARCHER_UTIL.return_trait_details(ref, researcher.props.assigned_to_room).effect
		#
		#card.effect = item.effect
		card.show_output = true
		TraitList.add_child(card)
	

	#if "pairs_with" in room_data:
		
	
	NoBonusLabel.hide() if LvlBonus.is_visible_in_tree() else NoBonusLabel.show()

func on_is_selected_update() -> void:
	if !is_node_ready():return
	SelectedIcon.show() if is_selected else SelectedIcon.hide()
	
	if is_selected:
		AniPlayer.active = true
		AniPlayer.play("SELECTED")
	else:
		AniPlayer.stop()
		
		
