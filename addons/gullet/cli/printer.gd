tool
extends Node

const ANSI_RED = "[1;31m"
const ANSI_GREEN = "[1;32m"
const ANSI_YELLOW = "[1;33m"
const ANSI_RESET = "[1;0m"

var escape_string := PoolByteArray([0x1b]).get_string_from_ascii()


func color_text(text: String, ansi_color: String) -> String:
    return "%s%s%s%s%s" % [
        escape_string,
        ansi_color,
        text,
        escape_string,
        ANSI_RESET,
    ]


func green_text(text: String) -> String:
    return color_text(text, ANSI_GREEN)


func red_text(text: String) -> String:
    return color_text(text, ANSI_RED)


func yellow_text(text: String) -> String:
    return color_text(text, ANSI_YELLOW)


func print_failure(test_file_path: String, test_method: String,
failure_string: String) -> void:
    print("%s -> '%s' of '%s': %s" % [
        red_text("FAIL"),
        test_method,
        test_file_path,
        yellow_text(failure_string)
    ])


func print_pass(test_file_path: String, test_method: String) -> void:
    print("%s -> '%s' of '%s'" % [
        green_text("PASS"),
		test_method,
		test_file_path,
	])
