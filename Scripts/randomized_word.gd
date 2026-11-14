class_name RandomizedWord extends MenuWord

@export var MenuFile : String
var _loaded : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	LoadMenu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if (!_loaded):
		LoadMenu()


func LoadMenu() -> void:
	if (menuRef != null):
		var file = FileAccess.open(MenuFile, FileAccess.READ)
		if (file != null):
			var json_string = file.get_as_text()
			var json = JSON.new()
			json.parse(json_string)
			var data = json.data
			if (data != null):
				# create an array of keys
				var keys : Array = []
				for k in data:
					keys.append(k)
				
				if (keys.size() > 1):
					# get random index
					var idx = randi_range(0, keys.size() - 1)
					# this is bad
					while (!_is_good_index(idx)):
						idx = randi_range(0, keys.size() - 1)
					# good index found
					IsTurkey = data[keys[idx]]
					text = keys[idx]
					menuRef.ChosenIndices[MenuFile].append(idx)
					_loaded = true


func _is_good_index(idx : int) -> bool:
	if (!menuRef.ChosenIndices.has(MenuFile)):
		menuRef.ChosenIndices.get_or_add(MenuFile, [])
		return true
	else:
		var chosen = menuRef.ChosenIndices[MenuFile]
		if (idx in chosen):
			return false
		chosen.append(idx)
		return true
