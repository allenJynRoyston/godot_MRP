@tool
extends GameContainer

@onready var ShowHideLabel:Label = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/HBoxContainer/ShowHideLabel
@onready var ShowHideCB:BtnBase = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/HBoxContainer/ShowHideCB
@onready var ContainerVBox:VBoxContainer = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ContainerVBox

@onready var MoraleCB:BtnBase = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ContainerVBox/CheckboxVBox/VBoxContainer/MoraleCB
@onready var SecurityCB:BtnBase = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ContainerVBox/CheckboxVBox/VBoxContainer/SecurityCB
@onready var ReadinessCB:BtnBase = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ContainerVBox/CheckboxVBox/VBoxContainer/ReadinessCB
@onready var HumeCB:BtnBase = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ContainerVBox/CheckboxVBox/VBoxContainer/HumeCB

@onready var MoraleReading:PanelContainer = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ContainerVBox/InfoVBox/VBoxContainer/MoraleReading
@onready var SecurityReading:PanelContainer = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ContainerVBox/InfoVBox/VBoxContainer/SecurityReading
@onready var ReadinessReading:PanelContainer = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ContainerVBox/InfoVBox/VBoxContainer/ReadinessReading
@onready var HumeReading:PanelContainer = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ContainerVBox/InfoVBox/VBoxContainer/HumeReading

@onready var InfoVBox:VBoxContainer = $PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ContainerVBox/InfoVBox

var checkbox:Dictionary = {
	"morale": false,
	"security": false,
	"readiness": false,
	"hume": false,
} : 
	set(val):
		checkbox = val
		on_checkbox_update()
		
var show_info:bool = true :
	set(val):
		show_info = val
		on_show_info_update()

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	
func _exit_tree() -> void:
	super._exit_tree()

func _ready() -> void:
	super._ready()
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	MoraleCB.onChange = func(is_checked:bool) -> void:
		checkbox.morale = is_checked
		checkbox = checkbox

	SecurityCB.onChange = func(is_checked:bool) -> void:
		checkbox.security = is_checked
		checkbox = checkbox
		
	ReadinessCB.onChange = func(is_checked:bool) -> void:
		checkbox.readiness = is_checked
		checkbox = checkbox
		
	HumeCB.onChange = func(is_checked:bool) -> void:
		checkbox.hume = is_checked
		checkbox = checkbox
	
	ShowHideCB.onChange = func(is_checked:bool) -> void:
		show_info = is_checked
	ShowHideCB.is_checked = show_info
	
	on_checkbox_update()
	on_show_info_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	if !is_node_ready():return

	#update_readings(room_config.floor[current_location.floor].readings)
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------		
func on_checkbox_update() -> void:
	if !is_node_ready():return
	
	MoraleReading.show() if checkbox.morale else MoraleReading.hide()
	SecurityReading.show() if checkbox.security else SecurityReading.hide()
	ReadinessReading.show() if checkbox.readiness else ReadinessReading.hide()
	HumeReading.show() if checkbox.hume else HumeReading.hide()
	
	var show_box:bool = false
	for key in checkbox:
		if checkbox[key]:
			show_box = true
			break
	
	InfoVBox.show() if show_box else InfoVBox.hide()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func on_show_info_update() -> void:
	if !is_node_ready():return
	ShowHideLabel.text = "%s INFO" % ["SHOW" if !show_info else "HIDE"]
	ContainerVBox.show() if show_info else ContainerVBox.hide()
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------
func reading_to_string(val:int, zero_val:String = "DANGEROUS", low_val:String = "LOW", mid_val:String = "NORMAL", high_val:String = "HIGH") -> String:
	if val == 0:
		return zero_val
	elif val > 0 and val <= 3:
		return 	low_val
	elif val > 3 and val <= 7:
		return mid_val
	elif val > 7:
		return high_val
	return "UNKNOWN"
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------			
func update_readings(readings:Dictionary) -> void:
	MoraleReading.status = reading_to_string(readings[RESOURCE.BASE.MORALE])
	SecurityReading.status = reading_to_string(readings[RESOURCE.BASE.SAFETY])
	ReadinessReading.status = reading_to_string(readings[RESOURCE.BASE.READINESS])
	HumeReading.status = "%.1f - %s" % [
		(readings[RESOURCE.BASE.HUME] / 5.0) * 1.0, 
		reading_to_string(readings[RESOURCE.BASE.HUME], "UNKNOWN", "UNRAVELING", "NORMAL", "UNSTABLE")
	]
# --------------------------------------------------------------------------------------------------			
