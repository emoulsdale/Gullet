tool

const ROOT_TEST_DIR = "res://test"
const BASE_TEST_FILE = preload("res://addons/gullet/test.gd")


static func open_test_dir(test_dir_path: String) -> Directory:
	var test_dir := Directory.new()
	test_dir.open(test_dir_path)
	return test_dir


static func is_test_file(file_path: String) -> bool:
	var test_file = load(file_path).new()
	var is_test_file := (test_file is BASE_TEST_FILE)
	test_file.queue_free()
	return is_test_file


static func process_element(element: String, test_dir: Directory,
		test_dir_path: String, test_file_paths: Array) -> void:
	var element_path := "%s/%s" % [test_dir_path, element]
	if test_dir.current_is_dir():
		get_test_files_in_dir(element_path, test_file_paths)
	else:
		if is_test_file(element_path):
			test_file_paths.append(element_path)
		


static func process_elements(test_dir: Directory, test_dir_path: String,
		test_file_paths: Array) -> void:
	while true:
		var element := test_dir.get_next()
		if not element:
			break
		process_element(element, test_dir, test_dir_path, test_file_paths)


static func get_test_files_in_dir(test_dir_path: String,
		test_file_paths: Array) -> void:
	var test_dir := open_test_dir(test_dir_path)
	test_dir.list_dir_begin(true, true)
	process_elements(test_dir, test_dir_path, test_file_paths)
	test_dir.list_dir_end()


static func get_test_file_paths() -> Array:
	var test_file_paths := []
	get_test_files_in_dir(ROOT_TEST_DIR, test_file_paths)
	return test_file_paths
