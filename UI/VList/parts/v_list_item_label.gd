extends MouseInteractions

@onready var IsNew:TextureRect = $IsNew
@onready var Lbl:Label = $Label

var index:int 
var parent_index:int 

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass

# --------------------------------------	
func _ready() -> void:
	super._ready()
	on_data_update()
# --------------------------------------	

# --------------------------------------	
func on_focus(state:bool) -> void:
	onFocus.call(self) if state else onBlur.call(self)
	
	var shader_material:ShaderMaterial = IsNew.material.duplicate()	
	shader_material.set_shader_parameter("tint_color", Color(0, 0.965, 0.278, 1) if state else Color(0, 0.529, 0.278, 1))
	IsNew.material = shader_material
	
	var label_setting:LabelSettings = Lbl.label_settings.duplicate()
	label_setting.font_color = Color(0, 0.965, 0.278, 1) if state else Color(0, 0.529, 0.278, 1)
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
	
	
