extends PanelContainer

@onready var ColorBG:ColorRect = $ColorBG
@onready var TextureRender:TextureRect = $TextureRect
@onready var RenderSubviewport:SubViewport = $RenderSubviewport
@onready var SceneCamera:Camera3D = $RenderSubviewport/Node3D/Camera3D
@onready var IntroSubviewport:SubViewport = $SubViewport
@onready var IntroAndTitleScreen:Control = $SubViewport/IntroAndTitleScreen
@onready var SceneAnimationPlayer:AnimationPlayer = $RenderSubviewport/Node3D/SceneAnimationPlayer
@onready var BtnPanel:MarginContainer = $BtnControl/MarginContainer
@onready var LoginBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/LoginBtn

@export var skip_logo:bool = false
@export var skip_title:bool = false
@export var skip_sequence:bool = false
@export var skip_start_at:bool = false


enum MODE {INIT, START}

var control_pos:Dictionary = {}

var current_mode:MODE = MODE.INIT : 
	set(val):
		current_mode = val
		on_current_mode_update()

var is_ready:bool = false

var on_login:Callable = func():pass

signal on_finish

# ---------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)
	GBL.subscribe_to_fullscreen(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)
	GBL.unsubscribe_to_fullscreen(self)

func _ready() -> void:
	on_current_mode_update()	
	_after_ready.call_deferred()
# ---------------------------------------------

# ---------------------------------------------
func _after_ready() -> void:
	BtnPanel.modulate = Color(1, 1, 1, 0)
	
	IntroAndTitleScreen.on_end = func() -> void:
		IntroSubviewport.set_process(false)
		IntroSubviewport.get_child(0).hide()
	
	LoginBtn.onClick = func() -> void:
		if !is_ready:return
		on_login.call()
	
	IntroAndTitleScreen.skip_logo = skip_logo
	IntroAndTitleScreen.skip_title = skip_title
	IntroAndTitleScreen.skip_sequence = skip_sequence
	IntroAndTitleScreen.skip_start_at = skip_start_at
# ---------------------------------------------
		

# ---------------------------------------------
func start() -> void:
	show()	
	await U.tick()	
	current_mode = MODE.START
	control_pos[BtnPanel] = {"show": BtnPanel.position.y, "hide": BtnPanel.position.y + BtnPanel.size.y}
	BtnPanel.position.y = control_pos[BtnPanel].hide
	BtnPanel.modulate = Color(1, 1, 1, 1)


func end() -> void:
	hide()
	current_mode = MODE.INIT
	on_finish.emit()
# ---------------------------------------------

# ---------------------------------------------
func on_current_mode_update() -> void:
	if !is_node_ready():return
	match current_mode:
		# ---------
		MODE.INIT:
			
			for subviewport in [IntroSubviewport, RenderSubviewport]:
				subviewport.set_process(false)

			for node in [ColorBG, TextureRender]:
				node.show()

			ColorBG.color = Color.BLACK			
		
		# ---------
		MODE.START:
			U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
			IntroAndTitleScreen.start()
			await IntroAndTitleScreen.on_continue

			RenderSubviewport.set_process(true)

			U.tween_node_property(SceneCamera, "fov", 77, 4.0, 0, Tween.TRANS_EXPO)
			TextureRender.texture = RenderSubviewport.get_texture()

			await U.tween_node_property(SceneCamera, "rotation_degrees:y", 1, 0.7, 2.5)
			SceneAnimationPlayer.active = true
			SceneAnimationPlayer.play("LightsOn")			
			await U.tween_node_property(BtnPanel, "position:y", control_pos[BtnPanel].show, 0.7, 2.0)
			is_ready = true
		
# ---------------------------------------------	
