extends Node3D

@onready var RoomNode3d:Node3D = $Room
@onready var Barrier:Node3D = $Barrier
@onready var Gate:Node3D = $Gate

@onready var Links:Node3D = $Links
@onready var LinkLeft:MeshInstance3D = $Links/Left
@onready var LinkRight:MeshInstance3D = $Links/Right
@onready var LinkTop:MeshInstance3D = $Links/Top
@onready var LinkBottom:MeshInstance3D = $Links/Bottom

@onready var SelectorMesh:MeshInstance3D = $SelectorMesh
# @onready var BuildSprite:Sprite3D = $BuildSprite
@onready var InfluencedSprite:Sprite3D = $InfluencedSprite

@onready var RoomRender:MeshInstance3D = $Room/RoomRender
@onready var ParticleEmitter:GPUParticles3D = $ConstructionFX/GPUParticles3D
@onready var ConstructionOmniLight:OmniLight3D = $ConstructionFX/OmniLight3D

@onready var SafetyGate:MeshInstance3D = $Barrier/SafetyGate
@onready var SafetyLights:Node3D = $Barrier/SafetyGate/SafetyLights

@onready var Flap1:MeshInstance3D = $Gate/Flap1
@onready var Flap2:MeshInstance3D = $Gate/Flap2
@onready var Flap3:MeshInstance3D = $Gate/Flap3
@onready var Flap4:MeshInstance3D = $Gate/Flap4

@onready var room_render_material:StandardMaterial3D = RoomRender.get("surface_material_override/0").duplicate()
@onready var select_mesh_material:StandardMaterial3D = SelectorMesh.get("surface_material_override/0").duplicate()
@onready var left_link_material:StandardMaterial3D = LinkLeft.get("surface_material_override/0").duplicate()
@onready var right_link_material:StandardMaterial3D = LinkRight.get("surface_material_override/0").duplicate()
@onready var top_link_material:StandardMaterial3D = LinkTop.get("surface_material_override/0").duplicate()
@onready var bottom_link_material:StandardMaterial3D = LinkBottom.get("surface_material_override/0").duplicate()

@onready var room_render_shader:ShaderMaterial = room_render_material.get("next_pass").duplicate()

@export var room_type:int
@export var skip_animation:bool = false

#const RoomRenderUnderConstructionMaterial:BaseMaterial3D = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/Structure3DContainer/Rendering/parts/Wing/part/WingRender/parts/RoomRender/textures/RoomRender_UnderConstruction.tres")
#const RoomRenderBuiltMaterial:BaseMaterial3D = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/Structure3DContainer/Rendering/parts/Wing/part/WingRender/parts/RoomRender/textures/RoomRender_Built.tres")
const animation_speed:float = 0.2

var current_location:Dictionary
var camera_settings:Dictionary
var room_config:Dictionary

var is_selected:bool = true : 
	set(val):
		is_selected = val
		on_is_selected_update()

var assigned_location:Dictionary = {} : 
	set(val):
		assigned_location = val
		on_assigned_location_update()
		
var camera_viewpoint:CAMERA.VIEWPOINT : 
	set(val):
		camera_viewpoint = val
		on_camera_viewpoint_update()

# var RoomMesh:Mesh
#var OriginalMaterial:StandardMaterial3D
#var DuplicateMaterial:StandardMaterial3D

var room_render_tween:Tween
var safety_gate_tween:Tween
var gate_one_tween:Tween
var gate_two_tween:Tween

var previous_is_construction_state:bool
var previous_built_state:bool

var unavailable_rooms:Array = []
var under_construction_is_animating:bool = false
var build_is_animating:bool = false

var preview_room:bool = false : 
	set(val):
		preview_room = val
		on_preview_room_update()
		
var preview_room_ref:int : 
	set(val):
		preview_room_ref = val
		on_preview_room_ref_update()

