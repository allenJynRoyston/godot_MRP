@tool
extends GameContainer

@onready var FloorLabel:Label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/FloorLabel
@onready var WingLabel:Label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WingLabel
@onready var IsPowered:BtnBase = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/IsPowered
@onready var IsLockDown:BtnBase = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/IsLockDown

@onready var WingBtns:HBoxContainer = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/WingBtns
@onready var WingA:BtnBase = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/WingBtns/ColorRect/WingA
@onready var WingB:BtnBase = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/WingBtns/ColorRect2/WingB
@onready var WingC:BtnBase = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/WingBtns/ColorRect3/WingC
@onready var WingD:BtnBase = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/WingBtns/ColorRect4/WingD

		
var onRoomSelected:Callable = func(_data:Dictionary) -> void:pass

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	WingA.onClick = func() -> void:
		current_location.ring = 0
		SUBSCRIBE.current_location = current_location

	WingB.onClick = func() -> void:
		current_location.ring = 1
		SUBSCRIBE.current_location = current_location
		
	WingC.onClick = func() -> void:
		current_location.ring = 2
		SUBSCRIBE.current_location = current_location
		
	WingD.onClick = func() -> void:
		current_location.ring = 3
		SUBSCRIBE.current_location = current_location						
# -----------------------------------------------

# -----------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return
	update_labels()
	check_for_lockdown()
# -----------------------------------------------

# -----------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	update_labels()
	check_for_lockdown()
# -----------------------------------------------

# -----------------------------------------------
func update_labels() -> void:
	if current_location.is_empty() or room_config.is_empty():return
	var is_powered:bool = room_config.floor[current_location.floor].is_powered
	IsPowered.icon = SVGS.TYPE.NONE if is_powered else SVGS.TYPE.NO_ELECTRICITY
	IsPowered.hide() if is_powered else IsPowered.show()
	FloorLabel.text = "FLOOR %s" % [current_location.floor]
	WingLabel.text = "WING %s" % [current_location.ring]
	
	var node_arr:Array = [WingA, WingB, WingC, WingD]
	for index in node_arr.size():
		var node:Control = node_arr[index]
		node.icon = SVGS.TYPE.TARGET if current_location.ring == index else SVGS.TYPE.NONE	
# -----------------------------------------------

# -----------------------------------------------
func check_for_lockdown() -> void:
	if current_location.is_empty() or room_config.is_empty():return	
	var in_lockdown:bool = room_config.floor[current_location.floor].in_lockdown
	IsLockDown.icon = SVGS.TYPE.LOCK if in_lockdown else SVGS.TYPE.NONE
	IsLockDown.show() if in_lockdown else IsLockDown.hide()

# -----------------------------------------------
