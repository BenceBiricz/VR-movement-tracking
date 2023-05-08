tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Movement Tracker", "Node", preload("movement_tracker.gd"), preload("icon.png"))
	pass


func _exit_tree():
	remove_custom_type("Movement Tracker")
	pass


