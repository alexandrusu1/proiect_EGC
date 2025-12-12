extends SubViewportContainer

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event):
	$SubViewport.push_input(event)
