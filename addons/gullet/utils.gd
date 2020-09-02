tool

const root_test_dir = "res://test"


static func open_test_dir(test_dir_path: String) -> Directory:
	var test_dir := Directory.new()
	test_dir.open(test_dir_path)
	return test_dir


static func process_element(element: String, test_dir: Directory,
		test_dir_path: String, test_file_paths: Array) -> void:
	var element_path := "%s/%s" % [test_dir_path, element]
	if test_dir.current_is_dir():
		get_test_files_in_dir(element_path, test_file_paths)
	else:
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


static func get_test_files() -> Array:
	var test_file_paths := []
	get_test_files_in_dir(root_test_dir, test_file_paths)
	return test_file_paths
