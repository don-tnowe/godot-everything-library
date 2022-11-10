tool
extends EditorPlugin

var dialog = preload("res://addons/everything_library/src/startup.tscn").instance()


func _enter_tree():
	get_editor_interface().get_base_control().add_child(dialog)
	_show_start()
	add_autoload_singleton("Library", "res://addons/everything_library/src/autoload.gd")
	add_tool_menu_item("Manage Everything Library...", dialog, "display")


func _show_start():
	var dir = Directory.new()
	dir.open("res://addons/everything_library")
	dir.list_dir_begin(true)
	while true:
		var item = dir.get_next()
		if item == "": break
		if item.ends_with(".tres"):
			dir.list_dir_end()
			return

	dialog.display()


func _exit_tree():
	dialog.free()
	remove_autoload_singleton("Library")
	remove_tool_menu_item("Manage Everything Library...")
