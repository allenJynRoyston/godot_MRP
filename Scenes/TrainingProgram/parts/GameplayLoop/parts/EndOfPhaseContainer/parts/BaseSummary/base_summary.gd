extends PanelContainer

enum BASE_STEPS {FLOOR, WING, ROOMS}

@onready var TotalsLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer2/TotalsLabel
@onready var MoneyDiffLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/PanelContainer/MoneyDiffLabel
@onready var EnergyDiffLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/PanelContainer2/EnergyDiffLabel

@onready var BaseItemListContainer:VBoxContainer = $MarginContainer/VBoxContainer/BaseItemListContainer
@onready var BackBtn:BtnBase = $MarginContainer/VBoxContainer/HBoxContainer/BackBtn

const BaseItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/EndOfPhaseContainer/parts/BaseItem.tscn")

var steps:BASE_STEPS = BASE_STEPS.FLOOR : 
	set(val):
		steps = val
		on_steps_update()

var progress_data:Dictionary = {}

var room_config:Dictionary = {}

var can_go_back:bool = false

var is_setup:bool = false

var use_location:Dictionary = {
		"floor": -1,
		"wing": -1,
		"room": -1
	} : 
		set(val):
			use_location = val

var resources_data:Dictionary = {}

# -----------------------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_progress_data(self)
	SUBSCRIBE.subscribe_to_room_config(self)	
	SUBSCRIBE.subscribe_to_resources_data(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_progress_data(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)	
	SUBSCRIBE.unsubscribe_to_resources_data(self)

func _ready() -> void:
	reset()
	
func start() -> void:
	steps = BASE_STEPS.FLOOR	
	
func reset() -> void:
	use_location.floor = 0
	use_location = use_location
		
	for child in BaseItemListContainer.get_children():
		child.queue_free()
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	if !is_node_ready():return
	room_config = new_val
	on_steps_update()

func on_progress_data_update(new_val:Dictionary = progress_data) -> void:
	if !is_node_ready():return
	progress_data = new_val
	on_steps_update()

func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func get_floor_metrics(floor:int) -> Dictionary:
	var money_amount:int = 0
	var energy_amount:int = 0
	var science_amount:int = 0
	var source:int 
	
	for record in progress_data.record:
		if "location" in record.data:
			if record.data.location.floor == floor:
				source = record.source
				if "diff" in record.data:
					for diff in record.data.diff:
						match diff.resource_ref:
							RESOURCE.CURRENCY.MONEY:
								money_amount += diff.amount
							RESOURCE.TYPE.ENERGY:
								energy_amount += diff.amount
							RESOURCE.CURRENCY.SCIENCE:
								science_amount += diff.amount
					
	return {
		"source": source,
		"money_amount": money_amount,
		"energy_amount": energy_amount,
		"science_amount": science_amount
	}
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func get_wing_metrics(floor:int, wing:int) -> Dictionary: 
	var money_amount:int = 0
	var energy_amount:int = 0
	var source:String = "" 
	
	for record in progress_data.record:
		if record.location.floor == floor and record.location.ring == wing:
			source = record.source
			for cost in record.costs:
				if cost.resource_ref == RESOURCE.CURRENCY.MONEY:
					money_amount += cost.amount
				if cost.resource_ref == RESOURCE.TYPE.ENERGY:
					energy_amount += cost.amount
					
	return {
		"source": source,
		"money_amount": money_amount,
		"energy_amount": energy_amount
	}
# -----------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------
func get_room_metrics(floor:int, wing:int, room:int) -> Dictionary: 
	var money_amount:int = 0
	var energy_amount:int = 0
	var source:String = "" 
	for record in progress_data.record:
		if record.location.floor == floor and record.location.ring == wing and record.location.room == room:
			source = record.source
			for cost in record.costs:
				if cost.resource_ref == RESOURCE.CURRENCY.MONEY:
					money_amount += cost.amount
				if cost.resource_ref == RESOURCE.TYPE.ENERGY:
					energy_amount += cost.amount
					
	return {
		"source": source,
		"money_amount": money_amount,
		"energy_amount": energy_amount
	}
# -----------------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------------
func on_steps_update() -> void:
	if progress_data.is_empty() or room_config.is_empty() or resources_data.is_empty():return
	for child in BaseItemListContainer.get_children():
		child.queue_free()
	
	match steps:
		#-----------------
		BASE_STEPS.FLOOR:
			BackBtn.hide()
			
			var money_total:int = 0
			var energy_total:int = 0			
			
			for index in [0, 1, 2, 3, 4, 5, 6]:
				var res:Dictionary = get_floor_metrics(index) 
				var new_node:Control = BaseItemPreload.instantiate()
				new_node.btn_title = "FLOOR %s" % [index + 1]
				new_node.index = index
				new_node.money_amount = res.money_amount
				new_node.energy_amount = res.energy_amount
				
				money_total += res.money_amount
				energy_total += res.energy_amount
				
				new_node.onClick = func(index:int) -> void:
					use_location.floor = index
					use_location = use_location
					steps = BASE_STEPS.WING
				
				#new_node.designation = "%s" % [floor_index]
				BaseItemListContainer.add_child(new_node)
				
			if RESOURCE.CURRENCY.MONEY in resources_data and RESOURCE.TYPE.ENERGY in resources_data:
				MoneyDiffLabel.text = "%s -> %s" % [resources_data[RESOURCE.CURRENCY.MONEY].amount - money_total, resources_data[RESOURCE.CURRENCY.MONEY].amount ]
				EnergyDiffLabel.text = "%s -> %s" % [resources_data[RESOURCE.TYPE.ENERGY].amount - energy_total, resources_data[RESOURCE.TYPE.ENERGY].amount]	
			TotalsLabel.text = "NEW BALANCE"
		#-----------------
		BASE_STEPS.WING:
			BackBtn.show()
			BackBtn.onClick = func() -> void:
				steps = BASE_STEPS.FLOOR
				
			var money_total:int = 0
			var energy_total:int = 0	
			
			for index in [0, 1, 2, 3]:
				var res:Dictionary = get_wing_metrics(use_location.floor, index) 
				var new_node:Control = BaseItemPreload.instantiate()
				new_node.btn_title = "WING %s" % [index + 1]
				new_node.index = index
				new_node.money_amount = res.money_amount
				new_node.energy_amount = res.energy_amount	
				
				money_total += res.money_amount
				energy_total += res.energy_amount
				
				new_node.onClick = func(index:int) -> void:
					use_location.wing = index
					use_location = use_location
					steps = BASE_STEPS.ROOMS
					
				#new_node.designation = "%s%s" % [floor_index, ring_index]
				BaseItemListContainer.add_child(new_node)
			
			MoneyDiffLabel.text = "%s" % [money_total]
			EnergyDiffLabel.text = "%s" % [energy_total]	
			TotalsLabel.text = "TOTALS"
		#-----------------
		BASE_STEPS.ROOMS:
			BackBtn.show()
			BackBtn.onClick = func() -> void:
				steps = BASE_STEPS.WING	
				
			var money_total:int = 0
			var energy_total:int = 0
			
			for index in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
				var res:Dictionary = get_room_metrics(use_location.floor, use_location.wing, index) 
				var room_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.wing].room[index].room_data
				var new_node:Control = BaseItemPreload.instantiate()

				if !room_data.is_empty():
					var room_details:Dictionary = room_data.get_room_details.call()
					new_node.btn_title = "%s  (ROOM %s)" % [res.source, index + 1]
					new_node.index = index
					new_node.money_amount = res.money_amount
					new_node.energy_amount = res.energy_amount
					
					money_total += res.money_amount
					energy_total += res.energy_amount	
					
					new_node.onClick = func(index:int) -> void:
						use_location.room = index
						use_location = use_location
					#new_node.designation = "%s%s" % [floor_index, ring_index]
					BaseItemListContainer.add_child(new_node)
		
			MoneyDiffLabel.text = "%s" % [money_total]
			EnergyDiffLabel.text = "%s" % [energy_total]	
			TotalsLabel.text = "TOTALS"
# -----------------------------------------------------------------------------------------------
