extends Marker2D

const tutorial_notes:Array = [
	"A timeline of important known events."
]

# --------------------------------------------------------------------------------------------------
func _notification(what):
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if is_visible_in_tree():
				SUBSCRIBE.add_note_node(self)
			else:
				SUBSCRIBE.remove_note_node(self)
