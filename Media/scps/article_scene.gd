extends PanelContainer

@onready var BtnControls:Control = $BtnControls

var onBack:Callable = func():pass

func _ready() -> void:
	BtnControls.onBack = func():
		pause()

func switch_to() -> void:		
	print('revealed?')
	BtnControls.reveal(true)

func pause() -> void:
	await BtnControls.reveal(false)
	onBack.call()	
	
func resume() -> void:
	print('resume?')
	await BtnControls.reveal(true)
# -----------------------------------
