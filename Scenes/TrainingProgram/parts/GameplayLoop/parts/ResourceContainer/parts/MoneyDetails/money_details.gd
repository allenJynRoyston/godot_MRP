extends PanelContainer

@onready var ExpenseList:VBoxContainer = $VBoxContainer/HBoxContainer/ExpenseContainer/ExpenseList
@onready var IncomeList:VBoxContainer = $VBoxContainer/HBoxContainer/IncomeContainer/IncomeList

@onready var TotalIncomeLabel:Label = $VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/TotalIncome
@onready var TotalExpenseLabel:Label = $VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer2/TotalExpense
@onready var TotalDiffLabel:Label = $VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer3/TotalDiff

const DetailBtnPreload:PackedScene = preload("res://UI/Buttons/DetailBtn/DetailBtn.tscn")

var gameplay_node:Control

var purchased_facility_arr:Array = [] 

func _init() -> void:
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
	
func _ready() -> void:
	gameplay_node = GBL.find_node(REFS.GAMEPLAY_LOOP)

func on_purchased_facility_arr_update(new_val:Array = purchased_facility_arr) -> void:
	purchased_facility_arr = new_val
	if !is_node_ready():return
	
	for node in [ExpenseList, IncomeList]:
		for child in node.get_children():
			child.queue_free()
	
	var total_income:int = 0
	var total_expense:int = 0

	for item in purchased_facility_arr:
		var operating_cost_list:Array = ROOM_UTIL.return_operating_cost(item.ref)
		var details:Dictionary = ROOM_UTIL.return_data(item.ref)
		for i in operating_cost_list:
			if i.resource.ref == RESOURCE.TYPE.MONEY and i.type == "amount":
				var new_node:BtnBase = DetailBtnPreload.instantiate()
				var amount:int = i.amount
				new_node.title = details.name
				new_node.icon = i.resource.icon
				new_node.amount = "%s%s" % ["+" if amount >= 0 else "-", amount]

				new_node.onClick = func() -> void:
					SUBSCRIBE.current_location = item.location.duplicate()
					
				if amount >= 0:
					total_income += amount
					IncomeList.add_child(new_node)
				if amount < 0:
					total_expense += amount
					ExpenseList.add_child(new_node)	
				
	var diff:int = total_income + total_expense
	TotalIncomeLabel.text = str(total_income)
	TotalExpenseLabel.text = str(total_expense)
		
	TotalDiffLabel.text = str("+%s" if diff >= 0 else "%s") % [diff]
