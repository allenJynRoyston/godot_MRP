@tool
extends BtnBase

@onready var IconBtn:Control = $IconBtn
@onready var TraitCard:Control = $TraitCard

@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
@export var is_highlighted:bool = false : 
	set(val):
		is_highlighted = val
		on_is_highlighted_update()		
		
@export var trait_ref:int = -1 : 
	set(val):
		trait_ref = val
		on_trait_ref_update()


# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	on_is_selected_update()
	on_trait_ref_update() 
	on_is_highlighted_update()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_is_selected_update() -> void:
	if !is_node_ready():return
	IconBtn.icon = SVGS.TYPE.NEXT if is_selected else SVGS.TYPE.NONE

func on_is_highlighted_update() -> void:
	if !is_node_ready():return
	TraitCard.is_highlighted = is_highlighted

func on_trait_ref_update() -> void:
	if !is_node_ready():return
	TraitCard.ref = trait_ref
# ------------------------------------------------------------------------------	
	
