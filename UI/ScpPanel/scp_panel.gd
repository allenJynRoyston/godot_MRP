extends PanelContainer

@onready var NameLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/NameLabel
@onready var LvlLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/LvlLabel
@onready var ReadyLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer2/ReadyLabel
@onready var ScpProfileImage:TextureRect = $MarginContainer/VBoxContainer/Resources/SubViewport/ScpProfileImage


@export var ref:int = -1 : 
	set(val):
		ref = val
		on_ref_update()
		
@export var hide_level:bool = false : 
	set(val):
		hide_level = val
		on_hide_level_update()
		
@export var hide_status:bool = false : 
	set(val):
		hide_status = val
		on_hide_status_update()	

func _ready() -> void:
	on_ref_update()
	on_hide_level_update()
	on_hide_status_update()

func on_ref_update() -> void:
	if !is_node_ready() or ref == -1:return
	var scp_details:Dictionary = SCP_UTIL.return_data(ref)
	ScpProfileImage.texture = CACHE.fetch_image(scp_details.img_src)
	NameLabel.text = " %s" % [scp_details.name]

func on_hide_level_update() -> void:
	if !is_node_ready():return
	LvlLabel.hide() if hide_level else LvlLabel.show()
	
func on_hide_status_update() -> void:
	if !is_node_ready():return
	#ReadyLabel.hide() if hide_status else ReadyLabel.show()
	ReadyLabel.text = "" if hide_status else "READY! "
