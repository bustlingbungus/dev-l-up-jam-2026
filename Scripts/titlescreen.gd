extends Control

@export var StartScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ExitButton.pressed.connect(ExitGame)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func PlayButton() -> void:
	$Fade.StartFade()

func ExitGame() -> void:
	get_tree().quit()
