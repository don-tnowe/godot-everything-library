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
	var folder_contents = load_files_in_folder(
		info_res.folder.trim_suffix("/") + "/",
		info_res.flags["Recursive"]
	)
	var flag_nonunique = info_res.flags["Non-unique-keys"]
	var result = {}
	if info_res.key == "":
		result = []
		for x in folder_contents:
			add_to_collection(result, result.size(), x)
			
	elif info_res.key == "resource_path":
		for x in folder_contents:
			add_to_collection(result, x.resource_path.get_file().get_basename(), x, flag_nonunique)
			
	else:
		for x in folder_contents:
			add_to_collection(result, x.get(info_res.key), x, flag_nonunique)
		
	set(info_res.property_in_singleton, result)


func load_files_in_folder(path, recursive = false) -> Array:
	var dir = Directory.new()
	var loaded := []
	dir.open(path)
	dir.list_dir_begin(true)
	while true:
		var item = dir.get_next()
		if item == "": break
		if !dir.current_is_dir():
			loaded.append(load(path + item))

		elif recursive:
			loaded.append_array(load_files_in_folder(path + item + "/", true))

	return loaded


func add_to_collection(collection, key, value, nonunique = false):
	if nonunique:
		if !collection.has(key):
			collection[key] = []

		collection[key].append(value)

	elif collection is Array:
		collection.append(value)
		
	else:
		collection[key] = value
