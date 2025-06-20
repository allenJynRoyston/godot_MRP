extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls
@onready var TransitionScreen:Control = $TransitionScreen

@onready var ContentPanel:PanelContainer = $Content/ContentPanel
@onready var ContentMargin:MarginContainer = $Content/ContentPanel/ContentMargin

@onready var TextureRectUI:TextureRect = $PanelContainer/MarginContainer/TextureRect

@onready var BackgroundText:Label = $Content/ContentPanel/ContentMargin/BackgroundText
@onready var ForegroundText:Label = $Content/ContentPanel/ContentMargin/ForegroundText


var terminate:bool = false
var line_index:int = 0
var text_arr:Array = []
var has_more:bool = false

var line_complete:bool = false : 
	set(val):
		line_complete = val
		on_line_complete_update()

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	#BtnControls.onDirectional = on_key_press
	
	BtnControls.onAction = func() -> void:
		next()
#
	BtnControls.onBack = func() -> void:
		end()
			
	BtnControls.reveal(false)
	
	await U.tick()
	
	control_pos[ContentPanel] = {
		"show": 0,
		"hide": -50
	}
	
	ContentPanel.position.y = control_pos[ContentPanel].hide
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:
	U.tween_node_property(ContentPanel, 'position:y', control_pos[ContentPanel].hide, 0.7)
	U.tween_node_property(self, 'modulate', Color(1, 1, 1, 0), 0.3)	
	
	BtnControls.reveal(false)
	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0))
	
	# SET THE TUTORIAL FLAG (disables inputs)
	GBL.find_node(REFS.ACTION_CONTAINER).tutorial_is_running(false)
	
	user_response.emit()
	queue_free()
# --------------------------------------------------------------------------------------------------		

# -------------------------------------------------------------------------------------------------	
func start(data:Dictionary) -> void:
	line_index = 0
	text_arr = data.text
	
	# SET THE TUTORIAL FLAG (disables inputs)
	GBL.find_node(REFS.ACTION_CONTAINER).tutorial_is_running(true)
	
	next_line()
	
	U.tween_node_property(self, 'modulate', Color(1, 1, 1, 1), 0.3)
	
	U.tween_node_property(ContentPanel, 'position:y', control_pos[ContentPanel].show)
	await BtnControls.reveal(true)
	
	
# -------------------------------------------------------------------------------------------------	

# -------------------------------------------------------------------------------------------------	
func next_line() -> void:
	var text:String = text_arr[line_index]
	BackgroundText.text = text
	ForegroundText.text = text
	ForegroundText.visible_ratio = 0
	has_more =  line_index < (text_arr.size() - 1) 
	
	BtnControls.a_btn_title = "NEXT" if has_more else "END"
	
	for index in text.length():
		var letter:String = text[index]

		if !terminate:
			ForegroundText.visible_characters = index + 1
			if ForegroundText.visible_characters >= text.length() - 1:
				line_complete = true
				return
				
			match letter:
				".":
					await U.set_timeout(0.1)
				_:
					await U.set_timeout(0.02)
# -------------------------------------------------------------------------------------------------	

# -------------------------------------------------------------------------------------------------	
func on_line_complete_update() -> void:
	if line_complete:
		ForegroundText.visible_ratio = 1

# -------------------------------------------------------------------------------------------------	

# -------------------------------------------------------------------------------------------------	
func next() -> void:
	if !line_complete:
		line_complete = true
		terminate = true
		return
	
	if has_more:
		line_complete = false
		terminate = false
		line_index += 1
		next_line()

	else:
		end()
# -------------------------------------------------------------------------------------------------	
	
