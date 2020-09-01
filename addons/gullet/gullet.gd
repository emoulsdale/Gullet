tool
extends EditorPlugin

const config_path = "res://gullet.json"
var config: Dictionary

func read_config_file() -> String:
	var config_file := File.new()
	config_file.open(config_path, File.READ)
	var json_string := config_file.get_as_text()
	config_file.close()
	return json_string


func get_json_parse_result(json_string: String) -> JSONParseResult:
	var json_parse_result := JSON.parse(json_string)
	return json_parse_result


func check_json_parse_result(json_parse_result: JSONParseResult) -> void:
	if json_parse_result.error != OK:
		push_error(json_parse_result.error_string)


func get_config() -> Dictionary:
	var json_string := read_config_file()
	var json_parse_result := get_json_parse_result(json_string)
	check_json_parse_result(json_parse_result)
	return json_parse_result.result as Dictionary


func setup_export_plugin() -> void:
	var export_plugin: EditorExportPlugin = preload("export.gd").new()
	export_plugin.config = config
	add_export_plugin(export_plugin)


func _enter_tree() -> void:
	config = get_config()
	setup_export_plugin()


func _exit_tree() -> void:
	pass


func has_main_screen() -> bool:
	return true


func make_visible(visible) -> void:
	pass


func get_plugin_name() -> String:
	return "Test"


func get_plugin_icon() -> Texture:
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
