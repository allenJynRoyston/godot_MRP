extends MouseInteractions

@onready var IconImage:TextureRect = $VBoxContainer/HBoxContainer/MarginContainer/OpenIconImage
@onready var SectionLabel:Label = $VBoxContainer/HBoxContainer/SectionLabel
@onready var ItemContainer:VBoxContainer = $VBoxContainer/MarginContainer/ItemContainer
@onready var HasNewIcon:TextureRect = $VBoxContainer/HBoxContainer/HasNew

const VListItemLabelScene:PackedScene = preload("res://UI/VList/parts/VListItemLabel.tscn")
const label_settings:LabelSettings = preload("res://Fonts/settings/small_label.tres")

const minusSVG:CompressedTexture2D = preload("res://SVGs/minus-svgrepo-com.svg")
const plusSVG:CompressedTexture2D = preload("res://SVGs/plus-svgrepo-com.svg")

var parent_index:int 

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		
var is_opened:bool = true : 
	set(val):
		is_opened = val
		on_is_opened_update()
		
var active_nodes:Array[Control] = []

# --------------------------------------	
func _ready() -> void:
	super._ready()
	on_data_update()
	on_is_opened_update()
	on_focus(false)
# --------------------------------------	

# --------------------------------------	
func on_focus(state:bool) -> void:
	var shader_material:ShaderMaterial = IconImage.material.duplicate()	
	shader_material.set_shader_parameter("tint_color", Color(0, 0.965, 0.278, 1) if state else Color(0, 0.529, 0.278, 1))
	IconImage.material = shader_material
	HasNewIcon.material = shader_material
	
	var label_setting:LabelSettings = SectionLabel.label_settings.duplicate()
	label_setting.font_color = Color(0, 0.965, 0.278, 1) if state else Color(0, 0.529, 0.278, 1)
	SectionLabel.label_settings = label_setting

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and active_nodes.is_empty():
		is_opened = !is_opened
# --------------------------------------		

# --------------------------------------
func on_is_opened_update() -> void:
	IconImage.texture = plusSVG if is_opened else minusSVG
	ItemContainer.show() if is_opened else ItemContainer.hide()
# --------------------------------------	

# --------------------------------------	
func on_data_update() -> void:
	if !is_node_ready():
		return
	
	SectionLabel.text = data.section
		
	for child in ItemContainer.get_children():
		child.queue_free()
	
	is_opened = data.opened
	
	var new_count:int = 0
	
	for index in data.items.size():
		var item:Dictionary = data.items[index]
		if "render_if" in item:
			if !item.render_if.call():
				return
		
		var new_label:Control = VListItemLabelScene.instantiate()
		new_label.data = item
		new_label.index = index
		new_label.parent_index = parent_index
		
		if "is_new" in item:
			var is_new:bool = item.is_new.call({
				"parent_index": parent_index, 
				"index": index,
				"data": item
			}) 
			if is_new:
				new_count += 1
		
		new_label.onFocus = func(node:Control) -> void:
			if node not in active_nodes:
				active_nodes.push_back(node)

		new_label.onBlur = func(node:Control) -> void:
			active_nodes.erase(node)
		
		ItemContainer.add_child(new_label)
	
	
	HasNewIcon.show() if new_count > 0 else HasNewIcon.hide()
# --------------------------------------	
