tool
extends EditorExportPlugin


func _add_test_file(test_path: String) -> void:
	var pool_byte_array := PoolByteArray()
	add_file(test_path, pool_byte_array, false)


func _add_test_files() -> void:
	# TODO refactor this using dependency injection, i.e. NO hard coding
    var test_finder := preload("res://addons/gullet/tester/finder.gd")
    var test_file_paths: Array = test_finder.get_test_files()
    for test_path in test_file_paths:
        _add_test_file(test_path)


func _export_begin(_features: PoolStringArray, is_debug: bool, _path: String,
		_flags: int) -> void:
	if is_debug:
		_add_test_files()
