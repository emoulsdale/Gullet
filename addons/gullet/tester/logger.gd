tool
extends Node

var test_results := {}
var _formatter: Node
var testing_failed := false

enum TestResult {
	PASS,
	FAIL
}


func reset_log() -> void:
	test_results = {}


func _add_test_method_result(test_file_path: String, test_method: String,
		test_result: int) -> void:
	if not test_results.has(test_file_path):
		test_results[test_file_path] = {test_method : test_result}
	else:
		test_results[test_file_path][test_method] = test_result


func log_failure(test_file_path: String, test_method: String,
		_failure_string: String) -> void:
	testing_failed = true
	_add_test_method_result(test_file_path, test_method, TestResult.FAIL)


func log_pass(test_file_path: String, test_method: String) -> void:
	_add_test_method_result(test_file_path, test_method, TestResult.PASS)
