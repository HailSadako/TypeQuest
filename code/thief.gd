extends "res://code/hero.gd"

onready var skills = [
		#Skill.new("throw sand", Target.ENEMY, INSTANT),
		#Skill.new("cripple", Target.ENEMY, INSTANT),
		#Skill.new("bleed", Target.ENEMY, INSTANT),
		#Skill.new("disarm", Target.ENEMY, INSTANT),
		#Skill.new("backstab", Target.ENEMY, CAST),
		#Skill.new("assassinate", Target.ENEMY, INSTANT),
		Skill.new("flurry", Target.ALL_ENEMIES, CHANNELED, MELEE_ATTACK, 4, 10, 10)
		]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
"""
func execute_skill(skill, target):
	if !is_dead:
		_cast_skill = skill
		_cast_target = target
		match skill.id:
			"flurry":
				_cast_duration = 5
				_cast_counter = _cast_duration
				$"Cast Bar".show()
			_:
				print("Skill not found: ", skill.id)

func finish_casting():
	match _cast_skill.id:
		"flurry":
			melee_attack(_cast_target, randi() % 10 + 30)
	_cast_skill = ""
	$"Cast Bar".hide()
"""
