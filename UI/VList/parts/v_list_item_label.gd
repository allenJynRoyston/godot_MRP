extends MouseInteractions

@onready var IsSelected:Control = $IsSelected
@onready var IsNew:Control = $IsNew
@onready var Lbl:Label = $Label

var index:int 
var parent_index:int 

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass

# --------------------------------------	
func _ready() -> void:
	super._ready()
	on_data_update()
	on_is_selected_update()
	on_focus(false)
# --------------------------------------	

# --------------------------------------	
func on_focus(state:bool) -> void:
	onFocus.call(self) if state else onBlur.call(self)
	
	#var shader_material:ShaderMaterial = IsNew.material.duplicate()	
	#shader_material.set_shader_parameter("tint_color", COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE) )
	#IsNew.material = shader_material
	#
	# icon button
	IsNew.static_color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE)
	IsSelected.static_color =  COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE)
	
	var label_setting:LabelSettings = Lbl.label_settings.duplicate()
	label_setting.font_color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE)
	Lbl.label_settings = label_setting

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and "onClick" in data:
		data.onClick.call({
			"parent_index": parent_index, 
			"index": index,
			"details": data.get_details.call()
		})
# --------------------------------------		

# --------------------------------------
func on_is_selected_update() -> void:
	if !is_node_ready():return
	IsSelected.icon = SVGS.TYPE.PLUS if is_selected else SVGS.TYPE.NONE
# --------------------------------------
		
# --------------------------------------	
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	var details:Dictionary = data.get_details.call()
	Lbl.text = details.title
	
	var is_new:bool = true
	if "is_new" in data:
		is_new = data.is_new.call({
			"parent_index": parent_index, 
			"index": index,
			"data": data
		})
	
	IsNew.hide() if !is_new or "is_new" not in data else IsNew.show()
# --------------------------------------		
	
	
