extends PanelContainer


@onready var TabContainerHBox:HBoxContainer = $MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/Header2/MarginContainer/TabContainer
@onready var ContentScrollContainer:ScrollContainer = $MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/Content/ScrollContainer
@onready var ContainmentProcedures:Control = $MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/Content/ScrollContainer/MarginContainer/VBoxContainer/ContainmentProcedures
@onready var Description:Control = $MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/Content/ScrollContainer/MarginContainer/VBoxContainer/Description

@onready var BtnControls:Control = $BtnControls
@onready var sections:Array = [ContainmentProcedures, Description]

enum TAB { CONTAINMENT_PROCEDURE, DESCRIPTION }

var current_tab:TAB 

var onBack:Callable = func():pass



func _ready() -> void:
	reset_content()
	
		
	BtnControls.itemlist = TabContainerHBox.get_children()
	BtnControls.item_index = 0
	
	BtnControls.directional_pref = "LR"

	BtnControls.onDirectional = func(key:String):
		BtnControls.freeze_and_disable(true)
		match key:
			"W":
				await U.tween_node_property(ContentScrollContainer, "scroll_vertical", ContentScrollContainer.scroll_vertical - 300, 0.2, 0, Tween.TRANS_QUART)
			"S":
				await U.tween_node_property(ContentScrollContainer, "scroll_vertical", ContentScrollContainer.scroll_vertical + 300, 0.2, 0, Tween.TRANS_QUART)
		BtnControls.freeze_and_disable(false)
		
	BtnControls.onUpdate = func(node:Control) -> void:
		on_update(node)
				
		
	BtnControls.onBack = func():
		await BtnControls.reveal(false)
		onBack.call()	

func reset_content() -> void:
	for n in sections:
		n.hide()


func on_update(node:Control) -> void:
	reset_content()
	
	for n in TabContainerHBox.get_children():
		n.is_selected = node == n
		if node == n:
			current_tab = n.index
		
	ContentScrollContainer.scroll_vertical = 0
	match current_tab:
		TAB.CONTAINMENT_PROCEDURE:
			ContainmentProcedures.show()
		TAB.DESCRIPTION:
			Description.show()

				
func switch_to() -> void:		
	BtnControls.reveal(true)
# -----------------------------------
