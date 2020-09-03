tool
extends Node

const FAILURE_ANSI_COLOR = "[1;31m"
const SUCCESS_ANSI_COLOR = "[1;32m"
const INFO_ANSI_COLOR = "[1;33m"
const RESET_ANSI_COLOR = "[1;0m"

var escape_string := PoolByteArray([0x1b]).get_string_from_ascii()
var failure_start := "%s%sFAILURE%s%s" % [
    escape_string,
    FAILURE_ANSI_COLOR,
    escape_string,
    RESET_ANSI_COLOR,
]
var success_start := "%s%sSUCCESS%s%s" % [
    escape_string,
    SUCCESS_ANSI_COLOR,
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
        failure_start,
        test_method,
        test_file_path,
        info_start,
        failure_string,
        info_end,
    ])


# TODO rename success->pass in everything!
func print_success(test_file_path: String, test_method: String) -> void:
    print("%s -> '%s' of '%s'" % [
        success_start,
		test_method,
		test_file_path,
	])
