class_name HandFollower extends Node2D

enum HandSprite
{
	IDLE,
	CLOSED
}

var CurrSprite : HandSprite = HandSprite.IDLE

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
		HandSprite.CLOSED:
			$IdleHand.visible = false
			$ClosedHand.visible = true
