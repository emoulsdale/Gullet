extends SceneTree

const test_container_path= "res://addons/gullet/test/container.gd"


func _init():
	var test_container: Node = preload(test_container_path).new()
	var failed: bool = test_container.run_all_tests()
	test_container.dispose()
	test_container.queue_free()
	if failed:
		quit(1)
	else:
		quit()
