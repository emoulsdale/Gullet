extends "res://addons/gullet/test.gd"


# this should fail
func test_int_addition() -> void:
	assert_eq(1, 1 + 1)
