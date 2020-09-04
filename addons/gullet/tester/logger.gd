tool
extends Node

var test_results: Dictionary = {}
var printer: Node
var testing_failed := false

enum TestResult {
	SUCCESS,
	FAILURE
}


func _init() -> void:
	# TODO refactor to use dependency injection
	printer = preload("res://addons/gullet/tester/printer.gd").new()


func dispose() -> void:
	printer.queue_free()


func reset_log() -> void:
	test_results = {}


func add_test_method_result(test_file_path: String, test_method: String,
		test_result: int) -> void:
	if not test_results.has(test_file_path):
		test_results[test_file_path] = {test_method : test_result}
	else:
		test_results[test_file_path][test_method] = test_result


func log_failure(test_file_path: String, test_method: String,
		failure_string: String) -> void:
	testing_failed = true
	add_test_method_result(test_file_path, test_method, TestResult.FAILURE)
	printer.print_failure(test_file_path, test_method, failure_string)



func log_success(test_file_path: String, test_method: String) -> void:
	add_test_method_result(test_file_path, test_method, TestResult.SUCCESS)
	printer.print_success(test_file_path, test_method)
