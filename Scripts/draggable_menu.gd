class_name DraggableMenu extends Sprite2D


@export var MaximizedMenu : PackedScene = null
var _maximized_menu : MenuTemplate = null

var _hovered : bool = false
var _drag : bool = false
var _mouse_disp : Vector2


enum MoveState
{
	NORMAL,
	SPAWNING,
	SUBMISSION
}

@export var SpawnTravelTime : float = 1.0
var _spawn_travel_timer : float
var Movestate : MoveState = MoveState.SPAWNING

@export var SubmissionTravelTime : float = 1.0

var TargetPosition : Vector2

var _currSpace : WorkspaceArea.WorkspaceZone


signal SubmitMenu(menu: MenuTemplate)


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
	
	_spawn_travel_timer = SpawnTravelTime
	
	$Area2D.mouse_entered.connect(_mouse_enter)
	$Area2D.mouse_exited.connect(_mouse_exit)
	$Area2D.area_entered.connect(_area_entered)
	$Area2D.area_exited.connect(_area_exited)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_mouse_input()
	
	match (Movestate):
		MoveState.SPAWNING:
			_spawn_travel_timer = max(0.0, _spawn_travel_timer - delta)
			position = lerp(position, TargetPosition, 1 - (_spawn_travel_timer / SpawnTravelTime))
			if (_spawn_travel_timer <= 0.0):
				Movestate = MoveState.NORMAL
		MoveState.SUBMISSION:
			_spawn_travel_timer = max(0.0, _spawn_travel_timer - delta)
			position = lerp(position, TargetPosition, 1 - (_spawn_travel_timer / SubmissionTravelTime))
			if (_spawn_travel_timer <= 0.0):
				SubmitMenu.emit(_maximized_menu)
				queue_free()
		_:
			if (_drag):
				position = get_global_mouse_position() + _mouse_disp
	
	
	if (_maximized_menu != null):
		_maximized_menu.position = position



func _mouse_enter() -> void:
	_hovered = true
	
func _mouse_exit() -> void:
	_hovered = false


func _handle_mouse_input() -> void:
	if (Input.is_action_just_pressed("ui_accept")):
		if (_hovered):
			Movestate = MoveState.NORMAL
			_mouse_disp = position - get_global_mouse_position()
			_drag = true
	elif (Input.is_action_just_released("ui_accept")):
		if (_drag):
			_drag = false
			if (_currSpace == WorkspaceArea.WorkspaceZone.INCOMING_BIN):
				Movestate = MoveState.SPAWNING
				_spawn_travel_timer = SpawnTravelTime
				TargetPosition.x = position.x
			elif (_currSpace == WorkspaceArea.WorkspaceZone.OUTGOING_BIN):
				Movestate = MoveState.SUBMISSION
				TargetPosition.x = position.x
				TargetPosition.y += 500.0
				_spawn_travel_timer = SubmissionTravelTime


func _area_entered(area : Area2D) -> void:
	if (area.get_parent() != null):
		var ws : WorkspaceArea = area.get_parent() as WorkspaceArea
		if (ws != null):
			_currSpace = ws.workspaceZone
			if (ws.workspaceZone == WorkspaceArea.WorkspaceZone.MAIN_WORKSPACE && _maximized_menu != null):
				visible = false
				_maximized_menu.visible = true
				
	
func _area_exited(area : Area2D) -> void:
	if (area.get_parent() != null):
		var ws : WorkspaceArea = area.get_parent() as WorkspaceArea
		if (ws != null):
			if (ws.workspaceZone == WorkspaceArea.WorkspaceZone.MAIN_WORKSPACE && _maximized_menu != null):
				visible = true
				_maximized_menu.visible = false
