extends RichTextLabel

@export var idle_time : float = 3.0
var _timer : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	_timer = idle_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (_timer <= 0.0):
		visible = true
	else:
		_timer -= delta
		visible = false
	
	if (Input.is_action_just_pressed("ui_accept")):
		_timer = idle_time
