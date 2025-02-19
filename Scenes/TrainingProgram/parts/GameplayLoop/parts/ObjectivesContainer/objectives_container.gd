extends GameContainer

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()

func _exit_tree() -> void:
	super._exit_tree()

func _ready() -> void:
	super._ready()	
	
func on_is_showing_update() -> void:	
	super.on_is_showing_update()
	show() if is_showing else hide()
# --------------------------------------------------------------------------------------------------		
