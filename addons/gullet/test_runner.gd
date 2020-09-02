tool
extends Node


func run_test(test_file: Node, test_method: String) -> void:
	print("Test method %s:" % test_method)
	funcref(test_file, test_method).call_func()
	yield(test_file, "test_completed")


func get_script_methods(script_file: Node) -> Array:
	var script_methods := []
	for script_method in script_file.get_script().get_script_method_list():
		script_methods.append(script_method["name"])
	return script_methods


func get_excluded_script_methods() -> Array:
	var test_utility_file: Node = preload("test.gd").new()
	var excluded_script_methods := get_script_methods(test_utility_file)
	test_utility_file.queue_free()
	return excluded_script_methods


func get_test_methods(test_file: Node) -> Array:
	var test_methods := []
	var excluded_script_methods := get_excluded_script_methods()
	for script_method in get_script_methods(test_file):
		if not excluded_script_methods.has(script_method):
			test_methods.append(script_method)
	return test_methods


func process_test_result(failure_string: String) -> void:
	if not failure_string:
		print("Passed.")
	else:
		print("Failed: %s." % failure_string)


func run_tests_in_file(test_file_path: String) -> void:
	var test_file: Node = load(test_file_path).new()
	add_child(test_file)
	#var test_file_node := get_node("TestFile")
	test_file.connect("test_completed", self, "process_test_result")
	print("Test file: %s" % test_file_path)
	for test_method in get_test_methods(test_file):
		run_test(test_file, test_method)
	test_file.disconnect("test_completed", self, "process_test_result")
	remove_child(test_file)
	test_file.queue_free()
	print()


func run_all_tests(test_file_paths: Array) -> void:
	run_tests_in_file("res://test/unit/unit.gd")
