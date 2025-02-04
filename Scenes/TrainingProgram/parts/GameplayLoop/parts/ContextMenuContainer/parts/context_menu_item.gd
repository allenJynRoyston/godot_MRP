extends PanelContainer

@onready var TextureRectContainer:TextureRect = $TextureRect
@onready var MenuContent:Control = $SubViewport/Control/MenuContent


const spacing:int = 20 

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var freeze_input:bool = true
var onRemoved:Callable = func() -> void:pass

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)
	
func _ready() -> void:
	TextureRectContainer.modulate = Color(1, 1, 1, 0)
	on_data_update()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func get_menu_content() -> Dictionary:
	return {"size": MenuContent.size, "global_pos": MenuContent.global_position}
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_data_update() -> void:
	if !is_node_ready():return
	# default position
	var context_menu_position:Vector2 = Vector2(100, self.size.y - 100)	
	var menu_data:Dictionary = data.menu
	var previous_node_data:Dictionary = data.previous_node_data
	
	if "position" in menu_data:
		context_menu_position = menu_data.position
	
	if "placement" in menu_data and !previous_node_data.is_empty():
		context_menu_position = previous_node_data.global_pos
		
		match menu_data.placement:
			GBL.PLACEMENT.TOP:
				context_menu_position += Vector2(0, -previous_node_data.size.y - spacing)
			GBL.PLACEMENT.BOTTOM:
				context_menu_position += Vector2(0, previous_node_data.size.y + spacing)
			GBL.PLACEMENT.RIGHT:
				context_menu_position += Vector2(previous_node_data.size.x + spacing, 0)
			GBL.PLACEMENT.LEFT:
				context_menu_position += Vector2(-previous_node_data.size.x - spacing, 0)
	
	
	
	# menu content position
	MenuContent.global_position = context_menu_position
	await U.tick()
	U.tween_node_property(TextureRectContainer, "modulate", Color(1, 1, 1, 1), 0.3)
	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func animate_in() -> void:
	await U.tween_node_property(self, "position:y", 0, 0.3, 0, Tween.TRANS_EXPO)	

func animate_out() -> void:
	freeze_input = true
	await U.tween_node_property(self, "position:y", -self.size.y, 0.3, 0, Tween.TRANS_EXPO)
	onRemoved.call()
	self.queue_free()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or freeze_input:return
	var key:String = input_data.key
	match key:
		"BACK":
			animate_out()
# ------------------------------------------------------------------------------
