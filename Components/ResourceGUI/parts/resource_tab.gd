extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var Title:Label = $MarginContainer/hbox/title
@onready var Details:Label = $MarginContainer/hbox/details

var data:Dictionary = {} : 
	set(val):		
		data = val
		on_data_update()
		
var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()		


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_data_update()
	on_is_active_update()

func on_data_update() -> void:
	if data.is_empty() or !is_node_ready():return
	Title.text = data.title
	
	var show_capacity:bool = data.show_capacity if "show_capacity" in data else true
	var show_utilized:bool = data.show_utilized if "show_utilized" in data else true

	if "details" in data and !data.details.is_empty():
		if "total" in data.details:
			Details.text = "%s" % [data.details.total]
		#if "utilized" in data.details  and show_utilized:
			#Details.text = "%s/%s" % [Details.text, data.details.utilized]				
		if "capacity" in data.details and show_capacity:
			Details.text = "%s/%s" % [Details.text, data.details.capacity]
		if "net" in data.details:
			Details.text = "%s [%s]" % [Details.text, data.details.net]



func on_is_active_update() -> void:
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = "ec6781" if is_active else "3a3a3a"
	if RootPanel != null:
		RootPanel.add_theme_stylebox_override("panel", new_stylebox)
