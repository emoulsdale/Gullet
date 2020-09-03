tool
extends Node

const TESTS = [IntegrationTest, UnitTest]

signal processing_finished
signal test_failed(test_file_path, test_method, failure_string)
signal test_succeeded(test_file_path, test_method)

var current_test_file_path: String
var current_test_method: String


func run_test(test_file: Node, test_file_path: String,
		test_method: String) -> void:
	current_test_file_path = test_file_path
	current_test_method = test_method
	funcref(test_file, test_method).call_func()
	yield(self, "processing_finished")


func get_method_names(node: Node) -> Array:
	var method_names := []
	for method in node.get_method_list():
		method_names.append(method["name"])
	return method_names


func get_test_methods(test_file: Node, extended_test: Node) -> Array:
	var test_methods := []
	var excluded_methods := get_method_names(extended_test)
	for script_method in get_method_names(test_file):
		if not excluded_methods.has(script_method):
			test_methods.append(script_method)
	return test_methods


func process_test_result(failure_string: String) -> void:
	if not failure_string:
		emit_signal("test_succeeded", current_test_file_path,
				current_test_method)
	else:
		emit_signal("test_failed", current_test_file_path, current_test_method,
				failure_string)
	emit_signal("processing_finished")


func run_tests_in_file(test_file_path: String, extended_test: Node) -> void:
	var test_file = load(test_file_path).new()
	test_file.connect("test_completed", self, "process_test_result")
	for test_method in get_test_methods(test_file, extended_test):
		run_test(test_file, test_file_path, test_method)
	test_file.disconnect("test_completed", self, "process_test_result")
	test_file.queue_free()


func run_all_tests(test_file_paths: Array) -> void:
	var unit_test_instance := UnitTest.new()
	run_tests_in_file("res://test/unit/unit.gd", unit_test_instance)
	unit_test_instance.queue_free()
