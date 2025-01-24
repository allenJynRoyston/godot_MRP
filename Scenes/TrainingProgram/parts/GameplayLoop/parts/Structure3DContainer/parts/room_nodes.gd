extends Control

@onready var NodeContainer:Node3D = $SubViewport/RoomColumn/NodeContainer
@onready var Column1:Node3D = $SubViewport/RoomColumn/NodeContainer/column1
@onready var Column2:Node3D = $SubViewport/RoomColumn/NodeContainer/column2
@onready var Column3:Node3D = $SubViewport/RoomColumn/NodeContainer/column3

@onready var CursorSprite:Sprite3D = $SubViewport/RoomColumn/CursorSprite

@export var assigned_wing:int = 0

var current_location:Dictionary = {} 

var previous_floor:int = -1
var previous_ring:int = -1

var is_setup:bool = false
var node_refs:Dictionary = {}
var node_ref_positions:Dictionary = {}

# --------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)

func _ready() -> void:
	on_current_location_update()
# --------------------------------------------------------

# --------------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	
	if !is_setup:
		is_setup = true
		update_refs(true)
	else:
		# wait for changes, assign new floor
		if previous_floor != current_location.floor or previous_ring != current_location.ring:
			previous_floor = current_location.floor
			previous_ring = current_location.ring
			
			for node in [Column1, Column2, Column3]:
				node.position.y = 0
			
			tween_property(Column3, "position:y", -0.25)
			tween_property(Column1, "position:y", 0.25)
			
			
			update_refs()
	
# --------------------------------------------------------

# --------------------------------------------------------
func update_refs(setup:bool = false) -> void:
	for child in NodeContainer.get_children():
		for node in child.get_children():
			node.update_refs(current_location.floor, assigned_wing)
	
	if setup:
		for child in NodeContainer.get_children():
			for node in child.get_children():
				node_refs[node.name] = node
				node_ref_positions[node.name] = node.position
				node.onFocus = func() -> void:
					tween_property(node, "position:y", node_ref_positions[node.name].y + 0.5, 0.3, 0)
					#tween_property(CursorSprite, "position", node.global_position, 0.1, 0)
				node.onBlur = func() -> void:
					tween_property(node, "position:y", node_ref_positions[node.name].y - 0.5, 0.3, 0)
# --------------------------------------------------------

# ------------------------------------------------
func tween_property(node:Node3D, property:String, new_val, duration:float = 0.3, delay:float = 0.3) -> void:
	var tween_pos:Tween = create_tween()
	tween_pos.tween_property(node, property, new_val, duration).set_trans(Tween.TRANS_SINE).set_delay(delay)
	await tween_pos.finished
# ------------------------------------------------

func _process(delta: float) -> void:
	CursorSprite.rotate_y(0.05)
