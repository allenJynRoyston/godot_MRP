extends PanelContainer

var gameplay_node:Control

func _ready() -> void:
	gameplay_node = GBL.find_node(REFS.GAMEPLAY_LOOP)
