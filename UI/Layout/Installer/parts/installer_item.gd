extends PanelContainer

@onready var ProgressLabel:Label = $MarginContainer2/VBoxContainer/HBoxContainer/ProgressLabel
@onready var ProgressBarUI:ProgressBar = $MarginContainer2/VBoxContainer/HBoxContainer/ProgressBar
@onready var FilenameLabel:Label = $MarginContainer2/VBoxContainer/Filename

@export var filename:String = "filename.exe"
@export var duration:int = 10
@export var percentage_complete:float = 0.0 :
	set(val):
		percentage_complete = val
		on_percentage_complete_update()

var time_elapsed:float = 0
var has_completed:bool = false

signal is_complete

func _ready() -> void:
	FilenameLabel.text = "Installing %s..." % [filename]

# ------------------------------------------------
func on_percentage_complete_update() -> void:
	ProgressLabel.text = str(round(percentage_complete * 100)) + "%"
	ProgressBarUI.value = percentage_complete 
# ------------------------------------------------

# ------------------------------------------------
func _process(delta: float) -> void:
	time_elapsed += delta 
	if percentage_complete < 1.0:
		percentage_complete = time_elapsed / (duration * 1.0)
	else:
		if !has_completed:
			percentage_complete = 1.0
			has_completed = true			
			await U.set_timeout(1.0)
			is_complete.emit()
			print("is complete...")
			self.queue_free()
# ------------------------------------------------
