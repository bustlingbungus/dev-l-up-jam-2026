extends Node2D

@export var DraggableMenus : Array[PackedScene]
@export var DraggableRulesheets : Array[PackedScene]

@export var spawnAmt : int = 1

@export var AddRulesheetChance : float = 0.5

var _gamemode : Gamemode = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_gamemode = get_parent()
	SpawnMenu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func SpawnMenu() -> void:
	if (randf_range(0.0, 1.0) <= AddRulesheetChance):
		if (DraggableRulesheets.size() > 0):
			var scene = DraggableRulesheets[randi_range(0, DraggableRulesheets.size() - 1)]
			var instance = scene.instantiate()
			var menu = instance as DraggableMenu
			if (menu != null):
				add_child(menu)
				menu.gm = _gamemode
				menu.z_index = menu.z_index + spawnAmt
				menu.maximized_menu.z_index = menu.z_index
				menu.TargetPosition = $MenuTarget.position
				
				
				
	for i in range(spawnAmt):
		if (DraggableMenus.size() > 0):
			var scene = DraggableMenus[randi_range(0, DraggableMenus.size() - 1)]
			var instance = scene.instantiate()
			var menu = instance as DraggableMenu
			if (menu != null):
				add_child(menu)
				menu.gm = _gamemode
				menu.z_index = menu.z_index + i
				menu.maximized_menu.z_index = menu.z_index
				menu.TargetPosition = $MenuTarget.position
				menu.SubmitMenu.connect(SubmitMenu)
	
	$PaperDropSoundEffect.play()
	

func SubmitMenu(menu : MenuTemplate) -> void:
	_gamemode.SubmitMenu(menu)
	if (_no_more_draggables(menu)):
		SpawnMenu()


func _no_more_draggables(current_submission : MenuTemplate) -> bool:
	for child in get_children():
		var draggable = child as DraggableMenu
		if (draggable != null):
			# draggable non-rulesheet menu (other than the one being submitted)
			if (draggable.maximized_menu as RuleSheet == null):
				if (draggable.maximized_menu != current_submission):
					return false
	return true
