class_name MenuTemplate extends Node2D


var TotalTurkeys : int = 0

var TurkeysDetected : int = 0
var FalseErases : int = 0

var ChosenIndices : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assign_word_refs(self, self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func OnWordErased(word : MenuWord) -> void:
	#print("turkeys caught:")
	#print(TurkeysDetected)
	#print("out of")
	#print(TotalTurkeys)
	#print("false positives")
	#print(FalseErases)
	#print()
	#print()
	pass


func assign_word_refs(node : Node, menu : MenuTemplate) -> void:
	# depth first search children, if it is a word, assign
	if (node != null):
		for child in node.get_children():
			assign_word_refs(child, menu)
			var word = child as MenuWord
			if (word != null):
				word.menuRef = menu
				if (word.IsTurkey):
					menu.TotalTurkeys += 1
