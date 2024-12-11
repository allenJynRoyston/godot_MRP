extends PanelContainer

func _ready() -> void:
	GBL.register_subviewports([$SubViewport])	

func _exit_tree() -> void:
	GBL.unregister_subviewports([$SubViewport])
