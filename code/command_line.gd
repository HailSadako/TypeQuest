extends Node

const BLINKTIME = 0.5

var _text = ""
var _blink_counter = 0
var _underscore = false

func _ready():
	set_text("")

func _process(delta):
	_blink_counter += delta
	if _blink_counter >= BLINKTIME:
		_blink_counter -= BLINKTIME
		_toggle_underscore()


func set_text(text):
	_text = text.to_upper()
	$Panel/Label.text = _text
	set_process(text != "")

func _toggle_underscore():
	_underscore = !_underscore
	if _underscore:
		$Panel/Label.text = _text + "_"
	else:
		$Panel/Label.text = _text