class_name HandFollower extends Node2D

enum HandSprite
{
	IDLE,
	CLOSED,
	ERASER
}

var CurrSprite : HandSprite = HandSprite.IDLE
var ErasablesBelow : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_global_mouse_position()


func SetSprite(sprite : HandSprite) -> void:
	CurrSprite = sprite
	match (sprite):
		HandSprite.IDLE:
			$IdleHand.visible = true
			$ClosedHand.visible = false
			$EraserHand.visible = false
		HandSprite.CLOSED:
			$IdleHand.visible = false
			$ClosedHand.visible = true
			$EraserHand.visible = false
		HandSprite.ERASER:
			$IdleHand.visible = false
			$ClosedHand.visible = false
			$EraserHand.visible = true
