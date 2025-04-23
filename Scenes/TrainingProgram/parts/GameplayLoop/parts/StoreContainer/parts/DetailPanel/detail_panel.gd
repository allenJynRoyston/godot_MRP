extends Control

@onready var DetailPanel:PanelContainer = $DetailPanel
@onready var MarginPanel:MarginContainer = $DetailPanel/MarginContainer

@onready var CardContainer:VBoxContainer = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/CardContainer
@onready var RoomCard:Control = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/CardContainer/RoomCard
@onready var ScpCard:Control = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/CardContainer/SCPCard
@onready var ResearcherCard:Control = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/CardContainer/ResearcherCard

@onready var PrevBtn:BtnBase = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/PrevBtn
@onready var FlipBtn:BtnBase = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/FlipBtn
@onready var NextBtn:BtnBase = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/NextBtn

@export var show_researcher_card:bool = true : 
	set(val):
		show_researcher_card = val
		on_show_researcher_card_update()
		
@export var show_room_card:bool = true : 
	set(val):
		show_room_card = val
		on_show_room_card_update()		
		
@export var show_scp_card:bool = true : 
	set(val):
		show_scp_card = val
		on_show_scp_card_update()

@export var hide_next_prev_btns:bool  = false : 
	set(val):
		hide_next_prev_btns = val
		on_hide_next_prev_btns_update()

var is_revealed:bool = false : 
	set(val):
		is_revealed = val
		on_is_revealed_update()

var room_ref:int = -1:
	set(val):
		room_ref = val
		on_room_ref_update()
		U.debounce("detail_panel_check_refs", check_refs)
		
var scp_ref:int = -1:
	set(val):
		scp_ref = val
		on_scp_ref_update()
		U.debounce("detail_panel_check_refs", check_refs)
		
var researcher_uid:int = -1:
	set(val):
		researcher_uid = val
		on_researcher_uid_update()
		U.debounce("detail_panel_check_refs", check_refs) 

var use_location:Dictionary 

var shop_unlock_purchases:Array = []
var control_pos:Dictionary = {}
var is_animating:bool = false

signal reveal_finished
signal cycle_until_complete

# ---------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_shop_unlock_purchases(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_shop_unlock_purchases(self)

func _ready() -> void:
	await U.tick()
	
	
	FlipBtn.onClick = func() -> void:
		flip_card()
		
	PrevBtn.onClick = func() -> void:
		cycle_cards(-1)

	NextBtn.onClick = func() -> void:
		cycle_cards(1)		
	
	control_pos[DetailPanel] = {
		"show": DetailPanel.position.x, 
		"hide": DetailPanel.position.x + MarginPanel.size.x
	}
	
	on_is_revealed_update(true)
	
	on_show_researcher_card_update()
	on_show_room_card_update()
	on_show_scp_card_update()
	on_hide_next_prev_btns_update()

	on_room_ref_update()
	on_scp_ref_update()
	on_researcher_uid_update()
# ---------------------------------

# ---------------------------------
func check_refs() -> void:	
	on_hide_next_prev_btns_update()
# ---------------------------------

# ---------------------------------
func reveal(state:bool) -> void:
	if state == is_revealed:
		await U.tick()		
		return
		
	is_revealed = state
	await reveal_finished
# ---------------------------------

# ---------------------------------
func on_shop_unlock_purchases_update(new_val:Array) -> void:
	shop_unlock_purchases = new_val
# ---------------------------------

# ---------------------------------
func switch_to_room_abilities() -> Array:
	hide_next_prev_btns = true
	
	cycle_until(RoomCard)
	
	await cycle_until_complete		
	
	if !RoomCard.flip:
		RoomCard.flip = true	
	
	await U.set_timeout(0.1)
	return await RoomCard.get_ability_btns()
# ---------------------------------

# ---------------------------------
func end_switch_to_room_abilities() -> void:
	hide_next_prev_btns = false
