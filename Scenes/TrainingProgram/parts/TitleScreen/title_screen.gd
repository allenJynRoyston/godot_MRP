extends PanelContainer

@onready var NewGameBtn:Control = $CenterContainer/VBoxContainer/MenuList/NewGameBtn
@onready var ScenarioBtn:Control = $CenterContainer/VBoxContainer/MenuList/ScenairoBtn
@onready var ContinueBtn:Control = $CenterContainer/VBoxContainer/MenuList/ContinueBtn
@onready var LoadBtn:Control = $CenterContainer/VBoxContainer/MenuList/LoadBtn
@onready var QuitBtn:Control = $CenterContainer/VBoxContainer/MenuList/QuitBtn

signal wait_for_input

func _ready() -> void:
	hide()
	disable_btns(false)
	
	NewGameBtn.onClick = func() -> void:
		end("new_game")

	ScenarioBtn.onClick = func() -> void:
		end("scenario")
		
	ContinueBtn.onClick = func() -> void:
		end("continue")
		
	LoadBtn.onClick = func() -> void:
		end("load_game")
	QuitBtn.onClick = func() -> void:
		end("quit")

func start(fast_boot:bool = false) -> void:
	print("restart...")
	show()

func end(action:String) -> void:
	disable_btns(true)
	# add animation here
	await U.set_timeout(0.5)
	hide()
	wait_for_input.emit({"action": action})

func disable_btns(state:bool) -> void:
	for btn in [NewGameBtn, ScenarioBtn, ContinueBtn, LoadBtn, QuitBtn]:
		btn.is_disabled = state
