extends PanelContainer

@onready var NewGameBtn:Control = $CenterContainer/VBoxContainer/MenuList/NewGameBtn
@onready var ContinueBtn:Control = $CenterContainer/VBoxContainer/MenuList/ContinueBtn
@onready var LoadBtn:Control = $CenterContainer/VBoxContainer/MenuList/LoadBtn
@onready var QuitBtn:Control = $CenterContainer/VBoxContainer/MenuList/QuitBtn

signal wait_for_input

func _ready() -> void:
	hide()
	
	NewGameBtn.onClick = func() -> void:
		wait_for_input.emit({"action": "new_game"})
	ContinueBtn.onClick = func() -> void:
		wait_for_input.emit({"action": "continue"})
	LoadBtn.onClick = func() -> void:
		wait_for_input.emit({"action": "load_game"})		
	QuitBtn.onClick = func() -> void:
		wait_for_input.emit({"action": "quit"})		

func start(fast_boot:bool = false) -> void:
	show()
