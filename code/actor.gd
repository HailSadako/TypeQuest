extends Node2D

const DamageText = preload("res://scenes/damage_text.tscn")
const Target = preload("res://code/enum_target.gd")
const ICON_TARGET =  preload("res://textures/ui/icon_target.png")
const CHANNEL_INTERVAL = 1.0

enum {INSTANT, CAST, CHANNELED}
enum {MELEE_ATTACK, RANGED_ATTACK, STATUS, PERIODIC}

#const Global = preload("res://code/global.gd")

signal death(actor)

export(float) var movement_speed = 0.3
export(int) var base_hp = 100
export(float) var attack_animation_duration = 0.2
export(float) var defense = 1

onready var _input_bar = $"Target/Input Bar"
onready var _cast_bar = $"Cast Bar"

var hp
var enemies = []
var friends = []
var _attack_position = Vector2()
var _attack_counter = 0
var _shake_counter = 0
var _shake_intensity = 2.0
var is_dead = false
var _cast_counter = 0
var _cast_skill
var _cast_target
var _damage_text_pool = []
var _damage_text_index = 0
var _target_index = 0
var _channel_counter = 0
var _effects = []

func _ready():
	_input_bar.hide()
	_cast_bar.hide()
	set_hp(base_hp)
	for i in range(5):
		_damage_text_pool.append(DamageText.instance())
		add_child(_damage_text_pool[i])
	
func _physics_process(delta):
	if !is_dead:
		if _attack_counter > 0:
			_attack_counter = max(0, _attack_counter - delta)
			var t = (-abs(_attack_counter - attack_animation_duration) + attack_animation_duration) / attack_animation_duration
			$Sprite.global_position = global_position.linear_interpolate(_attack_position, t)
		elif _shake_counter > 0:
			$Sprite.global_position = global_position + Vector2(rand_range(-_shake_intensity, _shake_intensity), rand_range(-_shake_intensity, _shake_intensity))
			_shake_counter -= delta
			if _shake_counter <= 0:
				$Sprite.position = Vector2()
		if _cast_counter > 0:
			_cast_counter -= delta
			var bar_value = (_cast_skill.duration - _cast_counter) / _cast_skill.duration * 100
			if _cast_skill.execution == CHANNELED:
				bar_value = 100 - bar_value
				_channel_counter += delta
				if _channel_counter > CHANNEL_INTERVAL:
					_channel_counter -= CHANNEL_INTERVAL
					_find_next_target()
					_apply_skill()
			_cast_bar.value = bar_value
			if _cast_counter <= 0:
				finish_casting()
		
func set_hp(value):
	if !is_dead:
		hp = max(min(value, base_hp), 0)
		$"HP Bar".value = max(6, 100 * hp / base_hp)
		if hp <= 0:
			die()
	
func change_hp(value):
	if !is_dead:
		if value < 0:
			value = int(value * defense)
		_damage_text_pool[_damage_text_index].show_damage(value)
		_damage_text_index = (_damage_text_index + 1) % _damage_text_pool.size()
		set_hp(hp + value)
			
func animate_melee_attack(position):
	_attack_position = position
	_attack_counter = attack_animation_duration * 2
	
func shake(duration = 0.3, intensity = 2.0):
	_shake_counter = duration
	
func melee_attack(enemy, damage):
	if !enemy.is_dead:
		animate_melee_attack(enemy.global_position)
		yield(get_tree().create_timer(attack_animation_duration, false), "timeout")
		enemy.shake()
		enemy.change_hp(-damage)
	
func ranged_attack(enemy, damage):
	if !enemy.is_dead:
		if damage > 0:
			enemy.shake()
		enemy.change_hp(-damage)
		
func die():
	is_dead = true
	$"HP Bar".hide()
	_cast_bar.hide()
	disable_target()
	$Sprite.rotation = PI / 2.0
	_cast_counter = 0
	emit_signal("death", self)
	
func enable_target(text, icon = null):
	_input_bar.set_text(text)
	if icon == null:
		icon = ICON_TARGET
	_input_bar.set_icon(icon)
	_input_bar.show()
	
func disable_target():
	_input_bar.hide()
	
func set_target_input(text):
	if is_target_enabled():
		_input_bar.set_input(text)
		if !_input_bar.is_matching():
			disable_target()
	
func is_target_enabled():
	return _input_bar.visible
	
func is_perfect_match():
	return _input_bar.is_perfect_match() && _input_bar.visible
	
func flash_target():
	_input_bar.flash_and_hide()

func execute_skill(skill, target = null):
	if !is_dead:
		_cast_skill = skill
		_cast_target = target
		match skill.execution:
			CAST:
				_cast_counter = skill.duration
				_cast_bar.show()
			INSTANT:
				finish_casting()
			CHANNELED:
				_cast_counter = skill.duration
				_cast_bar.show()
				_target_index = 0
				_channel_counter = 0
				
func finish_casting():
	_apply_skill()
	_reset_casting()
	
func _reset_casting():
	_cast_target = null
	_cast_counter = 0
	_channel_counter = 0
	_cast_skill = null
	_cast_bar.hide()
	
func _apply_skill():
	if _cast_skill != null:
		match _cast_skill.type:
			MELEE_ATTACK:
				melee_attack(_cast_target, _cast_skill.damage)
			RANGED_ATTACK:
				ranged_attack(_cast_target, _cast_skill.damage)

func _find_next_target():
	var new_target = null
	var targets = enemies
	if _cast_skill.target_type == Target.ALL_FRIENDS:
		targets = friends
	for i in range(targets.size()):
		_target_index = (_target_index + 1) % targets.size()
		if !targets[_target_index].is_dead:
			new_target = targets[_target_index]
			break
	if new_target == null:
		_reset_casting()
	else:
		_cast_target = new_target
		
func add_effect(effect):
	_effects.append(effect)
		
class Skill:
	var id
	var target_type
	var execution
	var duration
	var difficulty
	var damage
	var type
		
	func _init(id, target_type, execution = INSTANT, type = MELEE_ATTACK, difficulty = 0, duration = 0, damage = 0):
		self.id = id
		self.target_type = target_type
		self.execution = execution
		self.duration = duration
		self.difficulty = difficulty
		self.damage = damage
		self.type = type