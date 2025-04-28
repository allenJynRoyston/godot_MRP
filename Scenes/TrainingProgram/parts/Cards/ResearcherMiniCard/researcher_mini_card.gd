extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var AniPlayer:AnimationPlayer = $AnimationPlayer
@onready var SelectedIcon:BtnBase = $Control/IconBtn
@onready var CardDrawerTitle:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/CardDrawerTitle
@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/CardDrawerImage

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

func _ready() -> void:
	on_uid_update()
	on_researcher_update()
	on_is_selected_update()
	
func on_uid_update() -> void:
	if !is_node_ready() or uid.is_empty():return
	researcher = RESEARCHER_UTIL.return_data_with_uid(uid)

func on_researcher_update() -> void:
	if !is_node_ready():return
	
	if researcher.is_empty():
		return
	
	var spec:String = "" if researcher.is_empty() else RESEARCHER_UTIL.return_specialization_data(researcher.specializations[0]).name	
	var traits:String = ""
	var has_pairing:bool = false 
	
	for ref in researcher.traits:
		traits += str(RESEARCHER_UTIL.return_trait_data(ref).name, " , ")
	traits = traits.left(traits.length() - 3)
		
	if !researcher.props.assigned_to_room.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details(researcher.props.assigned_to_room)
		if !has_pairing:
			has_pairing = ROOM_UTIL.check_for_room_pair(extract_data.room.details.ref, researcher)
	
	CardDrawerTitle.title = "RESEARCHER %s" % researcher.name
	CardDrawerTitle.content = "%s | %s" % [spec, traits]	
	CardDrawerImage.img_src = researcher.img_src


func on_is_selected_update() -> void:
	if !is_node_ready():return
	SelectedIcon.show() if is_selected else SelectedIcon.hide()
	
	if is_selected:
		AniPlayer.active = true
		AniPlayer.play("SELECTED")
	else:
		AniPlayer.stop()
		
		
