tool
extends Node

const UTILS := preload("res://addons/gullet/tester/finder.gd")

# TODO prepend "_" to private members

signal processing_finished
signal test_failed(test_file_path, test_method, failure_string)
signal test_passed(test_file_path, test_method)

var _current_test_file_path: String
var _current_test_method: String
var _excluded_methods := _get_excluded_method_names()


func report_pass() -> void:
	emit_signal("test_passed", _current_test_file_path, _current_test_method)
	emit_signal("processing_finished")


func report_failure(failure: String) -> void:
	emit_signal("test_failed", _current_test_file_path, _current_test_method,
			failure)
	emit_signal("processing_finished")


func _run_test(test_file: Node, test_method: String) -> void:
	_current_test_method = test_method
	funcref(test_file, test_method).call_func()
	yield(self, "processing_finished")


# this must be called every time the base test script is updated!
func _get_excluded_method_names() -> Array:
	var base_test_file := preload("res://addons/gullet/test.gd")
	var base_test_file_instance: Node = base_test_file.new()
	var excluded_method_names := _get_method_names(base_test_file_instance)
	base_test_file_instance.queue_free()
	return excluded_method_names


func _get_method_names(node: Node) -> Array:
	var method_names := []
	for method in node.get_method_list():
		method_names.append(method["name"])
	return method_names


func _get_test_methods(test_file: Node) -> Array:
	var test_methods := []
	for script_method in _get_method_names(test_file):
		if not _excluded_methods.has(script_method):
			test_methods.append(script_method)
	return test_methods


func _setup_test_file(test_file_path: String) -> Node:
	var test_file: Node = load(test_file_path).new()
	_current_test_file_path = test_file_path
	test_file.runner = self
	return test_file


func run_tests_in_file(test_file_path: String) -> void:
	var test_file := _setup_test_file(test_file_path)
	for test_method in _get_test_methods(test_file):
		_run_test(test_file, test_method)
	test_file.queue_free()


func run_all_tests(test_files_paths: Array) -> void:
	for test_file_path in test_files_paths:
		run_tests_in_file(test_file_path)
