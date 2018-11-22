extends Node

const Skeleton = preload("res://scenes/skeleton.tscn")
const Target = preload("res://code/enum_target.gd")

enum {WARRIOR, THIEF, WIZARD, PRIEST}
enum State {TARGETING, IDLE}

export(Color) var target_all_color = Color(0.7, 0.7, 0.8)

onready var _heroes = [$YSort/Warrior, $YSort/Thief, $YSort/Wizard, $YSort/Priest]
onready var _combat_ui = $"Combat UI"
onready var _target_all_bar = $"Target All/Input Bar"

var _enemies = []
var _counter = 0
var _current_skill
var _current_hero
var _vocabulary = [[], [], [], [], [], []]
var _state = State.IDLE
var _input
var _targets = []

func _ready():
	randomize()
	for i in range(3):
		var enemy = Skeleton.instance()
		$"YSort".add_child(enemy)
		enemy.enemies = _heroes
		var spawn = randi() % 5 + 1
		enemy.global_position = get_node(str("Spawn ", spawn)).global_position
		_enemies.append(enemy)
	for hero in _heroes:
		hero.enemies = _enemies
		hero.friends = _heroes
		_combat_ui.add_hero(hero)
		hero.connect("death", self, "_on_hero_death")
	_combat_ui.connect("match_found", self, "_on_match_found")
	_target_all_bar.hide()
	_target_all_bar.set_color(target_all_color)
	_load_vocabulary()

func _physics_process(delta):
	match _state:
		State.TARGETING:
			var no_valid_targets = true
			for actor in _targets:
				if actor.is_target_enabled():
					no_valid_targets = false
			if no_valid_targets:
				_state = State.IDLE
				_combat_ui.reset()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode >= 32 && event.scancode <= 90:
				var format_string = "%c"
				var new_character = format_string % event.unicode
				match _state:
					State.TARGETING:
						_update_target_bars(new_character)
					
func _update_target_bars(character):
	var no_valid_targets = true
	_input += character
	for actor in _targets:
		actor.set_target_input(_input.to_upper())
		if actor.is_target_enabled():
			no_valid_targets = false
			if actor.is_perfect_match():
				actor.flash_target()
				_execute_skill(actor)
				_combat_ui.reset()
				_state = State.IDLE
	if no_valid_targets:
		_combat_ui.reset()
		_combat_ui.show_info("*INVALID TARGET*")
		_state = State.IDLE
					
func _execute_skill(target = null):
	for hero in _heroes:
		for skill in hero.skills:
			if _current_skill == skill:
				hero.execute_skill(skill, target)
				
func _on_match_found(id):
	for hero in _heroes:
		for skill in hero.skills:
			if skill.id == id:
				_current_skill = skill
				_current_hero = hero
				match skill.target_type:
					Target.ENEMY:
						_targets = _enemies
						_target_actor(skill.difficulty)
					Target.FRIEND:
						_targets = _heroes
						_target_actor(skill.difficulty)
					Target.ALL_ENEMIES:
						_targets = [_current_hero]
						_target_actor(skill.difficulty, _current_hero.icon)
					Target.ALL_FRIENDS:
						_targets = [_current_hero]
						_target_actor(skill.difficulty, _current_hero.icon)
				
func _target_actor(difficulty, icon = null):
	var words = []
	var random_word = _get_random_word(difficulty)
	for actor in _targets:
		if !actor.is_dead:
			while(words.find(random_word) != -1):
				random_word = _get_random_word(difficulty)
			words.append(random_word)
			actor.enable_target(random_word, icon)
	_state = State.TARGETING
	_input = ""
	
func _on_hero_death(hero):
	match _state:
		State.IDLE:
			_combat_ui.refresh()
		State.TARGETING_ACTORS:
			if hero == _current_hero:
				_state = State.IDLE
				_combat_ui.reset()
				for actor in _targets:
					actor.disable_target()
	
func _load_vocabulary():
	var file = File.new()
	file.open("res://data/3.txt", file.READ)
	while(!file.eof_reached()):
		_vocabulary[0].append(file.get_line())
	file.close()
	file.open("res://data/4.txt", file.READ)
	while(!file.eof_reached()):
		_vocabulary[1].append(file.get_line())
	file.close()
	file.open("res://data/5.txt", file.READ)
	while(!file.eof_reached()):
		_vocabulary[2].append(file.get_line())
	file.close()
	file.open("res://data/67.txt", file.READ)
	while(!file.eof_reached()):
		_vocabulary[3].append(file.get_line())
	file.close()
	file.open("res://data/8910.txt", file.READ)
	while(!file.eof_reached()):
		_vocabulary[4].append(file.get_line())
	file.close()
	file.open("res://data/sentences.txt", file.READ)
	while(!file.eof_reached()):
		_vocabulary[5].append(file.get_line())
	file.close()

func _get_random_word(difficulty):
	var index = randi() % _vocabulary[difficulty].size()
	return _vocabulary[difficulty][index].to_upper()