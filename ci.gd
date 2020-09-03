extends SceneTree

const test_container_path= "res://addons/gullet/test/container.gd"


func _init():
    var test_container: Node = preload(test_container_path).new()
    test_container.run_all_tests()
    test_container.dispose()
    test_container.queue_free()
    quit()
