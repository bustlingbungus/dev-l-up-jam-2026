extends Area2D


var _mouse_hover : bool = false

var _triggered : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_mouse_enter)
	mouse_exited.connect(_mouse_exit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		if (_mouse_hover && !_triggered):
			_triggered = true
			_onTrigger()


func _mouse_enter() -> void:
	_mouse_hover = true
func _mouse_exit() -> void:
	_mouse_hover = false


func _onTrigger() -> void:
	print("trigger")
