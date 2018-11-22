extends KinematicBody2D

const move_speed = 50
const character_distance = 25

var velocity = Vector2()
var trail = []

func _ready():
	var trail_length = character_distance * 3
	for i in range(trail_length):
		trail.append(global_position.floor())
	

func _physics_process(delta):
	velocity.x = 0
	velocity.y = 0
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	move_and_slide(velocity.normalized() * move_speed)
	
	if velocity.x != 0 || velocity.y != 0:
		trail.pop_back()
		trail.push_front(Vector2(global_position.x, global_position.y))
		
	$Thief.global_position = trail[character_distance - 1]
	$Wizard.global_position = trail[character_distance * 2 - 1]
	$Priest.global_position = trail[character_distance * 3 - 1]