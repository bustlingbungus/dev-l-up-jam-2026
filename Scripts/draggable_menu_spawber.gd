extends Node2D

@export var DraggableMenus : Array[PackedScene]

@export var spawnAmt : int = 1

var _gamemode : Gamemode = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_gamemode = get_parent()
	SpawnMenu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func SpawnMenu() -> void:
	for i in range(spawnAmt):
		if (DraggableMenus.size() > 0):
			var scene = DraggableMenus[randi_range(0, DraggableMenus.size() - 1)]
			var instance = scene.instantiate()
			var menu = instance as DraggableMenu
			if (menu != null):
				add_child(menu)
				menu.gm = _gamemode
				menu.z_index = menu.z_index + i
				menu.TargetPosition = $MenuTarget.position
				menu.SubmitMenu.connect(SubmitMenu)


func SubmitMenu(menu : MenuTemplate) -> void:
	_gamemode.SubmitMenu(menu)
	SpawnMenu()
