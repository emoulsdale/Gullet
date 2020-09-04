tool
extends Node

const UTILS := preload("res://addons/gullet/tester/finder.gd")

signal processing_finished
signal test_failed(test_file_path, test_method, failure_string)
signal test_passed(test_file_path, test_method)

var current_test_file_path: String
var current_test_method: String
var excluded_methods := get_excluded_method_names()


func run_test(test_file: Node, test_file_path: String,
		test_method: String) -> void:
    current_test_file_path = test_file_path
    current_test_method = test_method
    funcref(test_file, test_method).call_func()
    yield(self, "processing_finished")


# this must be called every time the base test script is updated!
func get_excluded_method_names() -> Array:
    var base_test_file := preload("res://addons/gullet/test.gd")
    var base_test_file_instance: Node = base_test_file.new()
    var excluded_method_names := get_method_names(base_test_file_instance)
    base_test_file_instance.queue_free()
    return excluded_method_names


func get_method_names(node: Node) -> Array:
	var method_names := []
	for method in node.get_method_list():
		method_names.append(method["name"])
	return method_names


func get_test_methods(test_file: Node) -> Array:
	var test_methods := []
	for script_method in get_method_names(test_file):
		if not excluded_methods.has(script_method):
			test_methods.append(script_method)
	return test_methods


func process_test_result(failure_string: String) -> void:
	if not failure_string:
		emit_signal("test_passed", current_test_file_path,
				current_test_method)
	else:
		emit_signal("test_failed", current_test_file_path, current_test_method,
				failure_string)
	emit_signal("processing_finished")


func run_tests_in_file(test_file_path: String) -> void:
	var test_file: Node = load(test_file_path).new()
	test_file.connect("test_completed", self, "process_test_result")
	for test_method in get_test_methods(test_file):
		run_test(test_file, test_file_path, test_method)
	test_file.disconnect("test_completed", self, "process_test_result")
	test_file.queue_free()


func run_all_tests(test_files_paths: Array) -> void:
	for test_file_path in test_files_paths:
		run_tests_in_file(test_file_path)
