extends Control

@onready var EmptyPanel:PanelContainer = $EmptyPanel

@onready var ImageTextureRect:TextureRect = $MarginContainer/FrontDrawerContainer/ImageTexture
@onready var NameLabel:Label = $MarginContainer/FrontDrawerContainer/NameContainer/MarginContainer/NameLabel
@onready var NicknameLabel:Label = $MarginContainer/FrontDrawerContainer/NicknameContainer/MarginContainer/Nickname

@onready var StatusContainer:PanelContainer = $MarginContainer/FrontDrawerContainer/ImageTexture/StatusContainer
@onready var StatusLabel:Label = $MarginContainer/FrontDrawerContainer/ImageTexture/StatusContainer/CenterContainer/StatusLabel

@export var is_highlighted:bool = false : 
	set(val):
		is_highlighted = val
		on_is_highlighted_update()
		
@export var scp_ref:int = -1: 
	set(val):
		scp_ref = val
		on_scp_ref_update()

var index:int
var is_contained:bool = false
var scp_data:Dictionary = {}

# --------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_scp_data(self)

func _ready() -> void:
	on_scp_ref_update()
	on_is_highlighted_update()
	
	is_highlighted = false	
# --------------------------------------

# --------------------------------------	
func on_is_highlighted_update() -> void:
	if !is_node_ready():return
	self.modulate = Color(1, 1, 1, 1 if is_highlighted else 0.5)
# --------------------------------------		

# --------------------------------------	
func on_scp_ref_update() -> void:
	U.debounce(str(self, "_update_content"), update_content)

func on_scp_data_update(new_val:Dictionary) -> void:
	scp_data = new_val
	U.debounce(str(self, "_update_content"), update_content)
# --------------------------------------		

# --------------------------------------		
func update_content() -> void:	
	if !is_node_ready():return
	StatusContainer.hide()
	if scp_ref == -1:
		EmptyPanel.show()
		ImageTextureRect.texture = null
		return
	EmptyPanel.hide()
	
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	ImageTextureRect.texture = CACHE.fetch_image(scp_details.img_src) 
	NameLabel.text = scp_details.name
	NicknameLabel.text = scp_details.nickname
	
	# so it can be referenced on the node level
	is_contained = scp_ref in scp_data
	StatusContainer.show() if is_contained else StatusContainer.hide()
	StatusLabel.text = "ALREADY CONTAINED" if is_contained else ""
# --------------------------------------		
