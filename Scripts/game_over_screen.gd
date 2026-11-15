extends Sprite2D

@export var FadeTime : float = 10.0
@export var fadeCover : FadeCover = null
@export var MenuScene : String

var _active : bool = false
var _timer : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	$ColorRect2.visible = false
	$Button.visible = false
	$Button.pressed.connect(ExitToMenu)
	modulate.a = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (_active):
		if (_timer > 0.0):
			var alp = lerpf(1.0, 0.0, _timer / FadeTime)
			modulate.a = alp
			_timer -= delta
		else:
			modulate.a = 1.0
			OnFadeComplete()


func FadeIn() -> void:
	_active = true
	_timer = FadeTime


func OnFadeComplete() -> void:
	# reveal elements
	$ColorRect2.visible = true
	$Button.visible = true


func ExitToMenu() -> void:
	fadeCover.EndHoldTime = fadeCover.StartHoldTime
	fadeCover.StartHoldTime = 0.0
	fadeCover.InvertFade = !fadeCover.InvertFade
	fadeCover.FadeOutSceneChange = load(MenuScene)
	fadeCover.StartFade()
