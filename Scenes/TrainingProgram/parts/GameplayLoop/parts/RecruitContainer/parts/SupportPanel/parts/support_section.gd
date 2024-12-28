@tool
extends PanelContainer

enum OPTIONS {STAFF, SECURITY, DCLASS}

@onready var TitleLabel:Label = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/TitleLabel
@onready var IconBtn:Control = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/IconBtn
@onready var SectionImage:TextureRect = $VBoxContainer/SectionImage
@onready var HireBtn:BtnBase = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/HireBtn
@onready var PPU:BtnBase = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer3/PPU

@onready var PlusOne:BtnBase = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer2/HBoxContainer/VBoxContainer/PlusOne
@onready var MinusOne:BtnBase = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer2/HBoxContainer/VBoxContainer/MinusOne
@onready var PlusFive:BtnBase = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer2/HBoxContainer/VBoxContainer2/PlusFive
@onready var MinusFive:BtnBase = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer2/HBoxContainer/VBoxContainer2/MinusFive

@onready var CurrentAmount:Label = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer2/CurrentLabel
@onready var PurchaseAmount:Label = $VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer2/PurchaseLabel

@export var option:OPTIONS = OPTIONS.STAFF : 
	set(val):
		option = val
		on_option_update()

var onHireClick:Callable = func(amount:int):pass

var resources_data:Dictionary = {} 

var amount:int = 0 : 
	set(val):
		amount = val
		if amount > amount_max:
			amount = amount_max	
		
		if amount < -(amount_min):
			amount = amount_min		
		
		on_amount_update()

var amount_max:int = 0 
var amount_min:int = 0
var amount_price:int = 0 : 
	set(val):
		amount_price = val
		on_amount_update()

# ----------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_resources_data(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_resources_data(self)
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
func _ready() -> void:
	PlusOne.onClick = func() -> void:
		amount = amount + 1		
	PlusFive.onClick = func() -> void:
		amount = amount + 5
	MinusOne.onClick = func() -> void:
		amount = amount - 1
	MinusFive.onClick = func() -> void:
		amount = amount - 5

	HireBtn.onClick = func() -> void:
		var total_amount:int = amount * amount_price
		if resources_data[RESOURCE.TYPE.MONEY].amount >= total_amount:
			onHireClick.call(amount, total_amount)
		else:
			print("NOT ENOUGH...")
	on_amount_update()
	on_option_update()
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
func on_amount_update() -> void:	
	PPU.title = str(amount_price)
	HireBtn.title = str(amount * amount_price)
	PurchaseAmount.text = str(amount)
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	if !is_node_ready() or resources_data.is_empty():return
	match option:
		OPTIONS.STAFF:
			CurrentAmount.text = str(resources_data[RESOURCE.TYPE.STAFF].amount)
			amount_max = resources_data[RESOURCE.TYPE.STAFF].capacity
			amount_min = resources_data[RESOURCE.TYPE.STAFF].amount
			amount_price = 2
		OPTIONS.SECURITY:
			CurrentAmount.text = str(resources_data[RESOURCE.TYPE.SECURITY].amount)
			amount_max = resources_data[RESOURCE.TYPE.SECURITY].capacity
			amount_min = resources_data[RESOURCE.TYPE.SECURITY].amount
			amount_price = 3
		OPTIONS.DCLASS:
			CurrentAmount.text = str(resources_data[RESOURCE.TYPE.DCLASS].amount)
			amount_max = resources_data[RESOURCE.TYPE.DCLASS].capacity
			amount_min = resources_data[RESOURCE.TYPE.DCLASS].amount
			amount_price = 1
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
func on_option_update() -> void:
	if !is_node_ready():return
	match option:
		OPTIONS.STAFF:
			TitleLabel.text = "Staff"
			IconBtn.icon = SVGS.TYPE.STAFF
			SectionImage.texture = CACHE.fetch_image("res://Media/images/researcher.jpg")
			
		OPTIONS.SECURITY:
			TitleLabel.text = "Security"
			IconBtn.icon = SVGS.TYPE.SECURITY
			SectionImage.texture = CACHE.fetch_image("res://Media/images/security.jpg")
			
		OPTIONS.DCLASS:
			TitleLabel.text = "D-Class"
			IconBtn.icon = SVGS.TYPE.D_CLASS
			SectionImage.texture = CACHE.fetch_image("res://Media/images/dclass.jpg")
			
# ----------------------------------------------------------------------------
