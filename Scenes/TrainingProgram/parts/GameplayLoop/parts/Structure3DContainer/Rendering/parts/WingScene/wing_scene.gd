@tool
extends Node3D

@onready var R1:Node3D = $MeshRender/Rooms/R1
@onready var R2:Node3D = $MeshRender/Rooms/R2
@onready var R3:Node3D = $MeshRender/Rooms/R3
@onready var R4:Node3D = $MeshRender/Rooms/R4
@onready var R5:Node3D = $MeshRender/Rooms/R5
@onready var R6:Node3D = $MeshRender/Rooms/R6
@onready var R7:Node3D = $MeshRender/Rooms/R7
@onready var R8:Node3D = $MeshRender/Rooms/R8
@onready var R9:Node3D = $MeshRender/Rooms/R9

@onready var G1:Node3D = $MeshRender/Gates/G1
@onready var G2:Node3D = $MeshRender/Gates/G2
@onready var G3:Node3D = $MeshRender/Gates/G3
@onready var G4:Node3D = $MeshRender/Gates/G4
@onready var G5:Node3D = $MeshRender/Gates/G5
@onready var G6:Node3D = $MeshRender/Gates/G6
@onready var G7:Node3D = $MeshRender/Gates/G7
@onready var G8:Node3D = $MeshRender/Gates/G8
@onready var G9:Node3D = $MeshRender/Gates/G9

@export var r1_under_construction:bool = false : 
	set(val): r1_under_construction = val; on_r1_under_construction_update()
@export var r2_under_construction:bool = false : 
	set(val): r2_under_construction = val; on_r2_under_construction_update()
@export var r3_under_construction:bool = false : 
	set(val): r3_under_construction = val; on_r3_under_construction_update()
@export var r4_under_construction:bool = false : 
	set(val): r4_under_construction = val; on_r4_under_construction_update()
@export var r5_under_construction:bool = false :
	set(val): r5_under_construction = val; on_r5_under_construction_update()
@export var r6_under_construction:bool = false : 
	set(val): r6_under_construction = val; on_r6_under_construction_update()
@export var r7_under_construction:bool = false : 
	set(val): r7_under_construction = val; on_r7_under_construction_update()
@export var r8_under_construction:bool = false : 
	set(val): r8_under_construction = val; on_r8_under_construction_update()
@export var r9_under_construction:bool = false : 
	set(val): r9_under_construction = val; on_r9_under_construction_update()

@export var r1_is_empty:bool = false : 
	set(val): r1_is_empty = val; on_r1_is_empty()

@export var r2_is_empty: bool = false :
	set(val): r2_is_empty = val; on_r2_is_empty()

@export var r3_is_empty: bool = false :
	set(val): r3_is_empty = val; on_r3_is_empty()

@export var r4_is_empty: bool = false :
	set(val): r4_is_empty = val; on_r4_is_empty()

@export var r5_is_empty: bool = false :
	set(val): r5_is_empty = val; on_r5_is_empty()

@export var r6_is_empty: bool = false :
	set(val): r6_is_empty = val; on_r6_is_empty()

@export var r7_is_empty: bool = false :
	set(val): r7_is_empty = val; on_r7_is_empty()

@export var r8_is_empty: bool = false :
	set(val): r8_is_empty = val; on_r8_is_empty()

@export var r9_is_empty: bool = false :
	set(val): r9_is_empty = val; on_r9_is_empty()


func _ready() -> void:
	on_r1_is_empty()
	on_r2_is_empty()
	on_r3_is_empty()
	on_r3_is_empty()
	on_r4_is_empty()
	on_r5_is_empty()
	on_r6_is_empty()
	on_r7_is_empty()
	on_r8_is_empty()
	on_r9_is_empty()

	
func on_r1_is_empty() -> void:
	await update_empty_room(R1, G1, r1_is_empty)
func on_r2_is_empty() -> void:
	await update_empty_room(R2, G2, r2_is_empty)
func on_r3_is_empty() -> void:
	await update_empty_room(R3, G3, r3_is_empty)
func on_r4_is_empty() -> void:
	await update_empty_room(R4, G4, r4_is_empty)
func on_r5_is_empty() -> void:
	await update_empty_room(R5, G5, r5_is_empty)
func on_r6_is_empty() -> void:
	await update_empty_room(R6, G6, r6_is_empty)
func on_r7_is_empty() -> void:
	await update_empty_room(R7, G7, r7_is_empty)
func on_r8_is_empty() -> void:
	await update_empty_room(R8, G8, r8_is_empty)
func on_r9_is_empty() -> void:
	await update_empty_room(R9, G9, r9_is_empty)


func on_r1_under_construction_update() -> void: 
	await update_room_gate(R1, G1, r1_under_construction)
func on_r2_under_construction_update() -> void:
	await update_room_gate(R2, G2, r2_under_construction)
func on_r3_under_construction_update() -> void: 
	await update_room_gate(R3, G3, r3_under_construction)
func on_r4_under_construction_update() -> void: 
	await update_room_gate(R4, G4, r4_under_construction)
func on_r5_under_construction_update() -> void: 
	await update_room_gate(R5, G5, r5_under_construction)
func on_r6_under_construction_update() -> void: 
	await update_room_gate(R6, G6, r6_under_construction)
func on_r7_under_construction_update() -> void: 
	await update_room_gate(R7, G7, r7_under_construction)
func on_r8_under_construction_update() -> void: 
	await update_room_gate(R8, G8, r8_under_construction)
func on_r9_under_construction_update() -> void: 
	await update_room_gate(R9, G9, r9_under_construction)


func update_empty_room(room: Node3D, gate: Node3D, is_empty: bool) -> void:
	if !is_node_ready(): return
	if is_empty:
		gate.raise_gate = false
		await U.set_timeout(0.5)
		gate.open_flaps = false
		room.raise = false

func update_room_gate(room: Node3D, gate: Node3D, is_under_construction: bool) -> void:
	if !is_node_ready(): return
	
	if !is_under_construction:
		if gate:
			gate.raise_gate = is_under_construction
			await U.set_timeout(0.5)
			gate.open_flaps = !is_under_construction
			await U.set_timeout(0.5)
		room.raise = !is_under_construction
	else:
		room.raise = !is_under_construction
		await U.set_timeout(0.5)
		if gate:
			gate.open_flaps = !is_under_construction
			await U.set_timeout(0.5)
			gate.raise_gate = is_under_construction
