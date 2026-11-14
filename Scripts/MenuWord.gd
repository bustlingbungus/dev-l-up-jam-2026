class_name MenuWord extends RichTextLabel

@export var IsTurkey : bool = false

var menuRef : MenuTemplate = null

var _mouse_hover : bool = false
var _triggered : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_mouse_enter)
	mouse_exited.connect(_mouse_exit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		if (_mouse_hover && !_triggered):
			_triggered = true
			if (menuRef != null):
				if (IsTurkey):
					menuRef.TurkeysDetected += 1
				else:
					menuRef.FalseErases += 1
				menuRef.OnWordErased(self)
			_onTrigger()


func _mouse_enter() -> void:
	_mouse_hover = true
func _mouse_exit() -> void:
	_mouse_hover = false


func _onTrigger() -> void:
	visible = false
