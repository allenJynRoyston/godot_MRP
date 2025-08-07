extends PanelContainer

@onready var BtnControls:Control = $BtnControl
@onready var ListLabel:Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/ListLabel
@onready var List:VBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/List
@onready var WaitContainer:Control = $WaitContainer
@onready var StoreContentContainer:Control = $HBoxContainer/StoreContentContainer
@onready var CostPanel:PanelContainer = $HBoxContainer/StoreContentContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/CostPanel

@onready var Economy:Control = $HBoxContainer/StoreContentContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/EconomyTally
@onready var Income:Control = $HBoxContainer/StoreContentContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/IncomeTally
@onready var Personnel:Control = $HBoxContainer/StoreContentContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer3/HBoxContainer2/PersonnelTally
@onready var PersonnelMax:Control = $HBoxContainer/StoreContentContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer3/HBoxContainer2/PersonnelMaxTally

@onready var HeaderEconomy:Control = $HBoxContainer/StoreContentContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HeaderEconomy
@onready var HeaderVibes:Control = $HBoxContainer/StoreContentContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HeaderVibes
@onready var HeaderPersonnel:Control = $HBoxContainer/StoreContentContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer3/HeaderPersonnel

const SummaryBtnPreload:PackedScene = preload("res://UI/Buttons/SummaryBtn/SummaryBtn.tscn")

var store_data:Array = OS_STORE.data
var store_list:Array = []

var tab_index:int = 0 : 
	set(val):
		tab_index = val
		on_store_data_update()
		
var purchased:Array = [] : 
	set(val):
		purchased = val
		on_purchased_update()


var onMakePurchase:Callable = func(_uid:String):pass
var onBackToDesktop:Callable = func():pass
var SelectedNode:Control

# ------------------------------------------------------------------------------
func _ready() -> void:
	clear()
	
	BtnControls.directional_pref = "UD"
	
	BtnControls.onDirectional = on_key_press
		
	BtnControls.onBack = func() -> void:
		onBackToDesktop.call()
	
	BtnControls.onUpdate = func(node:Control) -> void:
		StoreContentContainer.show()
		WaitContainer.hide()
		for index in List.get_child_count():
			var n:Control = List.get_child(index)
			n.is_selected = node == n
			if node == n:
				SelectedNode = node
				BtnControls.hide_a_btn = store_data[tab_index].list.is_empty()
	
	BtnControls.onAction = func() -> void:
		if SelectedNode == null:return
		var os_settings:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_settings		
		var index:int = SelectedNode.index
		var item:Dictionary = store_data[tab_index].list[index]
		var is_unlocked:bool = item.is_unlocked.call(os_settings)
		
		onMakePurchase.call(str(tab_index, index), item.cost)
				
func start() -> void:
	BtnControls.reveal(true)
	on_store_data_update()

func pause() -> void:
	await BtnControls.reveal(false)
	
func unpause() -> void:
	await BtnControls.reveal(true)
	
func clear() -> void:
	for child in List.get_children():
		child.queue_free()
# ------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_key_press(key:String) -> void:
	if !is_visible_in_tree() or !is_node_ready(): 
		return
	
	match key:
		"A":
			tab_index = U.min_max(tab_index - 1, 0, store_data.size() - 1, true )
		"D":
			tab_index = U.min_max(tab_index + 1, 0, store_data.size() - 1, true )
