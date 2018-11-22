extends Control

var _flash_color_1 = Color(1, 1, 1)
var _flash_color_2 = Color(0, 0, 0)
var _tween
var _flash_loops
var _flash_speed

func _ready():
	set_color($Panel.self_modulate)
	_tween = Tween.new()
	add_child(_tween)
	_tween.connect("tween_completed", self, "_flash")
	_tween.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS

func set_input(text):
	$Panel/Input.text = text
	$"Panel/Outline 1".text = text
	$"Panel/Outline 2".text = text
	$"Panel/Outline 3".text = text
	$"Panel/Outline 4".text = text
	var cursor = ""
	for i in text.length():
		cursor += " "
	cursor += "_"
	$Panel/Cursor.text = cursor
	if text == $Panel/Shadow.text:
		show_cursor(false)
	
func set_text(text):
	$Panel/Shadow.text = text
	set_input("")
	$Panel.margin_right = 23 + text.length() * 9
	show_cursor(true)

func set_color(color):
	var dark_color = color.darkened(0.5)
	$Panel.self_modulate = color
	$Panel/Shadow.self_modulate = dark_color
	$Panel/Cursor.self_modulate = dark_color
	
func set_icon(texture):
	$Panel/Icon.texture = texture
	
func show_cursor(value):
	$Panel/Cursor.visible = value

func is_matching():
	return $Panel/Shadow.text.begins_with($Panel/Input.text)
	
func is_perfect_match():
	return $Panel/Input.text == $Panel/Shadow.text
	
func flash_and_hide(loops = 3, speed = 0.2):
	_flash_loops = loops
	_flash_speed = speed
	_flash()
	
func _flash(object = null, key = null):
	var temp_color = _flash_color_1
	_flash_color_1 = _flash_color_2
	_flash_color_2 = temp_color
	_tween.interpolate_property($Panel/Input, "self_modulate", _flash_color_1, _flash_color_2, _flash_speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	if _flash_loops > 0:
		_tween.start()
	else:
		hide()
	_flash_loops -= 1

func hide():
	.hide()
	_tween.remove_all()
	$Panel/Input.self_modulate = Color(1, 1, 1)