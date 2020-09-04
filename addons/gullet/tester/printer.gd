tool
extends Node

const FAILURE_ANSI_COLOR = "[1;31m"
const PASS_ANSI_COLOR = "[1;32m"
const INFO_ANSI_COLOR = "[1;33m"
const RESET_ANSI_COLOR = "[1;0m"

var escape_string := PoolByteArray([0x1b]).get_string_from_ascii()
var failure_notice := "%s%sFAIL%s%s" % [
    escape_string,
    FAILURE_ANSI_COLOR,
    escape_string,
    RESET_ANSI_COLOR,
]
var pass_notice := "%s%sPASS%s%s" % [
    escape_string,
    PASS_ANSI_COLOR,
    escape_string,
    RESET_ANSI_COLOR,
]
var info_start := "%s%s" % [
    escape_string,
    INFO_ANSI_COLOR,
]
var info_end := "%s%s" % [
    escape_string,
    RESET_ANSI_COLOR
]


func print_failure(test_file_path: String, test_method: String,
failure_string: String) -> void:
    print("%s -> '%s' of '%s': %s%s%s" % [
        failure_notice,
        test_method,
        test_file_path,
        info_start,
        failure_string,
        info_end,
    ])


func print_pass(test_file_path: String, test_method: String) -> void:
    print("%s -> '%s' of '%s'" % [
        pass_notice,
		test_method,
		test_file_path,
	])
