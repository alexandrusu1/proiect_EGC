extends CanvasLayer

@onready var textul = $Label

func _ready():

	await get_tree().create_timer(7.0).timeout
	
	var animatie = create_tween()
	
	animatie.tween_property(textul, "modulate:a", 0.0, 1.0)
	
	animatie.tween_callback(queue_free)
