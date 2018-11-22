extends Control

signal match_found(id)

export(Texture) var info_icon
export(Color, RGB) var info_color

onready var _skill_bars = [$"Skill Bar 1", $"Skill Bar 2", $"Skill Bar 3", $"Skill Bar 4"]
onready var _command_line = $"Command Line"

var _input = ""
var _heroes = []
var _tween
var _match_found = false

func _ready():
	_hide_skill_bars()
	_command_line.hide()

func _unhandled_input(event):
	if !_match_found:
		if event is InputEventKey:
			if event.pressed:
				if event.scancode >= 32 && event.scancode <= 90:
					var format_string = "%c"
					_addCharacter(format_string % event.unicode)
					get_tree().set_input_as_handled()
				elif event.scancode == KEY_BACKSPACE:
					_removeCharacter()
					get_tree().set_input_as_handled()
				
func _addCharacter(character):
	_input += character
	_command_line.set_text(_input)
	_command_line.show()
	_match_skills(_input)
	
func _removeCharacter():
	if _input.length() > 0:
		_input.erase(_input.length() - 1, 1)
		_command_line.set_text(_input)
	if _input.length() == 0:
		_command_line.hide()
		_hide_skill_bars()
	else:
		_match_skills(_input)
	
func add_hero(hero):
	_heroes.append(hero)
	
func refresh():
	_match_skills(_input)
	
func _match_skills(id):
	if id.length() > 0:
		var num_matches = 0
		_hide_skill_bars()
		for i in range(_heroes.size()):
			for j in range(_heroes[i].skills.size()):
				var skill = _heroes[i].skills[j]
				if !_heroes[i].is_dead && skill.id.begins_with(id.to_lower()): 
					#partial match
					if num_matches >= _skill_bars.size():
						print("ERROR: More skills than bars")
					else:
						_skill_bars[num_matches].set_text(skill.id.to_upper())
						_skill_bars[num_matches].set_input(id.to_upper())
						_skill_bars[num_matches].set_color(_heroes[i].color)
						_skill_bars[num_matches].set_icon(_heroes[i].icon)
						_skill_bars[num_matches].show()
						num_matches += 1
						if skill.id == id.to_lower():
							_command_line.hide()
							_skill_bars[0].flash_and_hide(INF)
							_match_found = true
							emit_signal("match_found", skill.id)
			if num_matches == 0:
				show_info("*NO MATCH*", 0)
		
func _hide_skill_bars():
	for bar in _skill_bars:
		bar.hide()
	
func reset():
	_hide_skill_bars()
	_command_line.hide()
	_match_found = false
	_input = ""
	
func show_info(text, bar = 1):
	_skill_bars[bar].set_text(text)
	_skill_bars[bar].set_color(info_color)
	_skill_bars[bar].set_icon(info_icon)
	_skill_bars[bar].show_cursor(false)
	_skill_bars[bar].show()