extends SceneTree

func _init():
	# this is VERY broken
	var gullet: EditorPlugin = preload("res://addons/gullet/gullet.gd").new()
	var utils: Reference = preload("res://addons/gullet/utils.gd")
	var test_files: Array = utils.get_test_files()
	gullet.queue_free()
	quit()
