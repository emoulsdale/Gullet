tool
extends EditorPlugin

var export_plugin: EditorExportPlugin


func setup_export_plugin() -> void:
	export_plugin = preload("export.gd").new()
	add_export_plugin(export_plugin)


func _enter_tree() -> void:
	setup_export_plugin()


func _exit_tree() -> void:
	remove_export_plugin(export_plugin)


func has_main_screen() -> bool:
	return true


func make_visible(visible) -> void:
	pass


func get_plugin_name() -> String:
	return "Test"


func get_plugin_icon() -> Texture:
	return get_editor_interface().get_base_control().get_icon("Node",
			"EditorIcons")
