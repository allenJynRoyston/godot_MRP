extends Node

const save_config:Dictionary = {
	"folder": "res://Saves/",
	"image_ext": ".png",
	"image_size": 400,
	"pretty_filenames": {
		"quick_save": "Quicksave",
		"filesave_one": "File 1",
		"filesave_two": "File 2",
		"filesave_three": "File 3"
	},
	"filenames": {		
		"quicksave": "SAVE_QUICKSAVE",
		"save_file_one": "SAVE_01",
		"save_file_two": "SAVE_02",
		"save_file_three": "SAVE_03",		
		
	}
}

const folder:String = save_config.folder
const quick_save_filename:String = save_config.filenames.quicksave
const save_file_one_filename:String = save_config.filenames.save_file_one
const save_file_two_filename:String = save_config.filenames.save_file_two
const save_file_three_filename:String = save_config.filenames.save_file_three

enum FILE {QUICK_SAVE, SAVE_ONE, SAVE_TWO, SAVE_THREE}

# -----------------------------------------------------------
func system_data_defaults() -> Dictionary:
	return {
		"video": {
			"MSAA": Viewport.MSAA_DISABLED,
			"SSAA": Viewport.SCREEN_SPACE_AA_DISABLED,
			"resolution": Vector2(1280, 720),
			"full_screen": DisplayServer.WINDOW_MODE_WINDOWED
		},
		"sound_enabled": {
			"fx": true,
			"music": true
		},
		"sound_volume": {
			"fx": 100,
			"music": 100,	
		},
		"controls": {
			
		}
	}	
# -----------------------------------------------------------

# -----------------------------------------------------------
func persistant_data_defaults() -> Dictionary:
	return {}
# -----------------------------------------------------------

# -----------------------------------------------------------
func check_for_quicksave_file() -> bool:
	return save_file_exist(FILE.QUICK_SAVE)
# -----------------------------------------------------------	

# -----------------------------------------------------------
func check_for_any_save_files() -> bool:
	var has_save_files:bool = false
	if !has_save_files:
		has_save_files = save_file_exist(FILE.SAVE_ONE)
	if !has_save_files:
		has_save_files = save_file_exist(FILE.SAVE_TWO)
	if !has_save_files:
		has_save_files = save_file_exist(FILE.SAVE_THREE)
	
	return has_save_files
# -----------------------------------------------------------	
	
# ---------------------------------		
func save_file_exist(type:FILE) -> bool:
	var filepath:String
	
	match type:
		# ----------------------------
		FILE.QUICK_SAVE:
			filepath = str(folder, quick_save_filename)		
		# ----------------------------
		FILE.SAVE_ONE:
			filepath = str(folder, save_file_one_filename)
		# ----------------------------
		FILE.SAVE_TWO:
			filepath = str(folder, save_file_two_filename)
		# ----------------------------
		FILE.SAVE_THREE:
			filepath = str(folder, save_file_three_filename)
	
	return FileAccess.file_exists(filepath)
# ---------------------------------	

# ---------------------------------		
func extract_data_from_save(data:Dictionary) -> Dictionary:
	return {}	

func get_file_data(filepath:String) -> Dictionary:
	var filedata:Dictionary = {}
	if FileAccess.file_exists(filepath):
		var results = FileAccess.open(filepath, FileAccess.READ)
		filedata = results.get_var()
		results.close()		
	return filedata

func load_file(type:FILE, is_preview:bool = false) -> Dictionary:
	var data:Dictionary = {}
	var filedata:Dictionary = {}
	
	match type:
		# ----------------------------
		FILE.QUICK_SAVE:
			var filepath:String = str(folder, quick_save_filename)
			filedata = get_file_data(filepath)	
		# ----------------------------
		FILE.SAVE_ONE:
			var filepath:String = str(folder, save_file_one_filename)
			filedata = get_file_data(filepath)	
		# ----------------------------
		FILE.SAVE_TWO:
			var filepath:String = str(folder, save_file_two_filename)
			filedata = get_file_data(filepath)	
		# ----------------------------
		FILE.SAVE_THREE:
			var filepath:String = str(folder, save_file_three_filename)
			filedata = get_file_data(filepath)	
		# ----------------------------		
			
	return {
		"filedata": filedata,
		"success": !filedata.is_empty() 
	}
# ---------------------------------		

# ---------------------------------		
func add_savefile_metadata(file_name:String, data:Dictionary) -> Dictionary:
	return {
		"file_name": file_name, 
		"metadata":{
			"modification_date": Time.get_date_dict_from_system()
		},
		"data": data
	}	
	
func compile_data_for_save() -> Dictionary:
	return {}
	
func create_save_file(filepath:String, data:Dictionary) -> bool:
	var results = FileAccess.open(filepath, FileAccess.WRITE)
	if results == null:
		return false		
	results.store_var(data)
	results.close()	
	return true	

