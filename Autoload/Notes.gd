extends SubscribeWrapper

enum REF {FIRST_NOTE}

var notes_in_queue:Array = [] : 
	set(val):
		notes_in_queue = val

var note_playing:bool = false

var ref_data:Dictionary = {
	REF.FIRST_NOTE: {
		"content": "I CAN LOCK IMPORTANT NOTES",
		"pos": Vector2(100, 100),
		"is_locked": true
	}
}


func use(ref:REF) -> void:
	var note_data:Dictionary = ref_data[ref]	
	note_data.screenshot = FS.save_screenshot(str("note_", ref))
	notes_in_queue.push_back(note_data)

func _process(delta: float) -> void:
	if notes_in_queue.size() > 0 and !note_playing:
		note_playing = true
		var current_note:Dictionary = notes_in_queue[0]
		SUBSCRIBE.note = current_note
		await U.set_timeout(5.0)
		notes_in_queue.pop_at(0)
		SUBSCRIBE.note = {}
		await U.set_timeout(1.0)
		note_playing = false
		
		
