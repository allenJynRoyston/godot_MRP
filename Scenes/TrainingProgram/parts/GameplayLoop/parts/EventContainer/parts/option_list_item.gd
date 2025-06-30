extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var IconBtn:Control = $MarginContainer/HBoxContainer/IconBtn

@onready var PropertyLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/PropertyLabel
@onready var TitleLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/TitleLabel

var index:int
var enabled:bool = false 
var is_paranoid:bool = false

var render_if:Dictionary = {} : 
	set(val):
		render_if = val
		on_render_if_update()

var is_available:bool = true : 
	set(val):
		is_available = val
		is_available_update()

var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		
var apply_dyslexia:bool = false
var allow_for_hint:bool = false

var onClick:Callable = func() -> void:pass
var onHover:Callable = func() -> void:pass

# ----------------------
func _init() -> void:
	super._init()
	modulate = Color(1, 1, 1, 0)

func _ready() -> void:
	super._ready()
	on_data_update()
	on_render_if_update.call_deferred()	
	hint_title = "HINT"
	

func start(delay:float = 0) -> void:
	U.tween_node_property(IconBtn, 'static_color:a', 0.6, 0.3, delay)
	U.tween_node_property(self, 'modulate:a', 0.6, 0.3, delay)
	await U.set_timeout(0.1)
# ----------------------

# ----------------------	
func fade_out(delay:float = 0) -> void:
	U.tween_node_property(IconBtn, 'static_color:a', 0, 0.3, delay)
	await U.tween_node_property(self, 'modulate:a', 0, 0.3, delay)
# ----------------------		

# ----------------------	
func is_available_update() -> void:
	if !is_node_ready():return
	IconBtn.hide() if is_available else IconBtn.show()
	
	on_is_selected_update()
	on_data_update()
# ----------------------	

# ----------------------	
func on_is_selected_update() -> void:
	if !is_node_ready():return
	var stylebox:StyleBoxFlat = RootPanel.get("theme_override_styles/panel").duplicate()
	stylebox.bg_color = Color.RED if !is_available else (Color(0.337, 0.275, 1.0) if is_selected else Color(0.162, 0.162, 0.162))
	RootPanel.set('theme_override_styles/panel', stylebox)	
	
	modulate = Color(1, 1, 1, 1 if is_selected else 0.6)
	IconBtn.static_color.a = 1 if is_selected else 0.6
	
	if is_available:
		hint_description = "" if ("success_rate" not in data or !allow_for_hint) else "Estimated chance of success: %s%s." % [data.success_rate, "%"] 
	else:
		hint_description = "UNAVAILABLE" if render_if.is_empty() else render_if.hint_description


func on_render_if_update() -> void:
	if !is_node_ready():return
	
	if render_if.is_empty() or is_paranoid:
		is_available = true
		PropertyLabel.hide()
		return
	
	if "lockout" in render_if and render_if.lockout:
		is_available = false
		PropertyLabel.text = "UNAVAILABLE"
		return
		
	is_available = render_if.is_available	 
	PropertyLabel.text = "(%s)" % render_if.property
	
	
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	TitleLabel.text = "THEY'RE ALL OUT TO GET YOU..." if is_paranoid else simulate_dyslexia(data.title) if apply_dyslexia else data.title
# ----------------------

# ----------------------
func simulate_dyslexia(input_text: String) -> String:
	var words = input_text.split(" ")
	var distorted_words: Array[String] = []

	for word in words:
		var distorted_word = word

		# Scramble internal letters of the word (not first/last)
		if word.length() > 3 and randf() < 0.2:
			distorted_word = scramble_word(distorted_word)

		# Distort letters randomly
		var distorted_chars: Array[String] = []
		for ch in distorted_word:
			if randf() < 0.2:
				distorted_chars.append(distort_letter(ch))
			else:
				distorted_chars.append(ch)

		distorted_words.append("".join(distorted_chars))

	return " ".join(distorted_words)


func distort_letter(letter: String) -> String:
	var distortions := {
		"a": ["o", "e", "u"],
		"e": ["a", "o", "i"],
		"o": ["a", "e", "u"],
		"i": ["e", "o", "a"],
		"t": ["f", "l", "j"],
		"l": ["i", "t", "h"],
		"h": ["l", "u", "k"],
		"b": ["d", "p"],
		"d": ["b", "p"],
		"p": ["b", "d"]
	}
	letter = letter.to_lower()
	if distortions.has(letter):
		var options: Array = distortions[letter]
		return options[randi() % options.size()]
	return letter


func scramble_word(word: String) -> String:
	if word.length() <= 3:
		return word

	var first_char = word[0]
	var last_char = word[word.length() - 1]
	var middle_chars: Array[String] = []

	# Get middle characters as array
	for i in range(1, word.length() - 1):
		middle_chars.append(word[i])

	# Shuffle middle characters
	middle_chars.shuffle()

	return first_char + "".join(middle_chars) + last_char
# ----------------------

var time_accumulator := 0.0
var trigger_time := randf_range(0.5, 1.0)
func _process(delta: float) -> void:
	if !is_node_ready() or !apply_dyslexia:return
	time_accumulator += delta

	if time_accumulator >= trigger_time:
		time_accumulator = 0.0
		trigger_time = randf_range(0.5, 1.0)
		on_data_update()
