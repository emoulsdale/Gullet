tool
extends Node

const FINDER = preload("res://addons/gullet/tester/finder.gd")

signal processing_finished
signal test_failed(test_file_path, test_method, failure_string)
signal test_passed(test_file_path, test_method)

var _current_test_file_path: String
var _current_test_method: String


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


func _setup_test_file(test_file_path: String) -> Node:
	var test_file: Node = load(test_file_path).new()
	_current_test_file_path = test_file_path
	test_file.runner = self
	return test_file


func _run_tests_in_file(test_file_path: String) -> void:
	var test_file := _setup_test_file(test_file_path)
	for test_method in FINDER.get_test_methods_in_file(test_file):
		_run_test(test_file, test_method)
	test_file.queue_free()


func run_all_tests() -> void:
	# TODO make this method yield to a signal that the logger has
	# finished (i.e. stopped due to failure, or passed all tests)
	var test_file_paths := FINDER.get_test_file_paths()
	for test_file_path in test_file_paths:
		_run_tests_in_file(test_file_path)
