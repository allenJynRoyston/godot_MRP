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
@onready var IconSprite:Sprite3D = $IconSprite

@onready var RoomRender:MeshInstance3D = $Room/RoomRender
@onready var ParticleEmitter:GPUParticles3D = $Room/RoomRender/GPUParticles3D
@onready var ConstructionOmniLight:OmniLight3D = $Room/RoomRender/OmniLight3D

@onready var SafetyGate:MeshInstance3D = $Barrier/SafetyGate
@onready var SafetyLights:Node3D = $Barrier/SafetyGate/SafetyLights

@onready var Flap1:MeshInstance3D = $Gate/Flap1
@onready var Flap2:MeshInstance3D = $Gate/Flap2
@onready var Flap3:MeshInstance3D = $Gate/Flap3
@onready var Flap4:MeshInstance3D = $Gate/Flap4

@onready var room_render_material:StandardMaterial3D = RoomRender.get("surface_material_override/0").duplicate()
@onready var select_mesh_material:StandardMaterial3D = SelectorMesh.get("surface_material_override/0").duplicate()

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
func set_blueprint_mode(state:bool) -> void:
	SelectorMesh.show() if state else SelectorMesh.hide()
	IconSprite.show() if state else IconSprite.hide()
	Links.show() if state else Links.hide()
	RoomNode3d.hide() if state else RoomNode3d.show()
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

func on_assigned_location_update() -> void:
	reset_vars()	
	
	LinkLeft.show() if U.location_lookup(assigned_location.room, U.DIR.LEFT) != -1 else LinkLeft.hide()
	LinkRight.show() if U.location_lookup(assigned_location.room, U.DIR.RIGHT) != -1 else LinkRight.hide()
	LinkTop.show() if U.location_lookup(assigned_location.room, U.DIR.UP) != -1 else LinkTop.hide()
	LinkBottom.show() if U.location_lookup(assigned_location.room, U.DIR.DOWN) != -1 else LinkBottom.hide()
			
	U.debounce(str(self, "_update_room_data"), update_room_data)

func update_room_data() -> void:
	if !is_node_ready() or room_config.is_empty() or current_location.is_empty() or assigned_location.is_empty():return
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(assigned_location)
	var is_under_construction:bool = false if room_extract.room.is_empty() else room_extract.room.is_under_construction	
	var is_empty:bool = room_extract.room.is_empty()
	var room_details:Dictionary = room_extract.room.details if !is_empty else {}
	var is_activated:bool = false if is_empty else room_extract.room.is_activated
	var is_built:bool =  false if is_empty else !is_under_construction and is_activated
	var skip_animation:bool = true # leave this set to true
	var final_color:Color
	
	select_mesh_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	select_mesh_material.albedo_color = (Color.GREEN_YELLOW if is_empty else Color.ORANGE) if assigned_location.room == current_location.room else Color.WHITE
	select_mesh_material.albedo_color.a = 0.5 if is_under_construction else 1
	
	IconSprite.texture = CACHE.fetch_svg( SVGS.TYPE.NONE if is_empty else SVGS.TYPE.BUILD if is_under_construction else SVGS.TYPE.CONTAIN )
	
	if is_under_construction or is_activated:
		room_render_material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL# if is_under_construction else BaseMaterial3D.SHADING_MODE_PER_PIXEL
		room_render_material.albedo_color = Color.LIGHT_BLUE if is_under_construction else Color.WHITE
		room_render_material.albedo_color.a = 0.5 if is_under_construction else 1
		
		Barrier.show() if is_under_construction else Barrier.hide()
		
		animate_under_construction(true, true)
		animate_built(true, true)
		return
		
	# HIDE ALL
	Barrier.hide() 
	animate_under_construction(false, true)
	animate_built(false, true)
	

	# overhead build mode (non texture)
	#match camera_viewpoint:
		#CAMERA.VIEWPOINT.OVERHEAD:
			#set_texture(RoomRenderBuiltMaterial)
			#OriginalMaterial.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		#
			
			#
			#if is_under_construction:		
				#final_color = Color.DARK_TURQUOISE
			#else:
				#final_color = Color.ORANGE
			#
				#
			#DuplicateMaterial.albedo_color = final_color
			#RoomMesh.surface_set_material(0, DuplicateMaterial)
			#
			## update sprite icon
			#IconSprite.texture = CACHE.fetch_svg(SVGS.TYPE.NONE if is_empty else (SVGS.TYPE.BUILD if is_under_construction else SVGS.TYPE.CONTAIN)  )
			#
			## show/hide nodes
			##RoomNode3d.hide()
			##IconSprite.show() if is_under_construction or !is_empty else IconSprite.hide()
			###SelectorMesh.show()
			#Gate.hide()
			#Barrier.hide()	
		#
		## normal view mode (fully textured)
		#_:
			### check if under construction
			#if is_under_construction:
				#set_texture(RoomRenderUnderConstructionMaterial)
				#final_color = OriginalMaterial.albedo_color
				#animate_under_construction(is_under_construction, skip_animation)
			#
			## or if it's activated
			#if !is_empty and !is_under_construction:
				#set_texture(RoomRenderBuiltMaterial)
				#final_color = OriginalMaterial.albedo_color	 if is_activated else Color.ORANGE
				#animate_built(true, skip_animation)

			## and then apply mesh and albedo
			#if is_under_construction or !is_empty:
				#match room_extract.room.details.environmental.temp:
					## hot (blue shades)
					#-1:
						#final_color = OriginalMaterial.albedo_color + Color(0, 0, 0.2)  
					#-2:
						#final_color = OriginalMaterial.albedo_color + Color(0, 0, 0.5)
					#-3:
						#final_color = OriginalMaterial.albedo_color + Color(0, 0, 0.9)
						#
					## hot (red shades)
					#1:
						#final_color = OriginalMaterial.albedo_color + Color(0.2, 0, 0)  
					#2:
						#final_color = OriginalMaterial.albedo_color + Color(0.5, 0, 0)  
					#3:
						#final_color = OriginalMaterial.albedo_color + Color(0.9, 0, 0)  
##
##
				## default color is current color
				#final_color.a = 1 if is_selected else 0.5
					#
				#DuplicateMaterial.albedo_color = final_color
				#RoomMesh.surface_set_material(0, DuplicateMaterial)
				##return
				#
			#SelectorMesh.hide()
			#IconSprite.hide()
			#RoomNode3d.show()
			#Gate.show()
			#Barrier.show()
			#
			#if !is_empty:
				#print("location: ", assigned_location,  "    is_under_construction: ", is_under_construction,  "    is_built: ", is_built)
			#
			#
			### if room is empty, reset all
			#if is_under_construction:
				#animate_under_construction(true, skip_animation)
				#animate_built(false, skip_animation)
				#return
			#
			#if is_built:
				#animate_under_construction(false, skip_animation)
				#animate_built(true, skip_animation)
				#return
				#
			#animate_under_construction(false, skip_animation)
			#animate_built(false, skip_animation)

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var time:float = 0
var speed:float = 5.0
func _process(delta: float) -> void:
	pass
	#SelectorMesh.hide()
	#if under_construction:
		#time += delta
		#var value:float = 3.0 + (8.0 - 3.0) * ((sin(time * speed) + 1.2) / 2.0)
		#ConstructionOmniLight.light_energy = value
# ------------------------------------------------------------------------------
