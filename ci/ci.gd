extends SceneTree

const TESTER_PATH = "res://addons/gullet/tester/tester.gd"


func _init():
    var tester: Node = preload(TESTER_PATH).new()
    tester.run_all_tests()
    tester.dispose()
    tester.queue_free()
    quit()
