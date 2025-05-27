extends PanelContainer

@onready var MenuList:VBoxContainer = $CenterContainer/VBoxContainer/MenuList

@onready var StoryBtn:Control = $CenterContainer/VBoxContainer/MenuList/StoryBtn
@onready var TutorialBtn:Control = $CenterContainer/VBoxContainer/MenuList/TutorialBtn
@onready var ScenarioBtn:Control = $CenterContainer/VBoxContainer/MenuList/ScenairoBtn
@onready var ContinueBtn:Control = $CenterContainer/VBoxContainer/MenuList/ContinueBtn

@onready var BtnControls:Control = $BtnControl
#@onready var QuitBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/QuitBtn
#@onready var NextBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/NextBtn

@onready var ScenarioPanel:Control = $ScenarioPanel
@onready var ScenarioMarginContainer:MarginContainer = $ScenarioPanel/MarginContainer/PanelContainer/ScrollContainer/MarginContainer
@onready var ScenarioList:HBoxContainer = $ScenarioPanel/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/ScenarioList

@onready var ContinueDetails:PanelContainer = $ContinueControl/ContinueDetails
@onready var DetailName:Label = $ContinueControl/ContinueDetails/MarginContainer/VBoxContainer/VBoxContainer/DetailName
@onready var DetailDay:Label = $ContinueControl/ContinueDetails/MarginContainer/VBoxContainer/VBoxContainer/DetailDay
@onready var DetailDate:Label = $ContinueControl/ContinueDetails/MarginContainer/VBoxContainer/VBoxContainer/DetailDate

enum MODE {TITLE, SCENARIO}

const ScenarioBtnPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/TitleScreen/parts/ScenarioBtn.tscn")

var scenario_list:Array = []
var current_mode:MODE = MODE.TITLE : 
	set(val):
		current_mode = val
		on_current_mode_update()

var completed_scenarios:Array = []
var	disable_story:bool = false
var disable_scenario:bool = false
var has_quicksave:bool = false
var freeze_inputs:bool = false : 
	set(val):
		freeze_inputs = val
		on_freeze_inputs_update()
var quickload_data:Dictionary = {}
var btn_arr:Array[Control] = []
var slist:Array = []
var selected_index:int = 0 : 
	set(val):
		selected_index = val
		on_selected_index_update()
		
var scenario_index:int = 0 : 
	set(val):
		scenario_index = val
		on_scenario_index_update()

signal wait_for_input

# ------------------------------------------
func _ready() -> void:
	ScenarioPanel.hide()
	disable_btns(true)
	hide()
	
	StoryBtn.onClick = func() -> void:
		end("story")
		
	TutorialBtn.onClick = func() -> void:
		build_tutorial_list() 
		current_mode = MODE.SCENARIO

	ScenarioBtn.onClick = func() -> void:
		build_scenario_list()
		current_mode = MODE.SCENARIO
		
	ContinueBtn.onClick = func() -> void:
		end("continue")
		
	
	btn_arr = [ContinueBtn, TutorialBtn, ScenarioBtn, StoryBtn]
	
	for btn in btn_arr:
		btn.onFocus = func(node:Control) -> void:
			for index in MenuList.get_child_count():
				var btn_node:Control = MenuList.get_child(index)
				if btn_node == node:
					selected_index = index
	
	ContinueDetails.hide()
	ScenarioMarginContainer.set("theme_override_constants/margin_left", GBL.game_resolution.x/2 - 110)
	
	# show and setup btns
	on_freeze_inputs_update()
	on_current_mode_update()
# ------------------------------------------

# ------------------------------------------
func start(fast_boot:bool = false) -> void:
	disable_btns(false)	
	show()
	
	ContinueBtn.show() if has_quicksave else ContinueBtn.hide()
	selected_index = 0 if has_quicksave else 1	
	
	if has_quicksave:
		var scenario_details:Dictionary = SCENARIO_UTIL.get_scenario_data(quickload_data.filedata.data.scenario_ref)
		var modification_date:Dictionary = quickload_data.filedata.metadata.modification_date
		DetailName.text = "[DetailName]"
		DetailDay.text = "DAY %s" % [quickload_data.filedata.data.progress_data.day]
		DetailDate.text = "%s/%s/%s" % [modification_date.day, modification_date.month, modification_date.year]

	ScenarioBtn.title = "???" if disable_scenario else "SCENARIOS"
	StoryBtn.title = "???" if disable_story else "STORY"

	await U.set_timeout(0.3)
	BtnControls.reveal(true)
# ------------------------------------------

# ------------------------------------------
func end(action:String, props:Dictionary = {}) -> void:
	disable_btns(true)
	ScenarioPanel.hide()	
	ContinueDetails.hide()
	# add animation here
	await U.set_timeout(0.5)
	hide()
	wait_for_input.emit({"action": action, "props": props})
	current_mode = MODE.TITLE