func save_file(type:FILE, save_data:Dictionary) -> Dictionary:
	var file_data:Dictionary = {}
	var success:bool = false
	
	match type:
		# ----------------------------
		FILE.QUICK_SAVE:
			var filepath:String = str(folder, quick_save_filename)
			file_data = add_savefile_metadata(quick_save_filename, save_data)
			success = create_save_file(filepath, file_data)
		# ----------------------------
		FILE.SAVE_ONE:
			var filepath:String = str(folder, save_file_two_filename)
			file_data = add_savefile_metadata(save_file_two_filename, save_data)
			success = create_save_file(filepath, file_data)				
		# ----------------------------
		FILE.SAVE_TWO:
			var filepath:String = str(folder, save_file_three_filename)
			file_data = add_savefile_metadata(save_file_three_filename, save_data)
			success = create_save_file(filepath, file_data)				
		# ----------------------------
		FILE.SAVE_THREE:
			var filepath:String = str(folder, quick_save_filename)
			file_data = add_savefile_metadata(quick_save_filename, save_data)
			success = create_save_file(filepath, file_data)			
	
	return {"file_data": file_data, "success": success}
# ---------------------------------		

# ---------------------------------
func show_load_options() -> Dictionary:
	var items = []

	var data_one_image_file_path = str(folder, FileSys.save_config.filenames.save_file_one, save_config.image_ext)
	var data_two_image_file_path = str(folder, FileSys.save_config.filenames.save_file_two, save_config.image_ext)
	var data_three_image_file_path = str(folder, FileSys.save_config.filenames.save_file_three, save_config.image_ext)
		
	if save_file_exist(FILE.QUICK_SAVE):
		var data = load_file(FILE.QUICK_SAVE, true)
		items.push_back({
			"text": str("Load ", FileSys.save_config.pretty_filenames.quick_save), 
			"file": FILE.QUICK_SAVE,
		})		
		
	if save_file_exist(FILE.SAVE_ONE):
		var data = load_file(FILE.SAVE_ONE, true)
		items.push_back({
			"text": str("Load ", FileSys.save_config.pretty_filenames.filesave_one), 
			"file": FILE.SAVE_ONE,
		})
		
	if save_file_exist(FILE.SAVE_TWO):
		var data = load_file(FILE.SAVE_TWO, true)
		items.push_back({
			"text": str("Load ", FileSys.save_config.pretty_filenames.filesave_two), 
			"file": FILE.SAVE_TWO,
		})
		
	if save_file_exist(FILE.SAVE_THREE):
		var data = load_file(FILE.SAVE_THREE, true)
		items.push_back({
			"text": str("Load ", FileSys.save_config.pretty_filenames.filesave_two), 
			"file": FILE.SAVE_THREE,
		})
	
	if items.size() > 0:	
		return {"has_results": true, "items": items}
	else:
		return {"has_results": false, "items": []}
# ---------------------------------

# ---------------------------------
func show_save_options() -> Dictionary:
	var data_one = load_file(FILE.SAVE_ONE, true)
	var data_two = load_file(FILE.SAVE_TWO, true)
	var data_three = load_file(FILE.SAVE_THREE, true)
	
	var data_one_image_file_path = str(folder, FileSys.save_config.filenames.save_file_one, save_config.image_ext)
	var data_two_image_file_path = str(folder, FileSys.save_config.filenames.save_file_two, save_config.image_ext)
	var data_three_image_file_path = str(folder, FileSys.save_config.filenames.save_file_three, save_config.image_ext)
	
	var items = [
		{
			"text": str("Save ", FileSys.save_config.pretty_filenames.filesave_one), 
			"save_name": FileSys.save_config.filenames.save_file_one,
			"file": FILE.SAVE_ONE,
			"file_path": data_one_image_file_path
		},
		{
			"text": str("Save ", FileSys.save_config.pretty_filenames.filesave_two), 
			"save_name": FileSys.save_config.filenames.save_file_two,
			"file": FILE.SAVE_TWO,
			"file_path": data_two_image_file_path
		},
		{
			"text": str("Save ", FileSys.save_config.pretty_filenames.filesave_three), 
			"save_name": FileSys.save_config.filenames.save_file_three,
			"file": FILE.SAVE_THREE,
			"file_path": data_three_image_file_path
		}
	]	
	
	return {"items": items}
# ---------------------------------

# ---------------------------------
#func take_screenshot(save_file_name:String) -> void:
	#var viewport:SubViewport = Global.GameRefNodes.get_ref(System.REF.FINAL_VIEWPORT)
	#var viewport_capture:Image = viewport.get_texture().get_image()
	#var image_size:Vector2 = viewport_capture.get_size()
	#var image_ratio:float = float(image_size.y/image_size.x)
	#viewport_capture.resize(save_config.image_size, save_config.image_size * image_ratio)
	#var file_path = str(folder, save_file_name, save_config.image_ext)
	#viewport_capture.save_png(file_path)
# ---------------------------------
