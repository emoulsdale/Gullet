tool
extends EditorExportPlugin

const utils = preload("res://addons/gullet/utils.gd") 


func add_test_file(test_path: String) -> void:
	var pool_byte_array := PoolByteArray()
	add_file(test_path, pool_byte_array, false)


func add_test_files() -> void:
	var test_file_paths: Array = utils.get_test_files()
	print("Found %d test files." % len(test_file_paths))
	for test_path in test_file_paths:
		add_test_file(test_path)


func _export_begin(_features: PoolStringArray, is_debug: bool, _path: String,
		_flags: int) -> void:
	if is_debug:
		add_test_files()
