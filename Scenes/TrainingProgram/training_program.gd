extends PanelContainer

@onready var LogoScreen:PanelContainer = $LogoScreen
@onready var TitleScreen:PanelContainer = $TitleScreen
@onready var GameplayLoop:PanelContainer = $GameplayLoop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LogoScreen.start()
	await LogoScreen.finished
	TitleScreen.start()
	print( await TitleScreen.wait_for_input )
