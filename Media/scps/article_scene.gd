extends PanelContainer

@onready var BtnControls:Control = $BtnControls

var onBack:Callable = func():pass

func _ready() -> void:
	BtnControls.onBack = func():
		await BtnControls.reveal(false)
		onBack.call()	

func switch_to() -> void:		
	BtnControls.reveal(true)
# -----------------------------------
