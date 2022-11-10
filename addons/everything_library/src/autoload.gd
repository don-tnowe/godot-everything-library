extends Node

# Properties start
var items
# Properties end

func _ready():
	var folder_info = load_files_in_folder("res://addons/everything_library/")
	for x in folder_info:
		load_folder_collection(x)


func load_folder_collection(info_res):
	if info_res == null: return  # Happens.
	var folder_contents = load_files_in_folder(info_res.folder.trim_suffix("/") + "/")
	var result = {}
	if info_res.key == "":
		result = []
		for x in folder_contents:
			result.append(x)
			
	elif info_res.key == "resource_path":
		for x in folder_contents:
			result[x.resource_path.get_file().get_basename()] = x
			
	else:
		for x in folder_contents:
			result[x.get(info_res.key)] = x
		
	set(info_res.property_in_singleton, result)


func load_files_in_folder(path) -> Array:
	var dir = Directory.new()
	var loaded := []
	dir.open(path)
	dir.list_dir_begin(true)
	while true:
		var item = dir.get_next()
		if item == "": break
		if item.is_valid_filename():
			loaded.append(load(path + item))

	return loaded
