extends Node2D

export(float) var speed = 30
export(float) var duration = 1
export(Color) var healing_color = Color(0, 1, 0, 1)
export(Color) var damage_color = Color(1, 0, 0, 1)
var counter = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	if visible:
		$Container.position.y -= speed * delta
		counter -= delta
		if counter <= 0:
			hide()
			$Container.position.y = 0

func show_damage(value):
	var text
	if value < 0:
		text = str(value)
		$"Container/Label 1".self_modulate = damage_color
	elif value > 0:
		text = str("+", value)
		$"Container/Label 1".self_modulate = healing_color
	else:
		text = "0"
		$"Container/Label 1".self_modulate = Color(1, 1, 1, 1)
	for i in range(1, 6):
		get_node(str("Container/Label ", i)).text = text
	counter = duration
	$Container.position.y = 0
	show()