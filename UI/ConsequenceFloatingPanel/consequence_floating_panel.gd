extends Control

@onready var MainPanel:PanelContainer = $PanelContainer
@onready var ArrowBtn:BtnBase = $Control/IconBtn
@onready var Icon1:BtnBase = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/IconBtn
@onready var Label1:Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label1
@onready var Label2:Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label2

func _init() -> void:
	SUBSCRIBE.subscribe_to_resources_data(self)
	self.modulate = Color(1, 1, 1, 0)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	
func fade_out() -> void:
	await U.tween_node_property(self, 'modulate:a', 0)

func update(data:Dictionary, type:String = "NEGATIVE") -> void:
	if data.is_empty():return
	
	if "success_rate" not in data:
		modulate = Color(1, 1, 1, 0)
		return

	var chance_of:int = 100 - data.success_rate if type == 'NEGATIVE' else data.success_rate
	Label1.text = str(chance_of, "% chance")
	var effect:Dictionary = data.effect.call(false if type == 'NEGATIVE' else true)
	var new_stylebox:StyleBoxFlat = MainPanel.get_theme_stylebox('panel').duplicate()	
	var has_consequence:bool = false
	
	
	# -----------------------------
	if type == 'NEGATIVE':
		if "damage_hp" in effect:
			Label2.text = "DAMAGE"
			Icon1.icon = SVGS.TYPE.CAUTION
			new_stylebox.bg_color = Color.RED
			ArrowBtn.static_color = Color.RED
			has_consequence = true

		if "staff_killed" in effect:
			Label2.text = "DEATH"
			Icon1.icon = SVGS.TYPE.DANGER
			new_stylebox.bg_color = Color.BLACK
			ArrowBtn.static_color = Color.BLACK
			has_consequence = true
	
	# -----------------------------
	if type == 'POSITIVE':
		if "restore_hp" in effect:
			Label2.text = "HEAL"
			Icon1.icon = SVGS.TYPE.NO_ISSUES
			new_stylebox.bg_color = Color.DARK_GREEN
			ArrowBtn.static_color = Color.DARK_GREEN
			has_consequence = true
	
	
	
	if chance_of == 0:
		has_consequence = false
		
	#modulate = Color(1, 1, 1, 1 if has_consequence else 0)
	MainPanel.add_theme_stylebox_override("panel", new_stylebox)
	modulate = Color(1, 1, 1, 1 if has_consequence else 0)
	


func goto(pos:Vector2 = self.position) -> void:
	self.position = pos - Vector2(MainPanel.size.x + 20, MainPanel.size.y/ 2)

func reveal(state:bool) -> void:
	modulate = Color(1, 1, 1, 1 if state else 0)
