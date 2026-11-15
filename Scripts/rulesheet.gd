class_name RuleSheet extends MenuTemplate

enum RuleType
{
	ALLOW,
	DISALLOW
}

@export var ruletype : RuleType = RuleType.ALLOW

var labels : Array[String] = []

var _randomized_words_verified : bool = false

var loaded : bool = false

func _ready() -> void:
	super()
	_force_load_randomwords(self)
	loaded = true

func HasLabel(label : String) -> bool:
	return label in labels

func LabelIsTurkey(label : String) -> bool:
	if (ruletype == RuleType.ALLOW):
		return false
	else:
		return true

func _force_load_randomwords(node : Node) -> void:
	for child in node.get_children():
		_force_load_randomwords(child)
		var rw = child as RandomizedWord
		if (rw != null):
			rw.LoadMenu()

func _verify_random_words(node : Node) -> bool:
	for child in node.get_children():
		if (child as RandomizedWord != null): # we still have valid words
			return true
		if (_verify_random_words(node)):
			return true
	return false
