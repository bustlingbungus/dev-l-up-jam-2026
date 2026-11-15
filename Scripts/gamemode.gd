class_name Gamemode extends Node2D

@export var MaxAllowedFailures : int = 5

var FailedMenus : int = 0
var SuccessfulMenus : int = 0

# this would be marginally more efficient if it were a priority queue
var menu_array : Array[DraggableMenu] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SelectDraggedMenu()


func SubmitMenu(menu : MenuTemplate) -> void:
	# success condition
	if (menu.TurkeysDetected == menu.TotalTurkeys && menu.FalseErases == 0):
		SuccessfulMenus += 1
	else:
		FailedMenus += 1
		if (FailedMenus >= MaxAllowedFailures):
			EndGame()
	
	
	$Score/Successtext.text = "Turkeys Saved: " + str(SuccessfulMenus)
	$Score/Failtext.text = "Failed Menus: " + str(FailedMenus)



func SelectDraggedMenu() -> void:
	if (menu_array.size() == 0):
		return
	# don't bother sorting the array , O(nlogn), just search for the best element, O(n)
	var best_menu : DraggableMenu = null
	for menu in menu_array:
		if (best_menu == null || best_menu.z_index < menu.z_index):
			best_menu = menu
	
	if (best_menu != null):
		best_menu.MakeDragged()
	
	# reset array
	menu_array.clear()


func EndGame() -> void:
	# get rid of game elements
	for child in $MenuSpawner.get_children():
		var drag = child as DraggableMenu
		if (drag != null):
			drag.draggable == false
		child.call_deferred("reparent", self)
	$MenuSpawner.call_deferred("queue_free")
	$HandFollower.queue_free()
	$ColorRect2/RunTimer.Active = false
	$GameOverFallGamejam/ColorRect2/ScoreText.text = $Score/Successtext.text
	$GameOverFallGamejam.FadeIn()