var influenced_by:Array = [] : 
	set(val):
		influenced_by = val
		on_influenced_by_update()

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_unavailable_rooms(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_unavailable_rooms(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)

func _ready() -> void:
	reset_vars()
	
	on_is_selected_update()
	on_camera_viewpoint_update()
	
	SelectorMesh.set("surface_material_override/0", select_mesh_material)
	RoomRender.set("surface_material_override/0", room_render_material)
	LinkBottom.set("surface_material_override/0", bottom_link_material)
	LinkTop.set("surface_material_override/0",top_link_material)
	LinkLeft.set("surface_material_override/0", left_link_material)
	LinkRight.set("surface_material_override/0", right_link_material)	
	
	room_render_material.set("next_pass", room_render_shader)
	
	set_blueprint_mode(false)


func reset_vars() -> void:	
	under_construction_is_animating = false
	build_is_animating = false


func stop_animations() -> void:
	for tween in [room_render_tween, safety_gate_tween, gate_one_tween, gate_two_tween]:
		if tween != null and tween.is_running():
			tween.stop()	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func custom_tween_node_property(tween:Tween, node:Node, prop:String, new_val, duration:float = 0.3, delay:float = 0, trans:int = Tween.TRANS_QUAD, ease:int = Tween.EASE_IN_OUT) -> void:
	if tween != null and tween.is_running():
		tween.stop()
		
	tween = create_tween()
	
	if duration == 0:
		duration = 0.02
		
	tween.tween_property(node, prop, new_val, duration).set_trans(trans).set_ease(ease).set_delay(delay)
	await tween.finished
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
#func start_construction() -> void:
	#await animate_under_construction(true)
#
#func animate_construction() -> void:
	#
	##await animate_under_construction(false)
	##await animate_built(true)
	#
#func cancel_construction() -> void:	
	#await animate_under_construction(false)
	#reset_vars()	
	#
#func destroy_room() -> void:
	#await animate_built(false)
	#reset_vars()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func animate_under_construction(state:bool, skip_animation:bool = false) -> void:
	if !is_node_ready() or under_construction_is_animating:return
	under_construction_is_animating = true

	# stops animations if they're active
	stop_animations()

	# no animation
	if skip_animation:
		Flap1.position.x = -13 if state else -4
		Flap2.position.x =  13 if state else 4
		Flap3.position.z = -13 if state else -4
		Flap4.position.z =  13 if state else 4
		SafetyGate.position.y = 1.3 if state else -1.3
		RoomRender.position.y = 7.0 if state else -10

		# special check for safety lights
		ConstructionOmniLight.show() if (state and camera_viewpoint != CAMERA.VIEWPOINT.OVERHEAD) else ConstructionOmniLight.hide()
		for node in [RoomRender, SafetyLights, ParticleEmitter, ConstructionOmniLight]:
			if state:
				node.show() 
			else: 
				node.hide()	
				
		await U.tick()
		under_construction_is_animating = false
		return
	
	# else animate...
	if state:
		for node in [SafetyLights, ParticleEmitter, RoomRender]:
			node.show()
		ConstructionOmniLight.show() if (state and camera_viewpoint != CAMERA.VIEWPOINT.OVERHEAD) else ConstructionOmniLight.hide()		
	
		# animate		
		await custom_tween_node_property(safety_gate_tween, SafetyGate, "position:y", 1.3, animation_speed)
		
		custom_tween_node_property(gate_one_tween, Flap1, "position:x", -13 if state else -4, animation_speed)
		await custom_tween_node_property(gate_two_tween, Flap2, "position:x", 13 if state else 4, animation_speed)
		custom_tween_node_property(gate_one_tween, Flap3, "position:z", -13 if state else -4, animation_speed)
		await custom_tween_node_property(gate_two_tween, Flap4, "position:z", 13 if state else 4, animation_speed)
		
		await custom_tween_node_property(room_render_tween, RoomRender, "position:y",  7.0 if state else -10, animation_speed, 0.5)
	
	# finish animating
	if !state:
		# animate		
		await custom_tween_node_property(safety_gate_tween, SafetyGate, "position:y", -1.3, animation_speed)				
		await custom_tween_node_property(room_render_tween, RoomRender, "position:y",  7.0 if state else -10, animation_speed)		
		
		custom_tween_node_property(gate_two_tween, Flap4, "position:z", 13 if state else 4, animation_speed, 0.5)
		await custom_tween_node_property(gate_one_tween, Flap3, "position:z", -13 if state else -4, animation_speed)
		custom_tween_node_property(gate_two_tween, Flap2, "position:x", 13 if state else 4, animation_speed)
		await custom_tween_node_property(gate_one_tween, Flap1, "position:x", -13 if state else -4, animation_speed)
	
		for node in [ParticleEmitter, ConstructionOmniLight, RoomRender, SafetyLights]:
			node.hide()
	#
	#under_construction_is_animating = false
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func animate_built(state:bool, skip_animation:bool = false) -> void:
	if !is_node_ready() or build_is_animating:return
	build_is_animating = true
	
	# stops animations if they're active
	stop_animations()	
	
	# no animation
	if skip_animation:
		# hide gates, etc
		#if state:			
			#animate_under_construction(false, true)	
		
		# set position
		RoomRender.position.y = 5.0 if state else -10
		
		# set hide/show state
		RoomRender.show() if state else RoomRender.hide()
				
		await U.tick()
		build_is_animating = false
		return
		
	## first animate gates
	#await animate_under_construction(false, true)	
	#

	# show states
	if state:
		RoomRender.show()
	
	# else animate...
	await custom_tween_node_property(room_render_tween, RoomRender, "position:y",  7.0 if state else -10, animation_speed)
	
	# finish animating
	if !state:
		RoomRender.hide()
		
	build_is_animating = false
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var in_blueprint_mode:bool
func set_blueprint_mode(state:bool) -> void:
	in_blueprint_mode = state
	for node in [SelectorMesh, Links, InfluencedSprite]:
		if state:
			node.show() 
		else:
			node.hide()
	
	room_render_shader.set_shader_parameter("enable_pulse", false)	
	room_render_shader.set_shader_parameter("enable_wireframe", state)
	U.debounce(str(self, "_update_room_data"), update_room_data)

func on_preview_room_ref_update() -> void:
	U.debounce(str(self, "_update_room_data"), update_room_data)

func on_preview_room_update() -> void:		
	room_render_shader.set_shader_parameter("enable_pulse", preview_room)
	if !preview_room:
		RoomRender.rotation.y = deg_to_rad(0)
	U.debounce(str(self, "_update_room_data"), update_room_data)

func on_camera_viewpoint_update() -> void:
	U.debounce(str(self, "_update_room_data"), update_room_data)

func on_is_selected_update() -> void:
	U.debounce(str(self, "_update_room_data"), update_room_data)

func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	U.debounce(str(self, "_update_room_data"), update_room_data)
	
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce(str(self, "_update_room_data"), update_room_data)

func on_unavailable_rooms_update(new_val:Array) -> void:
	unavailable_rooms = new_val
	U.debounce(str(self, "_update_room_data"), update_room_data)
	
func on_influenced_by_update() -> void:
	U.debounce(str(self, "_update_room_data"), update_room_data)

func on_assigned_location_update() -> void:
	reset_vars()	
	
	LinkLeft.show() if U.location_lookup(assigned_location.room, U.DIR.LEFT) != -1 else LinkLeft.hide()
	LinkRight.show() if U.location_lookup(assigned_location.room, U.DIR.RIGHT) != -1 else LinkRight.hide()
	LinkTop.show() if U.location_lookup(assigned_location.room, U.DIR.UP) != -1 else LinkTop.hide()
	LinkBottom.show() if U.location_lookup(assigned_location.room, U.DIR.DOWN) != -1 else LinkBottom.hide()
			
	U.debounce(str(self, "_update_room_data"), update_room_data)

func update_room_data() -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty() or assigned_location.is_empty():return
	var is_under_construction:bool = ROOM_UTIL.is_under_construction(assigned_location)
	var is_room_empty:bool = ROOM_UTIL.is_room_empty(assigned_location)
	var is_activated:bool = ROOM_UTIL.is_room_activated(assigned_location)
	var is_room_under_construction:bool = ROOM_UTIL.is_under_construction(assigned_location)	
	var room_details:Dictionary = ROOM_UTIL.return_data_via_location(assigned_location)
	var all_influenced_rooms:Dictionary = ROOM_UTIL.find_all_influenced_rooms(true)
	var room_config_level:Dictionary = GAME_UTIL.get_room_level_config(assigned_location)
	var is_built:bool =  false if is_room_empty else !is_room_under_construction and is_activated
	var final_color:Color
	
	# side bars
	for material in [bottom_link_material, top_link_material, left_link_material, right_link_material]:
		material.albedo_color = Color.ORANGE_RED		
					
	
	# assign node color
	select_mesh_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	select_mesh_material.albedo_color = Color.WHITE
	
	if is_built or is_under_construction:
		match room_details.ref:
			ROOM.REF.ADMIN_DEPARTMENT: 
				select_mesh_material.albedo_color = Color.BLUE
			ROOM.REF.LOGISTICS_DEPARTMENT: 
				select_mesh_material.albedo_color = Color.GREEN
			ROOM.REF.ENGINEERING_DEPARTMENT: 
				select_mesh_material.albedo_color = Color.ORANGE
		
			
	#elif is_under_construction:
		#select_mesh_material.albedo_color = Color.RED

	# is selected
	select_mesh_material.albedo_color = select_mesh_material.albedo_color.darkened(0.3) if assigned_location.room == current_location.room else select_mesh_material.albedo_color
	
	# assign influence sprite
	var has_room_influence:bool = false
	var has_scp_influence:bool = false
	var use_icon:SVGS.TYPE = SVGS.TYPE.NONE
	

	has_room_influence = !influenced_by.is_empty()
	
	if assigned_location.room in all_influenced_rooms:		
		for item in all_influenced_rooms[assigned_location.room]:
			if item.has("room_ref"):
				has_room_influence = true
		for item in all_influenced_rooms[assigned_location.room]:
			if item.has("scp_ref"):
				has_scp_influence = true
	if has_room_influence:
		use_icon = SVGS.TYPE.SETTINGS
	if has_scp_influence:
		use_icon = SVGS.TYPE.CONTAIN
	if has_room_influence and has_scp_influence:
		use_icon = SVGS.TYPE.LAYERS
	InfluencedSprite.texture = CACHE.fetch_svg( use_icon ) 	
	
	# is in preview mode
	if preview_room:
		# get preview for preview_room
		var preview_room_details:Dictionary = ROOM_UTIL.return_data(preview_room_ref)
		room_render_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		room_render_material.albedo_color = Color.BLACK
		room_render_material.albedo_color.a = 0.5
		if assigned_location.room == current_location.room:
			select_mesh_material.albedo_color = Color.LIGHT_STEEL_BLUE
				
		animate_built(true, true)
		return

	#  update if not construction
	if is_under_construction or is_activated:
		if in_blueprint_mode:
			room_render_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
			room_render_material.albedo_color = Color.BLACK
			room_render_material.albedo_color.a = 0.5
		else:			
			room_render_material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
			room_render_material.albedo_color = Color.LIGHT_BLUE if is_under_construction else Color.WHITE
			room_render_material.albedo_color.a = 0.5 if is_under_construction else 1

		Barrier.show() if is_under_construction and !in_blueprint_mode else Barrier.hide()
		
		animate_under_construction(true, true)
		animate_built(true, true)
		return

		
	# HIDE ALL
	Barrier.hide() 
	animate_under_construction(false, true)
	animate_built(false, true)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var rotation_speed: float = 30.0  # degrees per second
var current_angle: float = 0.0

func _process(delta: float) -> void:
	if !is_node_ready():
		return
	if preview_room:
		# Increment angle
		current_angle += rotation_speed * delta
		# Keep angle in 0-360 range
		current_angle = fmod(current_angle, 360.0)
		RoomRender.rotation.y = deg_to_rad(current_angle)
# ------------------------------------------------------------------------------
