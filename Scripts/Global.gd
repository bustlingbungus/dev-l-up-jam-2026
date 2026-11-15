extends Node

var Loaded : bool = false

var highscore : int = 0
var is_first_game : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Load()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func Load() -> void:
	if (!Loaded):
		var file = FileAccess.open("user://JSON/data.json", FileAccess.READ)
		#var file = FileAccess.open("res://JSON/data.json", FileAccess.READ)
		if (file != null):
			var json_string = file.get_as_text()
			var json = JSON.new()
			json.parse(json_string)
			var data = json.data
			if (data != null):
				if (data.has("highscore")):
					highscore = data["highscore"]
				if (data.has("first_game")):
					is_first_game = data["first_game"]
				Loaded = true


func Save() -> void:
	var data_dict : Dictionary = {
		"highscore" : highscore,
		"first_game" : is_first_game
	}
	var file = FileAccess.open("user://JSON/data.json", FileAccess.WRITE)
	#var file = FileAccess.open("res://JSON/data.json", FileAccess.WRITE)
	if (file != null):
		file.store_line(JSON.stringify(data_dict))
