extends "res://code/hero.gd"

onready var skills = [
		#Skill.new("renew", Target.FRIEND, INSTANT),
		#Skill.new("group heal", Target.ALL_FRIENDS, INSTANT),
		#Skill.new("resurrect", Target.FRIEND, INSTANT),
		#Skill.new("turn undead", Target.ENEMY, INSTANT),
		#Skill.new("blessed weapons", Target.ALL_FRIENDS, INSTANT),
		Skill.new("heal", Target.FRIEND, INSTANT, RANGED_ATTACK, 2, 0, -30)
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
			"heal":
				finish_casting()
			_:
				print("Skill not found: ", skill.id)

func finish_casting():
	match _cast_skill.id:
		"heal":
			_cast_target.change_hp(30)
	_cast_skill = ""
	$"Cast Bar".hide()
"""