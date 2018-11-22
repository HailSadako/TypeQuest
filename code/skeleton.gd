extends "res://code/enemy.gd"

export(float) var attack_interval = 3.0

var attack_counter = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	if !is_dead && enemies.size() > 0:
		if target == null:
			var index = randi() % enemies.size()
			approach_hero(enemies[index])
		elif !is_moving:
			attack_counter += delta
			if attack_counter >= attack_interval:
				attack_counter -= attack_interval
				melee_attack(target, 5)