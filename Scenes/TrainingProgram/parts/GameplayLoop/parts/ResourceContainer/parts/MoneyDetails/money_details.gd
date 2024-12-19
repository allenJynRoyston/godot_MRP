extends PanelContainer

@onready var ExpenseList:VBoxContainer = $VBoxContainer/HBoxContainer/ExpenseContainer/ExpenseList
@onready var IncomeList:VBoxContainer = $VBoxContainer/HBoxContainer/IncomeContainer/IncomeList

@onready var TotalIncomeLabel:Label = $VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/TotalIncome
@onready var TotalExpenseLabel:Label = $VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer2/TotalExpense
@onready var TotalDiffLabel:Label = $VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer3/TotalDiff

const DetailBtnPreload:PackedScene = preload("res://UI/Buttons/DetailBtn/DetailBtn.tscn")

var gameplay_node:Control

var facility_room_data:Array = [] : 
	set(val):
		facility_room_data = val
		on_facility_room_data_update()		

func _ready() -> void:
	on_facility_room_data_update()
	gameplay_node = GBL.find_node(REFS.GAMEPLAY_LOOP)

func on_facility_room_data_update() -> void:
	if !is_node_ready():return
	
	for node in [ExpenseList, IncomeList]:
		for child in node.get_children():
			child.queue_free()
	
	var total_income:int = 0
	var total_expense:int = 0

	for item in facility_room_data:
		var operating_cost_list:Array = ROOM_UTIL.return_operating_cost(item.data.id)
		var operation_income_list:Array = ROOM_UTIL.return_operating_income(item.data.id)
		var details:Dictionary = ROOM_UTIL.return_data(item.data.id)

		for i in operation_income_list:			
			if i.resource.id == RESOURCE.TYPE.MONEY:
				var new_node:BtnBase = DetailBtnPreload.instantiate()
				new_node.title = details.name
				new_node.icon = i.resource.icon
				new_node.amount = "+%s amount" % [i.amount]
				total_income += i.amount
				
				new_node.onClick = func() -> void:
					GBL.find_node(REFS.GAMEPLAY_LOOP).camera_layer_focus = CAMERA.LAYER.RM
					gameplay_node.goto_location(item.location)
				
				IncomeList.add_child(new_node)			

		for i in operating_cost_list:			
			if i.resource.id == RESOURCE.TYPE.MONEY:
				var new_node:BtnBase = DetailBtnPreload.instantiate()		
				new_node.title = details.name
				new_node.icon = i.resource.icon
				new_node.amount = "-%s amount" % [i.amount]
				total_expense += i.amount
				
				new_node.onClick = func() -> void:
					GBL.find_node(REFS.GAMEPLAY_LOOP).camera_layer_focus = CAMERA.LAYER.RM
					gameplay_node.goto_location(item.location)
				
				ExpenseList.add_child(new_node)	
				
	var diff:int = total_income - total_expense
	TotalIncomeLabel.text = str(total_income)
	TotalExpenseLabel.text = str(total_expense)
		
	TotalDiffLabel.text = str("+%s" if diff >= 0 else "%s") % [diff]