# --------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_store_data_update() -> void:
	if !is_node_ready():return

	for node in List.get_children(): 
		node.queue_free()
	
	store_list = []
	for index in store_data[tab_index].list.size():
		var item:Dictionary = store_data[tab_index].list[index]
		var new_btn:Control = SummaryBtnPreload.instantiate()
		var uid:String = str(tab_index, index)
		
		new_btn.index = index
		new_btn.title = item.details.name
		new_btn.show_checked_panel = true		
		new_btn.show_cost = true
		new_btn.hide_icon = true
		new_btn.fill = true	
		new_btn.cost_val = item.cost
		
		store_list.push_back(new_btn)
		List.add_child(new_btn)
		
	BtnControls.itemlist = store_list
	BtnControls.item_index = 0
	
	ListLabel.text = store_data[tab_index].category
	
	on_purchased_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_purchased_update() -> void:
	if !is_node_ready() or store_list.is_empty():return
	var starting_data:Dictionary = OS_STORE.calc_starting_data()
	var os_settings:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_settings
	var currency:Dictionary = os_settings.currency
 
	# SET active state
	Economy.is_active = tab_index == 0
	Income.is_active = tab_index == 1
	Personnel.is_active = tab_index == 2
	
	# UPDATE NODES
	for index in store_list.size():
		var btn_node:Control = store_list[index]
		var item:Dictionary = store_data[tab_index].list[index]		
		var uid:String = str(tab_index, index)
		
		btn_node.title = item.details.name
		btn_node.use_alt = uid not in purchased
		btn_node.is_checked = uid in purchased
		btn_node.is_disabled = uid not in purchased and item.cost > currency.amount
		
		if item.has("hint"):
			btn_node.hint_title = "HINT"
			btn_node.hint_description = item.hint.description
			btn_node.hint_icon = item.hint.icon
			
	CostPanel.amount = os_settings.currency.amount

	# UPDATE PANELS
	Economy.money_val = starting_data.resources[RESOURCE.CURRENCY.MONEY]
	Economy.science_val = starting_data.resources[RESOURCE.CURRENCY.SCIENCE]
	Economy.material_val = starting_data.resources[RESOURCE.CURRENCY.MATERIAL]
	Economy.core_val = starting_data.resources[RESOURCE.CURRENCY.CORE]
	
	Income.money_val = starting_data.diff[RESOURCE.CURRENCY.MONEY]
	Income.science_val = starting_data.diff[RESOURCE.CURRENCY.SCIENCE]
	Income.material_val = starting_data.diff[RESOURCE.CURRENCY.MATERIAL]
	Income.core_val = starting_data.diff[RESOURCE.CURRENCY.CORE]
	
	Personnel.admin_val = starting_data.personnel[RESEARCHER.SPECIALIZATION.ADMIN]
	Personnel.researcher_val = starting_data.personnel[RESEARCHER.SPECIALIZATION.RESEARCHER]
	Personnel.security_val = starting_data.personnel[RESEARCHER.SPECIALIZATION.SECURITY]
	Personnel.dclass_val = starting_data.personnel[RESEARCHER.SPECIALIZATION.DCLASS]	
	
	PersonnelMax.admin_val = starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.ADMIN]
	PersonnelMax.researcher_val = starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.RESEARCHER]
	PersonnelMax.security_val = starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.SECURITY]
	PersonnelMax.dclass_val = starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.DCLASS]		
	
	
	# HEADER (ECONOMY)
	HeaderEconomy.money_val = starting_data.resources[RESOURCE.CURRENCY.MONEY] + starting_data.starting_resources[RESOURCE.CURRENCY.MONEY]
	HeaderEconomy.money_income = starting_data.diff[RESOURCE.CURRENCY.MONEY]

	HeaderEconomy.research_val = starting_data.resources[RESOURCE.CURRENCY.SCIENCE] + starting_data.starting_resources[RESOURCE.CURRENCY.SCIENCE]
	HeaderEconomy.researcher_income = starting_data.diff[RESOURCE.CURRENCY.SCIENCE]
	
	HeaderEconomy.material_val = starting_data.resources[RESOURCE.CURRENCY.MATERIAL] + starting_data.starting_resources[RESOURCE.CURRENCY.MATERIAL]
	HeaderEconomy.material_income = starting_data.diff[RESOURCE.CURRENCY.MATERIAL]
	
	HeaderEconomy.core_val = starting_data.resources[RESOURCE.CURRENCY.CORE] + starting_data.starting_resources[RESOURCE.CURRENCY.CORE]
	HeaderEconomy.core_income = starting_data.diff[RESOURCE.CURRENCY.CORE]		
	
	# HEADER (ECONOMY)
	HeaderPersonnel.admin_count = starting_data.personnel[RESEARCHER.SPECIALIZATION.ADMIN] + starting_data.starting_personnel[RESEARCHER.SPECIALIZATION.ADMIN]
	HeaderPersonnel.admin_max_count = starting_data.starting_personnel_capacity[RESEARCHER.SPECIALIZATION.ADMIN] + starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.ADMIN]
	
	HeaderPersonnel.researcher_count = starting_data.personnel[RESEARCHER.SPECIALIZATION.RESEARCHER] + starting_data.starting_personnel[RESEARCHER.SPECIALIZATION.RESEARCHER]
	HeaderPersonnel.researcher_max_count = starting_data.starting_personnel_capacity[RESEARCHER.SPECIALIZATION.RESEARCHER] + starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.RESEARCHER]
	
	HeaderPersonnel.security_count = starting_data.personnel[RESEARCHER.SPECIALIZATION.SECURITY] + starting_data.starting_personnel[RESEARCHER.SPECIALIZATION.SECURITY]
	HeaderPersonnel.security_max_count = starting_data.starting_personnel_capacity[RESEARCHER.SPECIALIZATION.SECURITY] + starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.SECURITY]
	
	HeaderPersonnel.dclass_count = starting_data.personnel[RESEARCHER.SPECIALIZATION.DCLASS] + starting_data.starting_personnel[RESEARCHER.SPECIALIZATION.DCLASS]
	HeaderPersonnel.dclass_max_count = starting_data.starting_personnel_capacity[RESEARCHER.SPECIALIZATION.DCLASS] + starting_data.personnel_capacity[RESEARCHER.SPECIALIZATION.DCLASS]
# ------------------------------------------------------------------------------

	
