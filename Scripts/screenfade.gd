class_name FadeCover extends ColorRect

@export var StartHoldTime : float = 0.25
@export var EndHoldTime : float = 0.25
@export var FadeTime : float = 0.5
@export var FadeOutSceneChange : PackedScene = null
@export var InvertFade : bool = false
@export var autoFadeOnStart : bool = false

var _active : bool = false
var _holding : bool = true
var _end_hold : bool = false
var _timer : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	if (InvertFade):
		color.a = 0.0
	else:
		color.a = 1.0
		
	if (autoFadeOnStart):
		StartFade()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (_active):
		if (_timer <= 0.0):
			if (_holding):
				_holding = false
				_timer = FadeTime
			elif (_end_hold):
				_end_hold = false
				_active = false
				OnFadeComplete()
			else:
				_end_hold = true
				var start_alpha : float = 1.0
				if (InvertFade):
					start_alpha = 0.0
				color.a = 1.0 - start_alpha
				_timer = EndHoldTime
		else:
			var start_alpha : float = 1.0
			if (InvertFade):
				start_alpha = 0.0
			var end_alpha = 1.0 - start_alpha
			if (_holding):
				color.a = start_alpha
			elif (_end_hold):
				color.a = end_alpha
			else:
				color.a = lerpf(start_alpha, end_alpha, 1.0 - (_timer / FadeTime))
			_timer -= delta


func OnFadeComplete() -> void:
	if (FadeOutSceneChange != null):
		get_tree().change_scene_to_packed(FadeOutSceneChange)


func StartFade() -> void:
	if (!_active):
		_active = true
		_holding = true
		_timer = StartHoldTime
		if (InvertFade):
			color.a = 0.0
		else:
			color.a = 1.0
