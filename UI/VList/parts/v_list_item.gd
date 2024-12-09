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

var on_opened_changed:Callable = func():pass

var on_item_focus_change:Callable = func(state:bool, data:Dictionary) -> void:pass

var on_list_focus_change:Callable = func(state:bool) -> void:pass

# --------------------------------------	
func _ready() -> void:
	super._ready()
	on_data_update()
	on_is_opened_update()
	on_focus(false)
# --------------------------------------	

# --------------------------------------	
func on_focus(state:bool) -> void:
	on_list_focus_change.call(state)
	GBL.change_mouse_icon(GBL.MOUSE_ICON.POINTER if state else GBL.MOUSE_ICON.CURSOR)

	var shader_material:ShaderMaterial = IconImage.material.duplicate()	
	shader_material.set_shader_parameter("tint_color", COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE) )
	IconImage.material = shader_material
	HasNewIcon.material = shader_material
	
	var label_setting:LabelSettings = SectionLabel.label_settings.duplicate()
	label_setting.font_color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE)
	SectionLabel.label_settings = label_setting

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
	if on_hover and active_nodes.is_empty():
		is_opened = !is_opened
# --------------------------------------		

# --------------------------------------
func on_is_opened_update() -> void:
	IconImage.texture = plusSVG if is_opened else minusSVG
	ItemContainer.show() if is_opened else ItemContainer.hide()
	on_opened_changed.call(is_opened)
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
	
	var selected:Array = []
	if "selected" in data:
		selected = data.selected
	
	for index in data.items.size():
		var item:Dictionary = data.items[index]
		
		var render_if:bool = true
		if "render_if" in item:
			render_if = item.render_if.call(item.get_details.call())
		
		if render_if:
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
			
			new_label.is_selected = index in selected
			
			new_label.onFocus = func(node:Control) -> void:
				if node not in active_nodes:
					active_nodes.push_back(node)
				on_item_focus_change.call(true, item)

			new_label.onBlur = func(node:Control) -> void:
				active_nodes.erase(node)
				on_item_focus_change.call(false, item)
			
			ItemContainer.add_child(new_label)
	
	HasNewIcon.show() if new_count > 0 else HasNewIcon.hide()
# --------------------------------------	
