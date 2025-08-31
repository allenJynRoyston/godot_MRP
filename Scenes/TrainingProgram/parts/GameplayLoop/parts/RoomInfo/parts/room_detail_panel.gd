extends PanelContainer

#@onready var TitleLabel:Label = $TextureRect/VBoxContainer/MarginContainer2/HBoxContainer/TitleLabel
#@onready var LevelLabel:Label = $TextureRect/VBoxContainer/MarginContainer2/HBoxContainer/LevelLabel
#@onready var ProfileImage:TextureRect = $SubViewport/ProfileImage
#
#@onready var StatusTag:PanelContainer = $TextureRect/VBoxContainer/StatusContainer/StatusTag
#@onready var StatusLabel:Label = $TextureRect/VBoxContainer/StatusContainer/StatusTag/MarginContainer/StatusLabel
#
#@onready var ResearcherIconContainers:MarginContainer = $TextureRect/VBoxContainer/ResearcherIconContainers
#@onready var ResearcherIcons:HBoxContainer = $TextureRect/VBoxContainer/ResearcherIconContainers/ResearcherIcons
#@onready var RIcon1:Control = $TextureRect/VBoxContainer/ResearcherIconContainers/ResearcherIcons/RIcon1
#@onready var RIcon2:Control = $TextureRect/VBoxContainer/ResearcherIconContainers/ResearcherIcons/RIcon2
#
#const StaticShader:ShaderMaterial = preload("res://Shader/Static.tres")
#
#@onready var extract_data:Dictionary : 
	#set(val):
		#extract_data = val
		#on_extract_data_update()
				#
#
## --------------------
#func _ready() -> void:
	#on_extract_data_update()
## --------------------
#
## --------------------
#func on_extract_data_update() -> void:
	#if !is_node_ready() or extract_data.is_empty():return
	#
	#if extract_data.room.is_empty():
		#StatusTag.hide()
		#TitleLabel.text = " NOTHING ASSIGNED " 
		#LevelLabel.text = ""
		#ProfileImage.material = StaticShader
		#ProfileImage.texture = CACHE.fetch_image("")
	#else:		
		#TitleLabel.text = " %s " % [extract_data.room.details.shortname]
		#ProfileImage.texture = CACHE.fetch_image(extract_data.room.details.img_src)
		#ProfileImage.material = null
		##LevelLabel.text = "LVL %s " % [extract_data.room.upgrade_level]
		#if !extract_data.room.is_activated:
			#StatusTag.show()
			#StatusLabel.text = "INACTIVE"
		#else:
			#StatusTag.hide()
			#
	#RIcon1.static_color = Color.WHITE if extract_data.researchers.size()>= 1 else Color.RED
	#RIcon2.static_color = Color.WHITE if extract_data.researchers.size()>= 2 else Color.RED			
## --------------------			
