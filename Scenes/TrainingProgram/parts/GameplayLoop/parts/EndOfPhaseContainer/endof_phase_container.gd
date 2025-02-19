extends GameContainer

enum STEP {BASE_SUMMARY, RESEARCHER_SUMMARY}


@onready var BaseSummary:Control = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/BaseSummary
@onready var ResearcherSummary:Control = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/ResearcherSummary

@onready var FacilityBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/FacilityBtn
@onready var ResearcherBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/ResearcherBtn

@onready var NextBtn:Control = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextBtn

var current_step:STEP = STEP.BASE_SUMMARY : 
	set(val):
		current_step = val
		on_current_step_update()

# -----------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	FacilityBtn.onClick = func() -> void:
		current_step = STEP.BASE_SUMMARY
	
	ResearcherBtn.onClick = func() -> void:
		current_step = STEP.RESEARCHER_SUMMARY
	
	NextBtn.onClick = func() -> void:
		match current_step:
			STEP.BASE_SUMMARY:
				current_step = STEP.RESEARCHER_SUMMARY
			STEP.RESEARCHER_SUMMARY:
				user_response.emit()
			
	
	on_current_step_update()
	reset()
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func reset() -> void:
	current_step = STEP.BASE_SUMMARY
	BaseSummary.reset()
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func start() -> void:
	BaseSummary.start()
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func on_is_showing_update() -> void:
	super.on_is_showing_update()
	if !is_showing:
		await U.set_timeout(0.5)
		reset()
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func on_current_step_update() -> void:
		match current_step:
			STEP.BASE_SUMMARY:
				BaseSummary.show()
				ResearcherSummary.hide()
				NextBtn.title = "CONTINUE"
			STEP.RESEARCHER_SUMMARY:
				BaseSummary.hide()
				ResearcherSummary.show()
				NextBtn.title = "CLOSE REPORT"
# -----------------------------------------------------------------------------------------------
