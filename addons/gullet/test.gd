extends Node

# TODO refactor order of members to be consistent with gdscript guidelines
var runner: Node

# TODO refactor to use xUnit classnames


func report_pass() -> void:
	# TODO should this _if_ statement be here?
	if runner:
		runner.report_pass()


func report_failure(failure: String) -> void:
	if runner:
		runner.report_failure(failure)


func assert_eq(int1: int, int2: int) -> void:
	if int1 == int2:
		report_pass()
	else:
		var failure_format := "The provided integers (%d, %d) are not equal"
		report_failure(failure_format % [int1, int2])
