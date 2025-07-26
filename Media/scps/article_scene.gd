extends PanelContainer

@onready var BtnControls:Control = $BtnControls

func switch_to() -> void:		
	BtnControls.reveal(true)
