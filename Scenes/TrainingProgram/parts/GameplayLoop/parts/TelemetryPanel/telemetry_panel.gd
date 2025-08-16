extends SubscribeWrapper

# ------------------------------------------
func _init() -> void:
	super._init()
	GBL.subscribe_to_control_input(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unsubscribe_to_control_input(self)	

func _ready() -> void:
	pass
	
func start() -> void:
	pass
	
func end() -> void:
	pass
# ------------------------------------------

# ------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val	
	U.debounce(str(self, "_update_node"), update_node)
	
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val	
	U.debounce(str(self, "_update_node"), update_node)

func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce(str(self, "_update_node"), update_node)
	
func update_node() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var ring_config_data:Dictionary =room_config.floor[current_location.floor].ring[current_location.ring]
	var power_distribution:Dictionary = ring_config_data.power_distribution
	var energy_data:Dictionary = ring_config_data.energy
	var monitor:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].monitor
