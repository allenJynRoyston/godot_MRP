extends PanelContainer

@onready var ProgressLabel:Label = $MarginContainer2/VBoxContainer/HBoxContainer/ProgressLabel
@onready var ProgressBarUI:ProgressBar = $MarginContainer2/VBoxContainer/HBoxContainer/ProgressBar
@onready var FilenameLabel:Label = $MarginContainer2/VBoxContainer/Filename

@export var percentage_complete:float = 0.0 :
	set(val):
		percentage_complete = val
		on_percentage_complete_update()

var time_elapsed:float = 0
var has_completed:bool = false
var start:bool = false
var ref:int
var filename:String = "filename.exe"
var duration:int = 10 : 
	set(val):
		duration = val
		start = true

func _ready() -> void:
	FilenameLabel.text = "Installing %s..." % [filename]
	
	
# ------------------------------------------------
func on_percentage_complete_update() -> void:
	ProgressLabel.text = str(round(percentage_complete * 100)) + "%"
	ProgressBarUI.value = percentage_complete 
# ------------------------------------------------

# ------------------------------------------------
func on_complete() -> void:
	var layout_node:Control = GBL.find_node(REFS.OS_LAYOUT)
	percentage_complete = 1.0
	await U.set_timeout(1.0)
	layout_node.install_app_complete(ref)
	self.queue_free()	
# ------------------------------------------------


# ------------------------------------------------
func _process(delta: float) -> void:
	if start:
		time_elapsed += delta 
		if percentage_complete < 1.0:
			percentage_complete = time_elapsed / (duration * 1.0)
		else:
			if !has_completed:
				has_completed = true
				on_complete()
# ------------------------------------------------
