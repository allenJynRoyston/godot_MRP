extends PanelContainer

@onready var LoginLabel:Label = $MarginContainer/VBoxContainer/Label
@onready var LoginRTL:RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel

const login_arr: Array = [
  "C:\\WONDERTAINMENT\\BOOT> ✨ Dr. Wondertainment's PC97™ Home Terminal ✨",
  "C:\\CORE> boot WOND-O-CORE™ v1.3.9 --build=Fun-Fun-Fun!",
  "C:\\MEMORY> scan /gigglebytes",
  "C:\\DRIVES> mount ImaginoDrive",
  "C:\\SYSTEM> echo 'Have a WONDERTASTIC day! No refunds. No returns.'"
];


signal is_complete

func start() -> void:
	show()
	await U.set_timeout(1.0)

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

	queue_free()