# ------------------------------------------

# ------------------------------------------
func on_freeze_inputs_update() -> void:
	BtnControls.freeze_and_disable(freeze_inputs)
# ------------------------------------------

# ------------------------------------------
func disable_btns(state:bool) -> void:
	if !state:
		ContinueBtn.is_disabled = !has_quicksave
		TutorialBtn.is_disabled = false
		StoryBtn.is_disabled = disable_story
		ScenarioBtn.is_disabled = disable_scenario
	else:
		for btn in [StoryBtn, TutorialBtn, ScenarioBtn, ContinueBtn]:
			btn.is_disabled = true
# ------------------------------------------

# ------------------------------------------
func on_selected_index_update() -> void:
	if !is_node_ready():return
	await U.tick()
	for index in MenuList.get_child_count():
		var btn_node:Control = MenuList.get_child(index)
		btn_node.icon = SVGS.TYPE.NEXT if index == selected_index else SVGS.TYPE.NONE
		btn_node.is_active(index == selected_index)
		if index == selected_index:
			if btn_node == ContinueBtn:
				ContinueDetails.global_position = ContinueBtn.global_position + Vector2(ContinueBtn.size.x + 10, -ContinueBtn.size.y/4)
				ContinueDetails.show() 
			else:
				ContinueDetails.hide()
	
# ------------------------------------------	

# ------------------------------------------	
func on_scenario_index_update() -> void:
	if !is_node_ready():return
	var inital_val:int = GBL.game_resolution.x/2 - 110	
	var start_val:int = ScenarioMarginContainer.get("theme_override_constants/margin_left")
	var next_val:int = inital_val - (scenario_index * 220)
	for index in ScenarioList.get_child_count():	
		var distance_from_center:int = abs(scenario_index - index)
		var btn_node:Control = ScenarioList.get_child(index)
		btn_node.distance_from_center = distance_from_center
		#if scenario_index == index:
			#pass
			##NextBtn.is_disabled = btn_node.is_disabled

	freeze_inputs = true
	await U.tween_range(start_val, next_val, 0.3, func(val:float) -> void:
		ScenarioMarginContainer.set("theme_override_constants/margin_left", val)
	).finished 		
	freeze_inputs = false
# ------------------------------------------	


# ------------------------------------------
func build_tutorial_list() -> void:
	build_list( SCENARIO_UTIL.get_list_of_tutorials() )
		
func build_scenario_list() -> void:
	build_list( SCENARIO_UTIL.get_list_of_scenarios() )
		
func build_list(list:Array) -> void:
	slist = list
	for node in ScenarioList.get_children():
		node.queue_free()
	
	selected_index = 0
	
	for index in list.size():
		var scenario:Dictionary = list[index]
		var is_unlocked:bool = list.size() >= (scenario.ref - 1)
		var is_completed:bool = scenario.ref in list
		var new_btn:Control = ScenarioBtnPreload.instantiate()

		new_btn.is_completed = is_completed
		new_btn.is_disabled = !is_unlocked
		new_btn.scenario_ref = scenario.ref

			
		ScenarioList.add_child(new_btn)
# ------------------------------------------

# ------------------------------------------
var previous_btn_index_title:int = 0
func on_current_mode_update() -> void:
	if !is_node_ready():return
	await U.tick()
	match current_mode:
		MODE.TITLE:
			BtnControls.directional_pref = "UD"
			BtnControls.itemlist = btn_arr
		
			BtnControls.onBack = func() -> void:
				BtnControls.reveal(false)
				end('quit')
			
			BtnControls.onAction = func() -> void:pass
			
			BtnControls.onDirectional = func(_key:String) -> void:
				pass
				
			await U.tick()
			BtnControls.item_index = previous_btn_index_title
			
			await U.set_timeout(0.1)
			ScenarioPanel.hide()
			scenario_index = 0	
		# -----------------	
		MODE.SCENARIO:	
			ScenarioPanel.show()	

			previous_btn_index_title = BtnControls.item_index

			BtnControls.directional_pref = "LR"
			BtnControls.itemlist = ScenarioPanel.get_children()
			
			BtnControls.onBack = func() -> void:
				current_mode = MODE.TITLE
			
			BtnControls.onAction = func() -> void:
				var btn_node:Control = ScenarioList.get_child(scenario_index)
				if btn_node.is_disabled:return
				end("scenario", {"ref": slist[scenario_index].ref})

			
			BtnControls.onDirectional = func(key:String) -> void:
				match key:
					"A":
						scenario_index = U.min_max(scenario_index - 1, 0, ScenarioList.get_child_count() - 1)
					"D":
						scenario_index = U.min_max(scenario_index + 1, 0, ScenarioList.get_child_count() - 1)
			
			
			await U.tick()
			BtnControls.item_index = 0
			scenario_index = 0	
			
	
# ------------------------------------------
	
