extends PanelContainer

@onready var LoginLabel:Label = $MarginContainer/VBoxContainer/Label
@onready var LoginRTL:RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel
@onready var Overlay:ColorRect = $ColorRect

const login_arr:Array[String] = [
  "C:\\BOOT> Orange PC-97.exe",
  "C:\\CONFIG> load autoexec.bat",
  "C:\\CONFIG> load config.sys",
  "C:\\SOUND> initializing SoundMax™ driver... OK",
  "OrangeOS Version 6.22",
  "(C)Copyright Wondertainment PC Division 1981-1994.",
  ".... READY",
];

signal is_complete

func _ready() -> void:
	Overlay.color = Color(1, 1, 1, 1)

func start() -> void:
	OS_AUDIO.fade_out(OS_AUDIO.CHANNEL.REVERB, 1.0, true)
		
	await U.tween_node_property(Overlay, "color:a", 0, 1.0)
	
	for i in login_arr.size():
		var str:String = login_arr[i]
		var line:String = ""

		for c in str:
			line += c
			LoginRTL.text += c

		LoginRTL.text += "\r"  # Move to new line after each string

		if i == login_arr.size() - 1:
			await U.set_timeout(1.0)
		else:
			await U.set_timeout(0.2)  # Short pause between lines

	await U.tween_node_property(Overlay, "color", Color(0, 0, 0, 1), 1.0)

	queue_free()
