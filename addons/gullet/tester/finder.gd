tool

const ROOT_TEST_DIR = "res://test"
const BASE_TEST_FILE = preload("res://addons/gullet/test.gd")


static func _open_test_dir(test_dir_path: String) -> Directory:
	var test_dir := Directory.new()
	test_dir.open(test_dir_path)
	return test_dir


static func _script_method_is_test_method(script_method: String,
		excluded_method_names: Array) -> bool:
	var script_method_is_excluded := excluded_method_names.has(script_method)
	var script_method_starts_with_test := script_method.begins_with("test")
	return !script_method_is_excluded && script_method_starts_with_test


static func get_test_methods_in_file(test_file: Node) -> Array:
	var test_methods := []
	# TODO - below is very inefficient, as it is called for every test file
	var excluded_method_names := _get_excluded_method_names()
	for script_method in _get_method_names(test_file):
		if _script_method_is_test_method(script_method, excluded_method_names):
			test_methods.append(script_method)
	return test_methods


static func _get_excluded_method_names() -> Array:
	var base_test_file_instance: Node = BASE_TEST_FILE.new()
	var excluded_method_names := _get_method_names(base_test_file_instance)
	base_test_file_instance.queue_free()
	return excluded_method_names


static func _get_method_names(node: Node) -> Array:
	var method_names := []
	for method in node.get_method_list():
		method_names.append(method["name"])
	return method_names


static func _is_test_file(file_path: String) -> bool:
	var test_file = load(file_path).new()
	var is_test_file := (test_file is BASE_TEST_FILE)
	test_file.queue_free()
	return is_test_file


static func _process_element(element: String, test_dir: Directory,
		test_dir_path: String, test_file_paths: Array) -> void:
	var element_path := "%s/%s" % [test_dir_path, element]
	if test_dir.current_is_dir():
		_get_test_files_in_dir(element_path, test_file_paths)
	else:
		if _is_test_file(element_path):
			test_file_paths.append(element_path)
		


static func _process_elements(test_dir: Directory, test_dir_path: String,
		test_file_paths: Array) -> void:
	while true:
		var element := test_dir.get_next()
		if not element:
			break
		_process_element(element, test_dir, test_dir_path, test_file_paths)


static func _get_test_files_in_dir(test_dir_path: String,
		test_file_paths: Array) -> void:
	var test_dir := _open_test_dir(test_dir_path)
	test_dir.list_dir_begin(true, true)
	_process_elements(test_dir, test_dir_path, test_file_paths)
	test_dir.list_dir_end()


static func get_test_file_paths() -> Array:
	var test_file_paths := []
	_get_test_files_in_dir(ROOT_TEST_DIR, test_file_paths)
	return test_file_paths
