extends PanelContainer

@export var ref:int = -1: 
	set(val):
		ref = val
		on_ref_update()

var scp_data:Dictionary = {}
var index:int = -1
var use_location:Dictionary = {}

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_scp_data(self)	
	
func _ready() -> void:
	on_ref_update()
	on_reveal_update()
	on_is_active_update()
	on_is_selected_update()
	on_is_deselected_update()
	on_show_assigned_update()
	on_scp_data_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	on_ref_update()

func on_flip_update() -> void:
	if !is_node_ready():return

func on_is_active_update() -> void:
	if !is_node_ready():return

func on_show_assigned_researcher_update() -> void:
	if !is_node_ready():return

func on_is_selected_update() -> void:
	if !is_node_ready():return

func on_show_assigned_update() -> void:
	if !is_node_ready():return

func on_is_deselected_update() -> void:
	if !is_node_ready():return

func on_reveal_update() -> void:
	if !is_node_ready():return

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_ref_update() -> void:
	if !is_node_ready():return	
	#print(scp_data)
		#
	#var scp_details:Dictionary = SCP_UTIL.return_data(ref)
	#var currency_list:Array = []
	#var has_spec_bonus:bool = false
	#var has_trait_bonus:bool = false
	#var morale_val:int = 0	
	#var research_level:int = 0 if ref not in scp_data else scp_data[ref].level
	#var is_contained:bool = false if ref not in scp_data else scp_data[ref].is_contained
	#
	#var hide_currency:bool = true
	#for item in currency_list:
		#var amount:int = int(item.title)
		#if amount != 0:
			#hide_currency = false
			#break
			#
	#var hide_metrics:bool = true
	#for key in scp_details.metrics:
		#var amount:int = scp_details.metrics[key]
		#if amount != 0:
			#hide_metrics = false
			#break	

# ------------------------------------------------------------------------------
