class_name RuleSheet extends MenuTemplate

enum RuleType
{
	ALLOW,
	DISALLOW
}

@export var ruletype : RuleType = RuleType.ALLOW

var labels : Array[String] = []

var _randomized_words_verified : bool = false

#func _process(delta: float) -> void:
	#super(delta)
	#if (!_randomized_words_verified):
		#if (_verify_random_words(self)):
			#_randomized_words_verified = true
		#else: # no words left, destroy parent draggable menu


func HasLabel(label : String) -> bool:
	return label in labels

func LabelIsTurkey(label : String) -> bool:
	if (ruletype == RuleType.ALLOW):
		return false
	else:
		return true


func _verify_random_words(node : Node) -> bool:
	for child in node.get_children():
		if (child as RandomizedWord != null): # we still have valid words
			return true
		if (_verify_random_words(node)):
			return true
	return false
