tool
extends Node

var _runner: Node
var _logger: Node


func _setup_runner() -> void:
	_runner = preload("runner.gd").new()
	add_child(_runner)


func _setup_logger() -> void:
	_logger = preload("logger.gd").new()
	_runner.connect("test_failed", _logger, "log_failure")
	_runner.connect("test_passed", _logger, "log_pass")
	add_child(_logger)


func _init() -> void:
	_setup_runner()
	_setup_logger()


func _dispose_logger() -> void:
	_runner.disconnect("test_failed", _logger, "log_failure")
	_runner.disconnect("test_passed", _logger, "log_pass")
	_logger.dispose()
	_logger.queue_free()


func dispose() -> void:
	if _logger:
		_dispose_logger()
	if _runner:
		_runner.queue_free()


func _exit_tree() -> void:
	dispose()
	

func run_all_tests() -> bool:
	_runner.run_all_tests()
	return _logger.testing_failed
