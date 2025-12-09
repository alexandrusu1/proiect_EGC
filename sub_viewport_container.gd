extends SubViewportContainer

func _ready():
	# Ne asigurăm că acest container nu blochează mouse-ul
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event):
	# Trimitem forțat orice mișcare de mouse către lumea de jos (SubViewport)
	$SubViewport.push_input(event)
