extends Node

enum FILE {
	USER_PROFILE, SAVE_ONE, SAVE_TWO, SAVE_THREE, PROGRESS, SETTINGS, PERSISTANT, QUICK_SAVE, 
}

const save_config:Dictionary = {
	"folder": "user://",
	"image_ext": ".png",
	"image_size": 400,
	"pretty_filenames": {
		"user_profile": "User Profile",
		"progress": "Progress",		
		"settings": "Settings",
		"persistant": "Persistant",
		"quick_save": "Quicksave",
		"filesave_one": "File 1",
		"filesave_two": "File 2",
		"filesave_three": "File 3"
	},
	"filenames": {
		"user_profile": "USERPROFILE",
		"progress": "PROGRESS",
		"settings": "SETTINGS",
		"persistant": "PERSISTANT",
		"quicksave": "SAVE_QUICKSAVE",
		"save_file_one": "SAVE_01",
		"save_file_two": "SAVE_02",
		"save_file_three": "SAVE_03",		
		
	}
}

const folder:String = save_config.folder
const user_profile_filename:String = save_config.filenames.user_profile

const progress_filename:String = save_config.filenames.progress
const settings_filename:String = save_config.filenames.settings
const persistant_filename:String = save_config.filenames.persistant
const quick_save_filename:String = save_config.filenames.quicksave
const save_file_one_filename:String = save_config.filenames.save_file_one
const save_file_two_filename:String = save_config.filenames.save_file_two
const save_file_three_filename:String = save_config.filenames.save_file_three


# SCHEMAS
const progress_save_schema:Dictionary = {
	"story_progress_val": 0,
	"current_progress_val": -1,
	"quicksave_snapshots": {}
}


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
		FILE.PROGRESS:
			filepath = str(folder, progress_filename)
		# ----------------------------
		FILE.SETTINGS:
			filepath = str(folder, settings_filename)
		# ----------------------------
		FILE.PERSISTANT:
			filepath = str(folder, persistant_filename)
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
func get_file_data(filepath:String) -> Dictionary:
	var filedata:Dictionary = {}
	if FileAccess.file_exists(filepath):
		var results = FileAccess.open(filepath, FileAccess.READ)
		filedata = results.get_var()
		results.close()		
	return filedata

func load_file(type:FILE) -> Dictionary:
	var data:Dictionary = {}
	var filedata:Dictionary = {}
	
	match type:
		# ----------------------------
		FILE.USER_PROFILE:
			var filepath:String = str(folder, user_profile_filename)
			filedata = get_file_data(filepath)		
		# ----------------------------
		FILE.PROGRESS:
			var filepath:String = str(folder, progress_filename)
			filedata = get_file_data(filepath)
		# ----------------------------
		FILE.SETTINGS:
			var filepath:String = str(folder, settings_filename)
			filedata = get_file_data(filepath)			
		# ----------------------------
		FILE.PERSISTANT:
			var filepath:String = str(folder, persistant_filename)
			filedata = get_file_data(filepath)
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
		FILE.USER_PROFILE:
			var filepath:String = str(folder, user_profile_filename)
			file_data = add_savefile_metadata(user_profile_filename, save_data)
			success = create_save_file(filepath, file_data)
			if success:
				print("USERPROFILE file save success!")
			else:
				print("USERPROFILE file save failed...")
		# ----------------------------
		FILE.PROGRESS:
			var filepath:String = str(folder, progress_filename)
			file_data = add_savefile_metadata(progress_filename, save_data)
			success = create_save_file(filepath, file_data)
			if success:
				print("PROGRESS file save success!")
			else:
				print("PROGRESS file save failed...")		
		# ----------------------------
		FILE.SETTINGS:
			var filepath:String = str(folder, settings_filename)
			file_data = add_savefile_metadata(settings_filename, save_data)
			success = create_save_file(filepath, file_data)
			if success:
				print("SETTINGS file save success!")
			else:
				print("SETTINGS file save failed...")
		# ----------------------------
		FILE.PERSISTANT:
			var filepath:String = str(folder, persistant_filename)
			file_data = add_savefile_metadata(persistant_filename, save_data)
			success = create_save_file(filepath, file_data)
			if success:
				print("PERSISTANT file save success!")
			else:
				print("PERSISTANT file save failed...")			
		# ----------------------------
		FILE.QUICK_SAVE:
			var filepath:String = str(folder, quick_save_filename)
			file_data = add_savefile_metadata(quick_save_filename, save_data)
			success = create_save_file(filepath, file_data)
			if success:
				print("QUICK_SAVE file save success!")
			else:
				print("QUICK_SAVE file save failed...")
		# ----------------------------
		FILE.SAVE_ONE:
			var filepath:String = str(folder, save_file_two_filename)
			file_data = add_savefile_metadata(save_file_two_filename, save_data)
			success = create_save_file(filepath, file_data)
			if success:
				print("SAVE_ONE file save success!")
			else:
				print("SAVE_ONE file save failed...")
		# ----------------------------
		FILE.SAVE_TWO:
			var filepath:String = str(folder, save_file_three_filename)
			file_data = add_savefile_metadata(save_file_three_filename, save_data)
			success = create_save_file(filepath, file_data)
			if success:
				print("SAVE_TWO file save success!")
			else:
				print("SAVE_TWO file save failed...")
		# ----------------------------
		FILE.SAVE_THREE:
			var filepath:String = str(folder, quick_save_filename)
			file_data = add_savefile_metadata(quick_save_filename, save_data)
			success = create_save_file(filepath, file_data)
			if success:
				print("SAVE_THREE file save success!")
			else:
				print("SAVE_THREE file save failed...")
	
	return {"file_data": file_data, "success": success}
