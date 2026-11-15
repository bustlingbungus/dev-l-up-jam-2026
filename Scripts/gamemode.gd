class_name Gamemode extends Node2D

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
	
	
	$Successtext.text = "Successes: " + str(SuccessfulMenus)
	$Failtext.text = "Failures: " + str(FailedMenus)



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
