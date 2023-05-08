extends Spatial

var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if Input.is_action_pressed("ui_accept"):
		started = true
	if(started):
		$Menu.visible = false
		if Input.is_action_pressed("ui_left"):
			$MeshInstance.transform.origin.x -= 0.2
		if Input.is_action_pressed("ui_right"):
			$MeshInstance.transform.origin.x += 0.2
		if Input.is_action_pressed("ui_up"):
			$MeshInstance.transform.origin.y += 0.2
		if Input.is_action_pressed("ui_down"):
			$MeshInstance.transform.origin.y -= 0.2
