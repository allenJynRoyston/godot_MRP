extends PanelContainer

enum MODE {HIDE, START, DISPLAY_LOGO, DISPLAY_TITLE, DISPLAY_SIDE_TEXT, WAIT_FOR_INPUT, EXIT}

var current_mode:MODE = MODE.HIDE : 
	set(val):
		current_mode = val
		on_current_mode_update()

signal on_finish

func _ready() -> void:
	on_current_mode_update()
	
func start() -> void:
	show()
	current_mode = MODE.START

func end() -> void:
	await U.set_timeout(0.3)
	hide()
	on_finish.emit()

func on_current_mode_update() -> void:
	if !is_node_ready():return
	match current_mode:
		# ---------
		MODE.START:
			current_mode = MODE.DISPLAY_LOGO
		# ---------
		MODE.DISPLAY_LOGO:
			current_mode = MODE.DISPLAY_TITLE
		# ---------
		MODE.DISPLAY_TITLE:
			current_mode = MODE.DISPLAY_SIDE_TEXT
		# ---------
		MODE.DISPLAY_SIDE_TEXT:
			current_mode = MODE.WAIT_FOR_INPUT
		# ---------
		MODE.WAIT_FOR_INPUT:
			current_mode = MODE.EXIT
		# ---------
		MODE.EXIT:
			end()
			
