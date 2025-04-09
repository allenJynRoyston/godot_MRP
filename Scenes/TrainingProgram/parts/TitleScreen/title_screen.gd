extends PanelContainer

@onready var NewGameBtn:Control = $CenterContainer/VBoxContainer/MenuList/NewGameBtn
@onready var ScenarioBtn:Control = $CenterContainer/VBoxContainer/MenuList/ScenairoBtn
@onready var ContinueBtn:Control = $CenterContainer/VBoxContainer/MenuList/ContinueBtn
@onready var LoadBtn:Control = $CenterContainer/VBoxContainer/MenuList/LoadBtn
@onready var QuitBtn:Control = $CenterContainer/VBoxContainer/MenuList/QuitBtn

@onready var ScenarioPanel:PanelContainer = $Control/ScenarioPanel
@onready var ScenarioList:VBoxContainer = $Control/ScenarioPanel/MarginContainer/VBoxContainer/ScenarioList

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

signal wait_for_input

func _ready() -> void:
	ScenarioPanel.hide()
	
	hide()
	disable_btns(false)
	
	NewGameBtn.onClick = func() -> void:
		end("new_game")

	ScenarioBtn.onClick = func() -> void:
		build_scenario_list()
		
	ContinueBtn.onClick = func() -> void:
		end("continue")
		
	LoadBtn.onClick = func() -> void:
		end("load_game")
	QuitBtn.onClick = func() -> void:
		end("quit")

func start(fast_boot:bool = false) -> void:
	show()

func end(action:String, props:Dictionary = {}) -> void:
	disable_btns(true)
	# add animation here
	await U.set_timeout(0.5)
	hide()
	wait_for_input.emit({"action": action, "props": props})

func disable_btns(state:bool) -> void:
	for btn in [NewGameBtn, ScenarioBtn, ContinueBtn, LoadBtn, QuitBtn]:
		btn.is_disabled = state

func build_scenario_list() -> void:
	var scenario_list:Array = SCP_UTIL.get_list_of_scenarios()
	ScenarioPanel.global_position = ScenarioBtn.global_position + Vector2(ScenarioPanel.size.x, 0)
	for node in ScenarioList.get_children():
		node.queue_free()
	
	for index in scenario_list.size():
		var new_btn:Control = TextBtnPreload.instantiate()
		var ref:int = scenario_list[index]
		var scp_details:Dictionary = SCP_UTIL.return_data(ref)

		new_btn.panel_color = Color(0.138, 0.0, 0.521, 0.796)
		new_btn.title = scp_details.name
		new_btn.index = index
		
		new_btn.onClick = func() -> void:
			end("scenario", {"ref": ref})
			ScenarioPanel.hide()
		new_btn.onFocus = func() -> void:
			print('focus')
			
		ScenarioList.add_child(new_btn)
	
	await U.tick()
	ScenarioPanel.show()
