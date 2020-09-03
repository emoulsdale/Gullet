extends SceneTree


func _init():
	var utils: Reference = preload("res://addons/gullet/utils.gd")
	var test_files: Array = utils.get_test_files()
	var test_container: Node = preload("test_container/container.gd").new()
	test_container.run_all_tests()
	test_container.queue_free()
	quit()
