extends Control

@onready var DetailPanel:PanelContainer = $DetailPanel
@onready var MarginPanel:MarginContainer = $DetailPanel/MarginContainer

@onready var CardContainer:VBoxContainer = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/CardContainer
@onready var RoomCard:Control = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/CardContainer/RoomCard
@onready var ScpCard:Control = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/CardContainer/SCPCard
@onready var ResearcherCard:Control = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/CardContainer/ResearcherCard

#@onready var PrevBtn:BtnBase = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/PrevBtn
@onready var FlipBtn:BtnBase = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/FlipBtn
#@onready var NextBtn:BtnBase = $DetailPanel/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/NextBtn

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

@export var disable_inputs:bool = false : 
	set(val):
		disable_inputs = val
		on_disable_inputs_update()
		
@export var disable_location:bool = false

@export var preview_mode:bool = false
@export var show_cost:bool = false
@export var show_research_cost:bool = false

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
		
	#PrevBtn.onClick = func() -> void:
		#cycle_cards(-1)
#
	#NextBtn.onClick = func() -> void:
		#cycle_cards(1)		
	#
	on_is_revealed_update(true)
	on_disable_inputs_update()
	
	on_show_researcher_card_update()
	on_show_room_card_update()
	on_show_scp_card_update()
	on_hide_next_prev_btns_update()

	on_room_ref_update()
	on_scp_ref_update()
	on_researcher_uid_update()
	
	await U.tick()
	control_pos[DetailPanel] = {
		"show": DetailPanel.position.x, 
		"hide": DetailPanel.position.x + MarginPanel.size.x
	}
	
	animate(false, true)
# ---------------------------------

# ---------------------------------
func check_refs() -> void:	
	on_hide_next_prev_btns_update()
# ---------------------------------


# ---------------------------------
func on_disable_inputs_update() -> void:
	if !is_node_ready():return
	for btn in [FlipBtn]:
		if disable_inputs:
			btn.hide()
		else:
			btn.show()
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
func on_hide_next_prev_btns_update() -> void:
	if !is_node_ready():return
	
	#if hide_next_prev_btns:
		#for btn in [NextBtn, PrevBtn]:
			#btn.hide()
		#return
	
	var visible_count:int = 0
	for card in [ResearcherCard, RoomCard, ScpCard]:
		if card.is_visible_in_tree():
			visible_count += 1	
	
	#for btn in [NextBtn, PrevBtn]:
		#if visible_count >=2:
			#btn.show()  
		#else:
			#btn.hide()
	
	#if visible_count == 0:
		#FlipBtn.hide()
	#else:
		#FlipBtn.show()
			#
# ---------------------------------
func on_room_ref_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self.name, "_update_card_states"), update_card_states)		
	
func on_scp_ref_update() -> void:
	if !is_node_ready() or (use_location.is_empty() and !disable_location):return
	U.debounce(str(self.name, "_update_card_states"), update_card_states)		
	
func on_researcher_uid_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self.name, "_update_card_states"), update_card_states)		
# ---------------------------------
			
# ---------------------------------
func on_show_researcher_card_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self.name, "_update_card_states"), update_card_states)	
	
func on_show_room_card_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self.name, "_update_card_states"), update_card_states)	
	
func on_show_scp_card_update() -> void:
	if !is_node_ready():return
	U.debounce(str(self.name, "_update_card_states"), update_card_states)		
	
func update_card_states() -> void:
	RoomCard.show() if show_room_card else RoomCard.hide()
	ResearcherCard.show() if show_researcher_card else ResearcherCard.hide()
	ScpCard.show() if show_scp_card else ScpCard.hide()
	
	await U.tick()
	
	RoomCard.show_research_cost = show_research_cost
	RoomCard.show_cost = show_cost
	RoomCard.preview_mode = preview_mode
	RoomCard.use_location = use_location if !disable_location else {}	
	RoomCard.ref = room_ref
		
	ScpCard.use_location = use_location if !disable_location else {}
	ScpCard.ref = scp_ref
	
	ResearcherCard.uid = str(researcher_uid)

# ---------------------------------	

# ---------------------------------
func on_is_revealed_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	var duration:float = 0.3 if !skip_animation else 0
	if is_revealed:
		show()
	
	await animate(is_revealed, skip_animation)

	if !is_revealed:
		hide()
	
	check_refs()
	
	reveal_finished.emit()
# ---------------------------------

# ---------------------------------
func animate(state:bool, skip_animation:bool = false) -> void:
	var duration:float = 0 if skip_animation else 0.3
	await U.tween_node_property(DetailPanel, "position:x", control_pos[DetailPanel].show if state else control_pos[DetailPanel].hide, duration)
# ---------------------------------

# ---------------------------------
func flip_card() -> void:
	if !is_node_ready():return
	var card:Control = CardContainer.get_child(CardContainer.get_child_count() - 1)	
	card.flip = !card.flip
# ---------------------------------

# ---------------------------------
func cycle_to_room(skip_animation:bool = false) -> void:
	cycle_until(RoomCard, skip_animation)
# ---------------------------------

# ---------------------------------
func cycle_to_scp(skip_animation:bool = false) -> void:
	cycle_until(ScpCard, skip_animation)
# ---------------------------------

# ---------------------------------
func cycle_to_reseacher(skip_animation:bool = false) -> void:
	cycle_until(ResearcherCard, skip_animation)
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
