tool
extends Node

var runner: Node
var logger: Node


func setup_runner() -> void:
	runner = preload("runner.gd").new()
	add_child(runner)


func setup_logger() -> void:
	logger = preload("logger.gd").new()
	runner.connect("test_failed", logger, "log_failure")
	runner.connect("test_succeeded", logger, "log_success")
	add_child(logger)


func _init() -> void:
	setup_runner()
	setup_logger()


func dispose_logger() -> void:
	runner.disconnect("test_failed", logger, "log_failure")
	runner.disconnect("test_succeeded", logger, "log_success")
	logger.queue_free()


func _exit_tree() -> void:
	if logger:
		dispose_logger()
	if runner:
		runner.queue_free()


func run_all_tests() -> void:
	var utils: Reference = preload("res://addons/gullet/utils.gd")
	var test_files: Array = utils.get_test_files()
	runner.run_all_tests(test_files)
