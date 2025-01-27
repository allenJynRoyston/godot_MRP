@tool
extends GameContainer

enum STEP {BASE_SUMMARY, RESEARCHER_SUMMARY}

enum BASE_STEPS {FACILITY, FLOOR, WING}

@onready var BaseSummary:Control = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/BaseSummary
@onready var ResearcherSummary:Control = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/ResearcherSummary

@onready var NextBtn:Control = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextBtn

var current_step:STEP = STEP.BASE_SUMMARY : 
	set(val):
		current_step = val
		on_current_step_update()

var current_base_step:BASE_STEPS = BASE_STEPS.FACILITY : 
	set(val):
		current_base_step = val
		on_current_base_step_update()
		
var summary_data:Array = []

# -----------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	NextBtn.onClick = func() -> void:
		match current_step:
			STEP.BASE_SUMMARY:
				current_step = STEP.RESEARCHER_SUMMARY
			STEP.RESEARCHER_SUMMARY:
				user_response.emit()
			
	
	on_current_step_update()
	on_current_base_step_update()
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func start() -> void:
	print("start...")
# -----------------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------------
func on_current_step_update() -> void:
		match current_step:
			STEP.BASE_SUMMARY:
				BaseSummary.show()
				ResearcherSummary.hide()
			STEP.RESEARCHER_SUMMARY:
				BaseSummary.hide()
				ResearcherSummary.show()

func on_current_base_step_update() -> void:
	pass
# -----------------------------------------------------------------------------------------------
