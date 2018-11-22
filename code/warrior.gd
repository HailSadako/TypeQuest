extends "res://code/hero.gd"

onready var skills = [
		Skill.new("taunt", Target.ENEMY, INSTANT, STATUS),
		#Skill.new("protect", Target.FRIEND, INSTANT),
		#Skill.new("fortify", Target.SELF, CHANNELED),
		#Skill.new("knock back", Target.ENEMY, INSTANT),
		#Skill.new("cleave", Target.ADJACENT_ENEMIES, CAST),
		#Skill.new("shield bash (stun)", Target.ENEMY, INSTANT),
		Skill.new("power strike", Target.ENEMY, CAST, MELEE_ATTACK, 0, 2, 30)
		]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
