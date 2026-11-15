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
	if (!_loaded):
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
						if (!_menu_has_available_indices(keys.size())):
							queue_free()
							return
						
						var rulesheets = _get_rulesheets()
						if (!_rulesheets_all_loaded(rulesheets)):
							return
						
						var indices = _get_available_indices(keys)
						var idx = indices[randi_range(0, indices.size() - 1)]
						# good index found
						var rs = menuRef as RuleSheet
						var default_val : bool = data[keys[idx]]
						
						# this word is on a rulesheet, see if this is a valid label for a rulesheet, 
						if (rs != null):
							# make sure the label doesn't result in contradictions
							# this is a very lazy solution
							var depth : int = 0
							var max_depth = 50
							while (_label_exists_in_contradicting_rulesheets(rs, rulesheets, keys[idx], default_val) && depth < max_depth):
								idx = indices[randi_range(0, indices.size() - 1)]
								depth += 1
							if (depth >= max_depth):
								queue_free()
								return
							# add this label to the rulesheet's labels
							rs.labels.append(keys[idx])
						
						# word is on a normal menu, see if the label is a turkey
						else:
							# see what rulesheets have to say about this item
							IsTurkey = _get_rulesheet_verdict(rulesheets, keys[idx], default_val)
							
							if (IsTurkey):
								menuRef.TotalTurkeys += 1
								#keys[idx] = keys[idx] + "<- TURKEY"

						# final commits before completing load
						text = keys[idx]
						menuRef.ChosenIndices[MenuFile].append(idx)
						_loaded = true



func _label_allowed_by_rulesheets() -> bool:
	return false

func _rulesheets_all_loaded(rules : Array[RuleSheet]) -> bool:
	for rs in rules:
		if (!rs.loaded):
			return false
	return true

func _menu_has_available_indices(total_available_indices : int) -> bool:
	if (!menuRef.ChosenIndices.has(MenuFile)):
		return true
	var indices_taken : int = menuRef.ChosenIndices[MenuFile].size()
	return total_available_indices > indices_taken


func _get_available_indices(keys : Array) -> Array[int]:
	if (!menuRef.ChosenIndices.has(MenuFile)):
		menuRef.ChosenIndices.get_or_add(MenuFile, [])
	# this has fucking horrible efficiency
	# do not put this game on your resume until this is fixed
	var arr : Array[int] = []
	for i in range(keys.size()):
		if (!i in menuRef.ChosenIndices[MenuFile]):
			arr.append(i)
	return arr


func _get_rulesheets() -> Array[RuleSheet]:
	var nodes = get_tree().get_nodes_in_group("Rulesheet")
	var arr : Array[RuleSheet] = []
	for n in nodes:
		var rs = n as RuleSheet
		if (rs != null):
			arr.append(rs)
	return arr

func _get_rulesheet_verdict(rulesheets : Array[RuleSheet], label : String, default_val : bool) -> bool:
	for rs in rulesheets:
		if (rs.HasLabel(label)):
			return rs.LabelIsTurkey(label)
	return default_val

func _label_exists_in_contradicting_rulesheets(this_rs : RuleSheet, other_rules : Array[RuleSheet], label : String, default_val : bool) -> bool:
	for rs in other_rules:
		if (rs.ruletype != this_rs.ruletype):
			if (rs.HasLabel(label)):
				return true
	
	# make sure label is not ambiguous in the current rulesheet
	if (this_rs.ruletype == RuleSheet.RuleType.ALLOW):
		if (!default_val):
			return true
	elif (this_rs.ruletype == RuleSheet.RuleType.DISALLOW):
		if (default_val):
			return true
	
	return false
