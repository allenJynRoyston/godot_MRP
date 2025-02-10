@tool
extends GameContainer

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	
# -----------------------------------------------

func on_is_showing_update() -> void:	
	super.on_is_showing_update()
	print(is_showing)
	show() if is_showing else hide()
