extends PanelContainer

@onready var LoginLabel:Label = $MarginContainer/VBoxContainer/Label
@onready var LoginRTL:RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel

const login_arr:Array[String] = [
  "C:\\BOOT> [REDACTED] PC-██ Home Terminal",
  "C:\\CORE> boot SYSTEM-O-CORE v1.3.9 --build=1997-RELEASE",
  "C:\\MEMORY> scan /512mb",
  "C:\\DRIVES> mount C:\\",
  "C:\\CONFIG> load autoexec.bat",
  "C:\\CONFIG> load config.sys",
  "C:\\SOUND> initializing SoundMaster™ driver... OK",
  "C:\\VIDEO> loading VGA driver... 640x480@256c OK",
  "C:\\NET> attempting dial-up handshake... CONNECTED [28.8kbps]",
  "C:\\SYSTEM> echo Welcome to ORANGE SOFTWARE 1997",
  "C:\\SYSTEM> echo All systems nominal.",
  "C:\\LOGIN> user: admin",
  "C:\\LOGIN> password: ********",
  "ACCESS GRANTED.",
  "Launching terminal shell...",
  "██████████(R) ████-██(R) Version 6.22",
  "(C)Copyright ████████ Corp 1981-1994.",
  ".... READY",
];


signal is_complete

func start() -> void:
	
	SUBSCRIBE.music_data = {
		"selected": MUSIC.TRACK.OS_STARTUP_SFX,
	}
	
	show()	
	await U.set_timeout(2.5)

	for i in login_arr.size():
		var str:String = login_arr[i]
		var line:String = ""

		for c in str:
			line += c
			LoginRTL.text += c

		LoginRTL.text += "\r"  # Move to new line after each string

		if i == login_arr.size() - 1:
			await U.set_timeout(2.0)
		else:
			await U.set_timeout(0.2)  # Short pause between lines


	GBL.find_node(REFS.AUDIO).fade_out(3.0)
	queue_free()
