extends Control

@export var StartScene : PackedScene

var _loaded : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ExitButton.pressed.connect(ExitGame)
	$CreditButton.pressed.connect(EnterCredits)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Global.Loaded && !_loaded):
		SetHighscoreText()
		_loaded = true
		
	if (Input.is_action_just_pressed("ui_cancel")):
		$CreditsFallGamejam.visible = false


func PlayButton() -> void:
	$Fade.StartFade()

func EnterCredits() -> void:
	$CreditsFallGamejam.visible = true

func ExitGame() -> void:
	Global.Save()
	get_tree().quit()


func SetHighscoreText() -> void:
	if (!Global.is_first_game):
		$"Highscore text".visible = true
		$"Highscore text".text = str(Global.highscore)
	else:
		$"Highscore text".visible = false
