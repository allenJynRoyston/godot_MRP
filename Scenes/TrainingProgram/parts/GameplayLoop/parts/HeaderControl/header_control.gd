extends GameContainer

@onready var HeaderContent:Control = $HeaderControl

func on_is_showing_update() -> void:	
	super.on_is_showing_update()
	HeaderContent.reveal(true)
