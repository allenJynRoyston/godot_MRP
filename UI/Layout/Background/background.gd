extends PanelContainer

#func _ready() -> void:
	#GBL.subscribe_to_resolution([$SubViewport, $SubViewport2])	
#
#func _exit_tree() -> void:
	#GBL.unsubscribe_to_resolution([$SubViewport, $SubViewport2])
