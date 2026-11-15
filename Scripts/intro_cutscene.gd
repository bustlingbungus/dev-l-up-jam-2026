extends Node2D

@export var FadeTime : float = 1.0
var _timer : float
var _fading : bool = false

var _curr_panel_idx : int = 0

var _fadein_panel : Sprite2D = null
var _fadeout_panel : Sprite2D = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$panels.get_child(0).visible = true
	for i in range(1, $panels.get_child_count()):
		$panels.get_child(i).visible = false
	
	if (Global.is_first_game):
		$SkipText.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_cancel") && !Global.is_first_game):
		$FadeOut.StartFade()
		
	if (Input.is_action_just_pressed("ui_accept")):
		ProceedPanel() 
	if (_fading):
		if (_timer > 0.0):
			var t = 1.0 - (_timer / FadeTime)
			_fadeout_panel.modulate.a = lerpf(1.0, 0.0, t)
			_fadein_panel.modulate.a = lerpf(0.0, 1.0, t)
			_timer -= delta
		else:
			_fading = false
			_fadeout_panel.visible = false
			_fadein_panel.modulate.a = 1.0


func ProceedPanel() -> void:
	# last panel
	if (_curr_panel_idx == $panels.get_child_count() - 1):
		$FadeOut.StartFade()
	else:
		_fadeout_panel = $panels.get_child(_curr_panel_idx) as Sprite2D
		_fadein_panel = $panels.get_child(_curr_panel_idx + 1) as Sprite2D
		_fadein_panel.visible = true
		_curr_panel_idx += 1
		_fading = true
		_timer = FadeTime