# ---------------------------------


# ---------------------------------
func on_hide_next_prev_btns_update() -> void:
	if !is_node_ready():return
	
	if hide_next_prev_btns:
		for btn in [NextBtn, PrevBtn]:
			btn.hide()
		return
	
	var visible_count:int = 0
	for card in [ResearcherCard, RoomCard, ScpCard]:
		if card.is_visible_in_tree():
			visible_count += 1	
	
	for btn in [NextBtn, PrevBtn]:
		if visible_count >=2:
			btn.show()  
		else:
			btn.hide()
			
func on_show_researcher_card_update() -> void:
	if !is_node_ready():return
	ResearcherCard.show() if show_researcher_card else ResearcherCard.hide()
	
func on_show_room_card_update() -> void:
	if !is_node_ready():return
	RoomCard.show() if show_room_card else RoomCard.hide()
	
func on_show_scp_card_update() -> void:
	if !is_node_ready():return
	ScpCard.show() if show_scp_card else ScpCard.hide()
# ---------------------------------	

# ---------------------------------
func on_is_revealed_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	var duration:float = 0.3 if !skip_animation else 0
	if is_revealed:
		show()
		
	await U.tween_node_property(DetailPanel, "position:x", control_pos[DetailPanel].show if is_revealed else control_pos[DetailPanel].hide, duration)

	if !is_revealed:
		hide()
	
	check_refs()
	
	reveal_finished.emit()
# ---------------------------------

# ---------------------------------
func on_room_ref_update() -> void:
	if !is_node_ready():return
	RoomCard.ref = room_ref
	
func on_scp_ref_update() -> void:
	if !is_node_ready() or use_location.is_empty():return
	ScpCard.use_location = use_location
	ScpCard.ref = scp_ref
	
func on_researcher_uid_update() -> void:
	if !is_node_ready():return
	ResearcherCard.uid = str(researcher_uid)
# ---------------------------------

# ---------------------------------
func flip_card() -> void:
	if !is_node_ready():return
	var card:Control = CardContainer.get_child(CardContainer.get_child_count() - 1)	
	card.flip = !card.flip
# ---------------------------------

# ---------------------------------
func cycle_until(card:Control, skip_animation:bool = false) -> void:
	var first_child:Control = CardContainer.get_child(CardContainer.get_child_count() - 1)	
	
	if first_child == card:
		await U.tick()
		is_animating = false
		cycle_until_complete.emit()	
		return
	
	is_animating = true
	var duration:float = 0 if skip_animation else 0.3
	var last_child:Control = CardContainer.get_child(CardContainer.get_child_count() - 1)	
	last_child.reveal = false
	await U.set_timeout(duration)
	CardContainer.move_child(last_child, 0)
	last_child.reveal = true
	await U.tick()

	cycle_until(card, skip_animation)
# ---------------------------------


# ---------------------------------
func cycle_cards(val:int, skip_animation:bool = false) -> void:
	var duration:float = 0 if skip_animation else 0.3
	is_animating = true
	if val > 0:
		var last_child:Control = CardContainer.get_child(CardContainer.get_child_count() - 1)	
		last_child.reveal = false
		await U.set_timeout(duration)
		CardContainer.move_child(last_child, 0)
		last_child.reveal = true
		await U.tick()
		if !CardContainer.get_child(CardContainer.get_child_count() - 1).is_visible_in_tree():
			cycle_cards( val, true )
			return		
		
	if val < 0:
		var first_child:Control = CardContainer.get_child(0)	
		first_child.reveal = false
		await U.set_timeout(duration)		
		CardContainer.move_child(first_child, CardContainer.get_child_count() - 1)
		#await U.tick()
		first_child.reveal = true
		await U.tick()
		if !CardContainer.get_child(0).is_visible_in_tree():
			cycle_cards( val, true )
			return
		
		
	is_animating = false
# ---------------------------------
