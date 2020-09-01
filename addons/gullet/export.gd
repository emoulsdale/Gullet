tool
extends EditorExportPlugin

var config: Dictionary


func find_tests() -> Array:
	var test_dirs: Array = config["test_dirs"]
	for dir in test_dirs:
		print(dir)
	return []


func add_tests() -> void:
	print("Debug export, adding tests...")
	var tests := find_tests()
	var pool_byte_array := PoolByteArray()
	add_file("res//test/unit.gd", pool_byte_array, false)


func _export_begin(_features: PoolStringArray, is_debug: bool, _path: String, _flags: int) -> void:
	if is_debug:
		add_tests()


func _export_end() -> void:
	pass
