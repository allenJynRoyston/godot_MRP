extends PanelContainer

@onready var StoryBtn:Control = $CenterContainer/VBoxContainer/MenuList/StoryBtn
@onready var ScenarioBtn:Control = $CenterContainer/VBoxContainer/MenuList/ScenairoBtn
@onready var ContinueBtn:Control = $CenterContainer/VBoxContainer/MenuList/ContinueBtn
@onready var LoadBtn:Control = $CenterContainer/VBoxContainer/MenuList/LoadBtn
@onready var QuitBtn:Control = $CenterContainer/VBoxContainer/MenuList/QuitBtn

@onready var ScenarioPanel:PanelContainer = $Control/ScenarioPanel
@onready var ScenarioList:VBoxContainer = $Control/ScenarioPanel/MarginContainer/VBoxContainer/ScenarioList

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var completed_scenarios:Array = []
var	disable_story:bool = false
var disable_continue:bool = false

signal wait_for_input

func _ready() -> void:
	ScenarioPanel.hide()
	disable_btns(true)
	hide()
	
	StoryBtn.onClick = func() -> void:
		end("story")

	ScenarioBtn.onClick = func() -> void:
		build_scenario_list()
		
	ContinueBtn.onClick = func() -> void:
		end("continue")
		
	QuitBtn.onClick = func() -> void:
		end("quit")

func start(fast_boot:bool = false) -> void:
	disable_btns(false)	
	show()

func end(action:String, props:Dictionary = {}) -> void:
	disable_btns(true)
	# add animation here
	await U.set_timeout(0.5)
	hide()
	wait_for_input.emit({"action": action, "props": props})

func disable_btns(state:bool) -> void:
	if !state:
		for btn in [ScenarioBtn, QuitBtn]:
			btn.is_disabled = false
		StoryBtn.is_disabled = disable_story
		ContinueBtn.is_disabled = disable_continue
	else:
		for btn in [StoryBtn, ScenarioBtn, ContinueBtn, QuitBtn]:
			btn.is_disabled = true

func build_scenario_list() -> void:
	var scenario_list:Array = SCENARIO_UTIL.get_list_of_scenarios()
	ScenarioPanel.global_position = ScenarioBtn.global_position + Vector2(ScenarioPanel.size.x, 0)
	for node in ScenarioList.get_children():
		node.queue_free()
	

	for index in range(0, completed_scenarios.size() + 2): #scenario_list.size():
		var scenario:Dictionary = scenario_list[index]
		var new_btn:Control = TextBtnPreload.instantiate()
		var is_unlocked:bool = completed_scenarios.size() >= (scenario.ref - 1)

		
		new_btn.panel_color = Color(0.138, 0.0, 0.521, 0.796)
		new_btn.title = scenario.details.title if is_unlocked else "LOCKED"
		new_btn.is_disabled = !is_unlocked
		
		new_btn.onClick = func() -> void:
			end("scenario", {"ref": scenario.ref})
			ScenarioPanel.hide()
		new_btn.onFocus = func() -> void:
			print('focus')
			
		ScenarioList.add_child(new_btn)
	
	await U.tick()
	ScenarioPanel.show()
