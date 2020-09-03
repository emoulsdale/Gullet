tool
extends Node

var test_results: Dictionary = {}

enum TestResult {
	SUCCESS,
	FAILURE
}


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
	add_test_method_result(test_file_path, test_method, TestResult.FAILURE)
	print("FAILED - Test method '%s' of file '%s': %s" % [
		test_method,
		test_file_path,
		failure_string
	])


func log_success(test_file_path: String, test_method: String) -> void:
	add_test_method_result(test_file_path, test_method, TestResult.SUCCESS)
	print("PASSED - Test method '%s' of file '%s'" % [
		test_method,
		test_file_path
	])
