extends MouseInteractions

var onFocus:Callable = func():pass
var onBlur:Callable = func():pass

# --------------------------------------	
func on_focus(state:bool) -> void:
	if state:
		onFocus.call()
	else:
		onBlur.call()
# --------------------------------------	
