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
	
func on_scp_data_update(new_val:Dictionary) -> void:
	super.on_scp_data_update(new_val)
	if !is_node_ready():return
	if scp_data.available_list.size() > 0:
		ref = scp_data.available_list[0].ref
	else:
		ref = -1

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
