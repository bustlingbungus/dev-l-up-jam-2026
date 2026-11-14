class_name Gamemode extends Node2D

var FailedMenus : int = 0
var SuccessfulMenus : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func SubmitMenu(menu : MenuTemplate) -> void:
	# success condition
	if (menu.TurkeysDetected == menu.TotalTurkeys && menu.FalseErases == 0):
		SuccessfulMenus += 1
	else:
		FailedMenus += 1
	
	
	$Successtext.text = "Successes: " + str(SuccessfulMenus)
	$Failtext.text = "Failures: " + str(FailedMenus)
