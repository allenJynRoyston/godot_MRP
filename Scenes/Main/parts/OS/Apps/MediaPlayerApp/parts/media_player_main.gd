extends PanelContainer

@onready var BtnControls:Control = $BtnControl

var onBackToDesktop:Callable = func() -> void:pass

var music_track_list:Array

# ------------------------------------------------------------------------------
func _ready() -> void:	
	BtnControls.directional_pref = "UD"
	
	BtnControls.onBack = func() -> void:
		onBackToDesktop.call()
	
	BtnControls.onUpdate = func(node:Control) -> void:
		pass
	
	BtnControls.onAction = func() -> void:
		# open music player, no music selected
		GBL.music_data = {
			"track_list": music_track_list,
			"selected": 0,
		}
		

func start() -> void:
	BtnControls.reveal(true)

func pause() -> void:
	await BtnControls.reveal(false)
	
func unpause() -> void:
	await BtnControls.reveal(true)
# ------------------------------------------------------------------------------
