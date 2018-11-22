extends "res://code/actor.gd"

var destination = null
var target = null
var is_moving = false
var slot_position = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	if is_moving:
		var d = destination - global_position
		var vel = d.normalized() * movement_speed
		if d.length() > 1:
			translate(vel)
		else:
			global_position = destination
			is_moving = false

func set_destination(position):
	destination = position
	is_moving = true
	
func approach_hero(hero):
	var new_position = hero.claim_slot(self)
	if new_position != null:
		slot_position = new_position
		target = hero
		set_destination(new_position.global_position)
		return true
	return false
	
func clear_target():
	target = null
	
func die():
	.die()
	is_moving = false
	if target != null:
		target.free_slot(self)
	yield(get_tree().create_timer(3, false), "timeout")
	hide()