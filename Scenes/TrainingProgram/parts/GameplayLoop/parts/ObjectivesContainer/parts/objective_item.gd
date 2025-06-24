@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."
@onready var ContentLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/ContentLabel
@onready var YouHaveLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/YouHaveLabel
@onready var IconBtn:BtnBase = $MarginContainer/HBoxContainer/IconBtn
@onready var BookmarkIcon:BtnBase = $Control/BookmarkIcon

@export var is_naked:bool = false : 
	set(val):
		is_naked = val
		on_is_naked_update()
		

var content:String = "Objective"
var you_have:String = ""
var is_completed:bool = false
var is_expired:bool = false
var is_upcoming:bool = false
var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()


var bookmarked_objectives:Array = []
var show_bookmark:bool = false
var is_bookmarked:bool = false : 
	set(val):
		is_bookmarked = val
		on_is_bookmarked_update()

var use_color:Color = Color(1, 1, 1, 1)

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_bookmarked_objectives(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_bookmarked_objectives(self)
	

func _ready() -> void:
	super._ready()
	
	ContentLabel.text = "Upcoming..." if is_upcoming else content
	YouHaveLabel.text = "(Objective complete)" if is_expired else ("(Currently have %s.)" % you_have)
	YouHaveLabel.hide() if (you_have == "" or is_upcoming) else YouHaveLabel.show()
	IconBtn.icon = SVGS.TYPE.CLEAR if is_expired else (SVGS.TYPE.CHECKBOX if is_completed else SVGS.TYPE.EMPTY_CHECKBOX)
	BookmarkIcon.show() if show_bookmark else BookmarkIcon.hide()
	on_is_bookmarked_update()
	
	use_color = Color.GREEN
	
	if !is_completed:
		use_color = Color(0.337, 0.275, 1.0)
	if is_expired:
		use_color = Color(0.337, 0.275, 1.0).lightened(0.5)
		
	hint_title = "HINT"
	hint_description = content
	hint_icon = SVGS.TYPE.INFO
	
	if is_hoverable:
		on_focus(false)	
	
	on_is_selected_update()
	on_bookmarked_objectives_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_bookmarked_objectives_update(new_val:Array = bookmarked_objectives) -> void:
	bookmarked_objectives = new_val
	show_bookmark_update()
	
func show_bookmark_update() -> void:
	if !is_node_ready() or !show_bookmark:return
	for item in bookmarked_objectives:
		if item.title == content:
			is_bookmarked = true
			return
	is_bookmarked = false
	
func on_is_bookmarked_update() -> void:
	if !is_node_ready():return
	BookmarkIcon.static_color = Color(1, 1, 1, 1 if is_bookmarked else 0.6)
	
func on_is_naked_update() -> void:
	if !is_node_ready():return	
	on_is_selected_update()

func on_is_selected_update() -> void:
	var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()	
	var c:Color = use_color
	new_stylebox.border_color = c if !is_naked else Color(1, 1, 1, 0)
	new_stylebox.bg_color = Color(0.0, 0.0, 0.0, 0.7 if !is_naked else 0)
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)
	IconBtn.static_color = Color(c.r, c.g, c.b, 0.7 if is_selected else 1)
	

func on_focus(state:bool = is_focused) -> void:
	if !is_disabled:	
		super.on_focus(state)
		self.modulate = Color(1, 1, 1, 1 if state else 0.8)
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if !is_node_ready() or !is_visible_in_tree() or !is_hoverable or is_disabled:return
	super.on_mouse_click(node, btn, on_hover)
# ------------------------------------------------------------------------------
