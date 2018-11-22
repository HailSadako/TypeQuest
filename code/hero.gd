extends "res://code/actor.gd"

var slots = [null, null, null, null, null]
export(Color) var color
export(Texture) var icon

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	pass
	
func claim_slot(enemy):
	if !is_dead:
		for i in range(slots.size()):
			if slots[i] == null:
				slots[i] = enemy
				return get_node(str("Enemy ", i+1))
	return null
	
func free_slot(enemy):
	for i in range(slots.size()):
		if slots[i] == enemy:
			slots[i] = null
			
func die():
	.die()
	$Sprite.rotation = -PI / 2.0
	for slot in slots:
		if slot != null:
			slot.clear_target()