extends Node2D

@export var DraggableMenus : Array[PackedScene]

var _gamemode : Gamemode = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_gamemode = get_parent()
	SpawnMenu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func SpawnMenu() -> void:
	if (DraggableMenus.size() > 0):
		var scene = DraggableMenus[randi_range(0, DraggableMenus.size() - 1)]
		var instance = scene.instantiate()
		var menu = instance as DraggableMenu
		if (menu != null):
			add_child(menu)
			menu.TargetPosition = $MenuTarget.position
			menu.SubmitMenu.connect(SubmitMenu)


func SubmitMenu(menu : MenuTemplate) -> void:
	_gamemode.SubmitMenu(menu)
	SpawnMenu()
