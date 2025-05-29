extends PanelContainer

@onready var SetupProgressBar:ProgressBar = $PanelContainer/MarginContainer/VBoxContainer/ProgressBar
@onready var TitleLabel:Label = $PanelContainer/MarginContainer/VBoxContainer/Label
@onready var SubtitleLabel:Label = $PanelContainer/MarginContainer/VBoxContainer/Label2

var title:String = "" : 
	set(val):
		title = val
		on_title_update()

var subtitle:String = "" : 
	set(val):
		subtitle = val
		on_subtitle_update()

var progressbar_val:float = 0.0 : 
	set(val):
		progressbar_val = val
		on_progressbar_val_update()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate = Color(1, 1, 1, 0)
	on_progressbar_val_update()
	on_title_update()
	on_subtitle_update()

func start() -> void:
	self.modulate = Color(1, 1, 1, 1)

func end() -> void:
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.5)
	self.queue_free()	

func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title
	
func on_subtitle_update() -> void:
	if !is_node_ready():return
	SubtitleLabel.text = subtitle

func on_progressbar_val_update() -> void:
	if !is_node_ready():return
	if SetupProgressBar.value != progressbar_val:
		U.tween_node_property(SetupProgressBar, "value", progressbar_val, 0.3)
