extends CanvasLayer

@onready var textul = $Label

func _ready():
	# Aici e partea importantă: 7.0 înseamnă 7 secunde de așteptare
	await get_tree().create_timer(7.0).timeout
	
	# După ce trec cele 7 secunde, facem textul să dispară încet (fade out)
	var animatie = create_tween()
	
	# "modulate:a" este transparența. O ducem la 0 (invizibil) în timp de 1 secundă
	animatie.tween_property(textul, "modulate:a", 0.0, 1.0)
	
	# După ce a devenit invizibil, ștergem totul din memorie
	animatie.tween_callback(queue_free)
