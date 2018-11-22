extends Node

enum {HERO_WARRIOR, HERO_PRIEST, HERO_THIEF, HERO_WIZARD, HERO_WITCH, HERO_HUNTER, NO_MATCH}

enum {INSTANT, CAST, CHANNELED}

"""
var effects = {
		"taunt" : Effect.new(),
		"power strike" : Effect.new(),
		"protect" : Effect.new()}
		
var warrior_skills = [
		Skill.new("taunt", TARGET_ENEMY, INSTANT),
		Skill.new("protect", TARGET_FRIEND, INSTANT),
		Skill.new("fortify", TARGET_SELF, CHANNELED),
		Skill.new("knock back", TARGET_ENEMY, INSTANT),
		Skill.new("cleave", TARGET_ADJACENT_ENEMIES, CAST),
		Skill.new("power strike", TARGET_ENEMY, CAST),
		Skill.new("shield bash (stun)", TARGET_ENEMY, INSTANT)]

var priest_skills = [
		Skill.new("heal", TARGET_FRIEND, INSTANT),
		Skill.new("renew", TARGET_FRIEND, INSTANT),
		Skill.new("group heal", TARGET_ALL_FRIENDS, INSTANT),
		Skill.new("resurrect", TARGET_FRIEND, INSTANT),
		Skill.new("turn undead", TARGET_ENEMY, INSTANT),
		Skill.new("blessed weapons", TARGET_ALL_FRIENDS, INSTANT)]
		
var thief_skills = [
		Skill.new("throw sand", TARGET_ENEMY, INSTANT),
		Skill.new("cripple", TARGET_ENEMY, INSTANT),
		Skill.new("bleed", TARGET_ENEMY, INSTANT),
		Skill.new("disarm", TARGET_ENEMY, INSTANT),
		Skill.new("flurry", TARGET_ALL_ENEMIES, CHANNELED),
		Skill.new("backstab", TARGET_ENEMY, CAST),
		Skill.new("assassinate", TARGET_ENEMY, INSTANT)]
		
var wizard_skills = [
		Skill.new("fire ward", TARGET_ALL_FRIENDS, INSTANT),
		Skill.new("ice ward", TARGET_ALL_FRIENDS, INSTANT),
		Skill.new("dispel magic", TARGET_FRIEND, INSTANT),
		Skill.new("purge", TARGET_ENEMY, INSTANT),
		Skill.new("fireball", TARGET_ENEMY, CAST),
		Skill.new("hail storm", TARGET_ALL_ENEMIES, CHANNELED)]
		
var witch_skills = [
		Skill.new("lightning ward", TARGET_ALL_FRIENDS, INSTANT),
		Skill.new("earth ward", TARGET_ALL_FRIENDS, INSTANT),
		Skill.new("silence", TARGET_ENEMY, INSTANT),
		Skill.new("remove curse", TARGET_FRIEND, INSTANT),
		Skill.new("hex", TARGET_ENEMY, INSTANT),
		Skill.new("muddle", TARGET_ENEMY, INSTANT)]

var hunter_skills = [
		Skill.new("charm beast", HERO_HUNTER, TARGET_ENEMY, INSTANT)]
		
var skills = [warrior_skills, priest_skills, thief_skills, wizard_skills]
"""

func _init():
	print('global created')
	
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

		
class Effect:
	enum {ATTACK, HEAL, DOT, HOT, BUFF, DEBUFF}
	var hp
	var duration
	var damage_type
	var status
	var category
	var attack_modifier
	var defense_modifier
	var origin
	var id
