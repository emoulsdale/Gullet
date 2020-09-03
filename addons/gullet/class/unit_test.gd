class_name UnitTest
extends "res://addons/gullet/class/base_test.gd"


func assert_eq(int1: int, int2: int) -> void:
	if int1 == int2:
		emit_signal("test_completed", "")
	var failure_format := "The provided integers (%d, %d) are not equal"
	emit_signal("test_completed", failure_format % [int1, int2])
