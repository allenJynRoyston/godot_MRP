extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls
@onready var TextureRectUI:TextureRect = $TextureRect
@onready var TransitionScreen:Control = $TransitionScreen

@onready var ContentPanel:PanelContainer = $Content/ContentPanel
@onready var ContentMargin:MarginContainer = $Content/ContentPanel/ContentMargin

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	#BtnControls.onDirectional = on_key_press
	
	BtnControls.onAction = func() -> void:
		next()
#
	BtnControls.onBack = func() -> void:
		end(false)
			
	BtnControls.reveal(false)
	
	await U.tick()
	
	control_pos[ContentPanel] = {
		"show": 0,
		"hide": -ContentMargin.size.y
	}
	
	ContentPanel.position.y = control_pos[ContentPanel].hide
	

func activate() -> void:
	await U.tick()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end(made_changes:bool) -> void:
	U.tween_node_property(ContentPanel, 'position:y', control_pos[ContentPanel].hide)	
	await BtnControls.reveal(false)

	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0))

	await U.set_timeout(0.3)
			
	user_response.emit()
	queue_free()
# --------------------------------------------------------------------------------------------------		

# -------------------------------------------------------------------------------------------------	
func start(data:Dictionary) -> void:
	U.tween_node_property(self, 'modulate', Color(1, 1, 1, 1))
	await TransitionScreen.start()
	
	U.tween_node_property(ContentPanel, 'position:y', control_pos[ContentPanel].show)
	await BtnControls.reveal(true)
# -------------------------------------------------------------------------------------------------	

# -------------------------------------------------------------------------------------------------	
func next() -> void:
	pass
# -------------------------------------------------------------------------------------------------	
	
