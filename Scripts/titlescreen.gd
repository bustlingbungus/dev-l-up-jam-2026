extends Control

@export var StartScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$PlayButton.pressed.connect(PlayButton)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func PlayButton() -> void:
	$Fade.StartFade()
