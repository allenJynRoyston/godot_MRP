extends ControlPanel

@onready var MoneyCurrent = $MarginContainer/HBoxContainer/money/current
@onready var MoneyChangeRate = $MarginContainer/HBoxContainer/money/change_rate

@onready var EnergyCurrent = $MarginContainer/HBoxContainer/energy/current
@onready var EnergyChangeRate = $MarginContainer/HBoxContainer/energy/change_rate

@onready var StaffTotal = $MarginContainer/HBoxContainer/staff/total
@onready var StaffCapacity = $MarginContainer/HBoxContainer/staff/capacity
@onready var StaffAssigned = $MarginContainer/HBoxContainer/staff/assigned

@onready var DClassTotal = $MarginContainer/HBoxContainer/dclass/total
@onready var DClassCapacity = $MarginContainer/HBoxContainer/dclass/capacity
@onready var DClassAssigned = $MarginContainer/HBoxContainer/dclass/assigned


var player_resources:Dictionary = {} : 
	set(val):
		player_resources = val
		if val.is_empty():return
		money = val.money
		energy = val.energy
		staff = val.staff
		dclass = val.dclass
		

var money:Dictionary = {
	"balance": 0,
	"change_rate": 0
} : 
	set(val):
		money = val
		on_money_update()
		
var energy:Dictionary = {
	"balance": 0,
	"change_rate": 0
} : 
	set(val):
		energy = val
		on_energy_update()
		
var staff:Dictionary = {
	"total": 0,
	"capacity": 0,
	"assigned": 0,
} : 
	set(val):
		staff = val
		on_staff_update()		

var dclass:Dictionary = {
	"total": 0,
	"capacity": 0,
	"assigned": 0,
} : 
	set(val):
		dclass = val
		on_dclass_update()		
		


# -----------------------------------	
func _ready() -> void:
	RootPanel = $"."
	super._ready()
	
	on_money_update()
# -----------------------------------		

# -----------------------------------	
func on_money_update() -> void:
	MoneyCurrent.text = str(money.balance)
	MoneyChangeRate.text = str(money.change_rate)
# -----------------------------------		

# -----------------------------------	
func on_energy_update() -> void:
	EnergyCurrent.text = str(energy.balance)
	EnergyChangeRate.text = str(energy.change_rate)
# -----------------------------------		

# -----------------------------------		
func on_staff_update() -> void:
	StaffTotal.text = str(staff.total)	
	StaffAssigned.text = str(staff.assigned)
	StaffCapacity.text = str(staff.capacity)
# -----------------------------------		

# -----------------------------------		
func on_dclass_update() -> void:
	DClassTotal.text = str(dclass.total)	
	DClassAssigned.text = str(dclass.assigned)
	DClassCapacity.text = str(dclass.capacity)
# -----------------------------------		



# -----------------------------------	
func tally_resources(resources:Dictionary, diff:Dictionary) -> void:
	if "cost" in resources:
		if "money" in resources.cost:
			diff.money.change_rate -= resources.cost.money
	
	if "gain" in resources:
		if "energy" in resources.gain:
			diff.energy.change_rate += resources.gain.energy
	
	if "capacity" in resources:
		if "dclass" in resources.capacity:
			diff.dclass.capacity += resources.capacity.dclass
		if "staff" in resources.capacity:
			diff.staff.capacity += resources.capacity.staff		
# -----------------------------------	

# -----------------------------------	
func tally_build_costs(build_costs:Dictionary, diff:Dictionary) -> void:
	if "money" in build_costs:
		diff.money.balance = money.balance - build_costs.money
# -----------------------------------		

# -----------------------------------	
func on_data_update(_previous_state:Dictionary) -> void:
	var diff:Dictionary = {
		"money": {
			"balance": money.balance,
			"change_rate": 0
		},
		"energy": {
			"balance": energy.balance,
			"change_rate": 0
		},
		"dclass": {
			"total": 0,
			"capacity": 0,
			"assigned": 0
		},
		"staff": {
			"total": 0,
			"capacity": 0,
			"assigned": 0
		}
	}
	
	for key in data.built:
		for type in data.built[key]:
			var resources:Dictionary = Buildables.return_resources(type)
			var build_costs:Dictionary = Buildables.return_build_cost(type)
			
			tally_resources(resources, diff)
			tally_build_costs(build_costs, diff)
	

	money = diff.money
	dclass = diff.dclass
	staff = diff.staff
	energy = diff.energy
# -----------------------------------	
	
	
