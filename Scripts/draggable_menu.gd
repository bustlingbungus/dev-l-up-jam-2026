extends Sprite2D


@export var MaximizedMenu : PackedScene = null
var _maximized_menu : MenuTemplate = null

var _hovered : bool = false
var _drag : bool = false
var _mouse_disp : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (MaximizedMenu != null):
		var instance = MaximizedMenu.instantiate()
		if (instance != null):
			get_parent().call_deferred("add_child", instance)
			_maximized_menu = instance as MenuTemplate
			if (_maximized_menu != null):
				_maximized_menu.visible = false
				
				var max_area = _maximized_menu.get_node("Area2D") as Area2D
				if (max_area != null):
					max_area.mouse_entered.connect(_mouse_enter)
					max_area.mouse_exited.connect(_mouse_exit)
	
	
	$Area2D.mouse_entered.connect(_mouse_enter)
	$Area2D.mouse_exited.connect(_mouse_exit)
	$Area2D.area_entered.connect(_area_entered)
	$Area2D.area_exited.connect(_area_exited)
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_mouse_input()
	if (_drag):
		position = get_global_mouse_position() + _mouse_disp
	if (_maximized_menu != null):
		_maximized_menu.position = position



func _mouse_enter() -> void:
	print("entered")
	_hovered = true
	
func _mouse_exit() -> void:
	print("exit")
	_hovered = false


func _handle_mouse_input() -> void:
	if (Input.is_action_just_pressed("ui_accept")):
		if (_hovered):
			_mouse_disp = position - get_global_mouse_position()
			_drag = true
	elif (Input.is_action_just_released("ui_accept")):
		_drag = false


func _area_entered(area : Area2D) -> void:
	if (area.get_parent() != null):
		var ws : WorkspaceArea = area.get_parent() as WorkspaceArea
		if (ws != null):
			if (ws.workspaceZone == WorkspaceArea.WorkspaceZone.MAIN_WORKSPACE && _maximized_menu != null):
				visible = false
				_maximized_menu.visible = true
	pass
				
				
				
	
func _area_exited(area : Area2D) -> void:
	if (area.get_parent() != null):
		var ws : WorkspaceArea = area.get_parent() as WorkspaceArea
		if (ws != null):
			if (ws.workspaceZone == WorkspaceArea.WorkspaceZone.MAIN_WORKSPACE && _maximized_menu != null):
				visible = true
				_maximized_menu.visible = false
	pass