# ---------------------------------		

# ---------------------------------
func show_load_options() -> Dictionary:
	var items := []

	var data_one_image_file_path := str(folder, FS.save_config.filenames.save_file_one, save_config.image_ext)
	var data_two_image_file_path := str(folder, FS.save_config.filenames.save_file_two, save_config.image_ext)
	var data_three_image_file_path := str(folder, FS.save_config.filenames.save_file_three, save_config.image_ext)
		
	if save_file_exist(FILE.QUICK_SAVE):
		var data:Dictionary = load_file(FILE.QUICK_SAVE)
		items.push_back({
			"text": str("Load ", FS.save_config.pretty_filenames.quick_save), 
			"file": FILE.QUICK_SAVE,
		})		
		
	if save_file_exist(FILE.SAVE_ONE):
		var data:Dictionary = load_file(FILE.SAVE_ONE)
		items.push_back({
			"text": str("Load ", FS.save_config.pretty_filenames.filesave_one), 
			"file": FILE.SAVE_ONE,
		})
		
	if save_file_exist(FILE.SAVE_TWO):
		var data:Dictionary = load_file(FILE.SAVE_TWO)
		items.push_back({
			"text": str("Load ", FS.save_config.pretty_filenames.filesave_two), 
			"file": FILE.SAVE_TWO,
		})
		
	if save_file_exist(FILE.SAVE_THREE):
		var data:Dictionary = load_file(FILE.SAVE_THREE)
		items.push_back({
			"text": str("Load ", FS.save_config.pretty_filenames.filesave_two), 
			"file": FILE.SAVE_THREE,
		})
	
	if items.size() > 0:	
		return {"has_results": true, "items": items}
	else:
		return {"has_results": false, "items": []}
# ---------------------------------

# ---------------------------------
func clear_file(type:FILE) -> Dictionary:
	var filepath:String 
	var success:bool = false
	var dir = DirAccess.open(save_config.folder)
	
	match type:
		FILE.USER_PROFILE:
			filepath = str(folder, user_profile_filename)			
		# ----------------------------
		FILE.SETTINGS:
			filepath = str(folder, settings_filename)
		# ----------------------------
		FILE.PERSISTANT:
			filepath = str(folder, persistant_filename)
		# ----------------------------
		FILE.QUICK_SAVE:
			filepath = str(folder, quick_save_filename)
		# ----------------------------
		FILE.SAVE_ONE:
			filepath = str(folder, save_file_two_filename)
		# ----------------------------
		FILE.SAVE_TWO:
			filepath = str(folder, save_file_three_filename)
		# ----------------------------
		FILE.SAVE_THREE:
			filepath = str(folder, quick_save_filename)
	

	return {"success": success}
# ---------------------------------


# ---------------------------------
func show_save_options() -> Dictionary:
	var data_one:Dictionary = load_file(FILE.SAVE_ONE)
	var data_two:Dictionary = load_file(FILE.SAVE_TWO)
	var data_three:Dictionary = load_file(FILE.SAVE_THREE)
	
	var data_one_image_file_path := str(folder, FS.save_config.filenames.save_file_one, save_config.image_ext)
	var data_two_image_file_path := str(folder, FS.save_config.filenames.save_file_two, save_config.image_ext)
	var data_three_image_file_path := str(folder, FS.save_config.filenames.save_file_three, save_config.image_ext)
	
	var items:Array = [
		{
			"text": str("Save ", FS.save_config.pretty_filenames.filesave_one), 
			"save_name": FS.save_config.filenames.save_file_one,
			"file": FILE.SAVE_ONE,
			"file_path": data_one_image_file_path
		},
		{
			"text": str("Save ", FS.save_config.pretty_filenames.filesave_two), 
			"save_name": FS.save_config.filenames.save_file_two,
			"file": FILE.SAVE_TWO,
			"file_path": data_two_image_file_path
		},
		{
			"text": str("Save ", FS.save_config.pretty_filenames.filesave_three), 
			"save_name": FS.save_config.filenames.save_file_three,
			"file": FILE.SAVE_THREE,
			"file_path": data_three_image_file_path
		}
	]	
	
	return {"items": items}
# ---------------------------------
