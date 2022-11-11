tool
extends AcceptDialog

const path_visible_characters := 25

export var item_scene : PackedScene

onready var dim_bg = $"BG"

var resources := []


func display(arg = null):
	dim_bg.show()
	if has_node("BG"):
		remove_child(dim_bg)
		get_parent().add_child(dim_bg)
		dim_bg.rect_size = get_viewport_rect().size
		dim_bg.rect_global_position = Vector2.ZERO

	show_modal(true)
	resources = []
	for x in $"%Folders".get_children():
		x.free()

	var dir = Directory.new()
	dir.open("res://addons/everything_library")
	dir.list_dir_begin(true)
	while true:
		var item = dir.get_next()
		if item == "": break
		if item.ends_with(".tres"):
			resources.append(load("res://addons/everything_library/" + item))

	for x in resources:
		create_list_item(x)


func create_list_item(res):
	var new_item = item_scene.instance()
	$"%Folders".add_child(new_item)

	if res.folder != "":
		new_item.get_node("Path").text = res.folder.right(res.folder.length() - path_visible_characters)
	
	else:
		new_item.get_node("Path").text = "Click to select..."

	new_item.get_node("Property").text = res.property_in_singleton
	new_item.get_node("Key").text = res.key

	new_item.get_node("Path").connect("pressed", self, "_on_item_path_pressed", [new_item, res])
	new_item.get_node("Property").connect("text_changed", self, "_on_item_property_changed", [new_item, res])
	new_item.get_node("Key").connect("text_changed", self, "_on_item_key_changed", [new_item, res])
	new_item.get_node("Remove").connect("pressed", self, "_on_item_removed", [new_item, res])
	for x in new_item.get_node("Flags").get_children():
		x.pressed = res.flags.get(x.name, false)
		x.connect("toggled", self, "_on_flag_toggled", [x.name, new_item, res])


func save_res(res):
	if res.resource_path == "":
		var file = File.new()
		while true:
			res.resource_path = "res://addons/everything_library/folder_" + Color(randi()).to_html() + ".tres"
			if !file.file_exists(res.resource_path):
				break
	
	ResourceSaver.save(res.resource_path, res)


func _on_item_path_pressed(item, res):
	$"FileDialog".show_modal()
	$"FileDialog".invalidate()
	$"FileDialog".connect("dir_selected", self, "_on_path_selected", [item, res])


func _on_path_selected(path, item, res):
	$"FileDialog".disconnect("dir_selected", self, "_on_path_selected")

	res.folder = path
	var foldername = path.substr(path.rfind("/", -2) + 1)
	item.get_node("Path").text = path.right(path.length() - path_visible_characters)
	if res.property_in_singleton == "":
		_on_item_property_changed(foldername.to_lower(), item, res)
		item.get_node("Property").text = res.property_in_singleton
	
	save_res(res)


func _on_item_property_changed(value, item, res):
	res.property_in_singleton = value
	var autoload_script = load("res://addons/everything_library/src/autoload.gd")
	var code = autoload_script.source_code
	code = (
		code.left(code.find("# Properties start\n"))
		+ "# Properties start\n"
		+ get_properties_code()
		+ code.substr(code.find("# Properties end\n"))
	)
	autoload_script.source_code = code
	ResourceSaver.save(autoload_script.resource_path, autoload_script)
	save_res(res)


func get_properties_code():
	var result = ""
	for x in resources:
		result += "var " + x.property_in_singleton + "\n"

	return result


func _on_item_key_changed(value, item, res):
	res.key = value
	save_res(res)


func _on_flag_toggled(toggled, flag, item, res):
	res.flags[flag] = toggled


func _on_item_removed(item, res):
	resources.erase(res)
	item.queue_free()
	var dir = Directory.new()
	dir.remove(res.resource_path)


func _on_AddFolder_pressed():
	var new_res = EverythingLibraryImport.new()
	resources.append(new_res)
	create_list_item(new_res)
