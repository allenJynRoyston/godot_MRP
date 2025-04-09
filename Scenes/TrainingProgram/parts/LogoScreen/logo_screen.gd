extends PanelContainer

@onready var Logo:TextureRect = $CenterContainer/VBoxContainer/Logo

signal finished

func _ready() -> void:
	hide()

func start(fast_boot:bool = false) -> void:	
	Logo.material.set_shader_parameter("alpha", 1.0)
	show()
	await U.set_timeout(5.0 if !fast_boot else 1.0)
	self.modulate = Color(1, 1, 1, 0.3)
	Logo.material.set_shader_parameter("alpha", 0.3)
	await U.set_timeout(0.2)
	finished.emit()	
