extends SubscribeWrapper

@onready var NameLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer2/NameLabel
@onready var ReadyLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer2/ReadyLabel
@onready var OutputTextureRect:TextureRect = $MarginContainer/VBoxContainer/Resources/TextureRect
@onready var ScpProfileImage:TextureRect = $MarginContainer/VBoxContainer/Resources/SubViewport/ScpProfileImage
		

var ref:int = -1 : 
	set(val):
		ref = val
		on_ref_update()		

func _ready() -> void:
	on_ref_update()
	
func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
	update_node()
	
func on_scp_data_update(new_val:Dictionary) -> void:
	super.on_scp_data_update(new_val)
	update_node()

func update_node() -> void:
	if !is_node_ready() or current_location.is_empty() or scp_data.is_empty():return
	var designation:String = str(current_location.floor, current_location.ring)
	var use_ref:int = -1
	for item in scp_data.contained_list:
		var scp_designation:String = str(item.location.floor, item.location.ring)
		if designation == scp_designation:
			use_ref = item.ref
	ref = use_ref
			

func on_ref_update() -> void:
	if !is_node_ready():return
	
	if ref == -1:
		NameLabel.text = "NONE"
		ScpProfileImage.texture = null
		OutputTextureRect.hide()
		return
	
	var scp_details:Dictionary = SCP_UTIL.return_data(ref)
	ScpProfileImage.texture = CACHE.fetch_image(scp_details.img_src)
	OutputTextureRect.show()
	NameLabel.text = " %s" % [scp_details.name]
