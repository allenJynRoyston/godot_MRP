extends PanelContainer

@onready var BtnControls:Control = $BtnControls
@onready var FailStateBtnContainer:VBoxContainer = $MarginContainer/VBoxContainer/FailStateBtnContainer

@onready var ReturnToTitle:BtnBase = $MarginContainer/VBoxContainer/FailStateBtnContainer/ReturnToTitle
@onready var RetryBtn:BtnBase = $MarginContainer/VBoxContainer/FailStateBtnContainer/RetryBtn
@onready var RestartBtn:BtnBase =$MarginContainer/VBoxContainer/FailStateBtnContainer/RestartBtn
@onready var QuitBtn:BtnBase = $MarginContainer/VBoxContainer/FailStateBtnContainer/QuitBtn

@export var is_win_state:bool = false

signal wait_for_response

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	
	BtnControls.reveal(false)
	BtnControls.directional_pref = "UD"
	
	RetryBtn.onClick = func() -> void:
		end("RETRY")

	RestartBtn.onClick = func() -> void:
		end("RESTART")
		
	QuitBtn.onClick = func() -> void:
		end("QUIT")		
	

func start() -> void:
	modulate = Color(1, 1, 1, 1)
	
	BtnControls.itemlist = FailStateBtnContainer.get_children()
	BtnControls.item_index = 0
	BtnControls.reveal(true)
	
	
func end(action:String) -> void:
	await BtnControls.reveal(false)
	wait_for_response.emit(action)
