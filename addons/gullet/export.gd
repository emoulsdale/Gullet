tool
extends EditorExportPlugin

const root_test_dir = "res://test"


func open_test_dir(test_dir_path: String) -> Directory:
	var test_dir := Directory.new()
	test_dir.open(test_dir_path)
	return test_dir


func process_elements(test_dir: Directory, test_dir_path: String, test_paths: Array) -> Array:
	while true:
		var element := test_dir.get_next()
		if not element:
			break
		var element_path := "%s/%s" % [test_dir_path, element]
		if test_dir.current_is_dir():
			test_paths = get_tests_in_dir(element_path, test_paths.duplicate())
		else:
			test_paths.append(element_path)
	return test_paths


func get_tests_in_dir(test_dir_path: String, test_paths: Array) -> Array:
	var test_dir := open_test_dir(test_dir_path)
	test_dir.list_dir_begin(true, true)
	test_paths += process_elements(test_dir, test_dir_path, test_paths.duplicate())
	test_dir.list_dir_end()
	return test_paths

func get_tests() -> Array:
	var test_paths := get_tests_in_dir(root_test_dir, [])
	return test_paths


func add_test(test_path: String) -> void:
	var pool_byte_array := PoolByteArray()
	add_file(test_path, pool_byte_array, false)


func add_tests() -> void:
	var test_paths := get_tests()
	print("Found %d tests." % len(test_paths))
	for test_path in test_paths:
		add_test(test_path)


func _export_begin(_features: PoolStringArray, is_debug: bool, _path: String, _flags: int) -> void:
	if is_debug:
		add_tests()


func _export_end() -> void:
	pass
