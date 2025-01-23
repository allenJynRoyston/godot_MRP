extends Control

const RoomNodePreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/Structure3DContainer/parts/RoomNode.tscn")
@onready var Column1:Node3D = $SubViewport/RoomColumn/column1
@onready var Column2:Node3D = $SubViewport/RoomColumn/column2
@onready var Column3:Node3D = $SubViewport/RoomColumn/column3

#@export var start_index:int = 0
#
#@export var stack_size:int = 0 : 
	#set(val):
		#stack_size = val
		#on_stack_size_update()


func _ready() -> void:
	for node in [Column1, Column2, Column3]:
		for child in node.get_children():
			child.assigned_floor = 0
			child.assigned_wing = 0
#
#func on_stack_size_update() -> void:
	#if !is_node_ready():return
	#for child in self.get_children():
		#child.queue_free()
		#
	#var start_at:int = ((stack_size * stack_size)) - stack_size + start_index
#
	#for n in range(stack_size):
		#var new_node:Node3D = RoomNodePreload.instantiate()
		#new_node.ref_index = start_at - (n * stack_size)
		#new_node.position = Vector3(n * 1.8, (n * 2.8), 0)
		#add_child(new_node)
#

#
#func restore(node:Node3D) -> void:
	#for index in self.get_child_count():
		#var child:Node3D = get_child(index)
		#child.fade_restore()
			#
#func make_active(node:Node3D) -> void:
	#for index in self.get_child_count():
		#var child:Node3D = get_child(index)
		##if child == node:
			##if index + 1 < self.get_child_count():
				##var top_child:Node3D = get_child(index + 1)
				##top_child.fade.call_deferred()
			##if index - 1 >= 0:
				##var btm_child:Node3D = get_child(index - 1)
				##btm_child.fade.call_deferred()
			#
#func fade_siblings(node:Node3D) -> void:
	#for index in self.get_child_count():
		#var child:Node3D = get_child(index)
		#if child == node:
			#if index + 1 < self.get_child_count():
				#var top_child:Node3D = get_child(index + 1)
				#top_child.fade.call_deferred(true)
			#if index - 1 >= 0:
				#var btm_child:Node3D = get_child(index - 1)
				#btm_child.fade.call_deferred(true)
