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
						var this_rs = menuRef as RuleSheet
						if (this_rs == null):
							_loaded = _init_for_menus(keys, data)
						else:
							_loaded = _init_for_rulesheet_words(this_rs, keys, data)




func _init_for_rulesheet_words(this_rs : RuleSheet, keys : Array, data : Dictionary) -> bool:
	# get a list of labels available for the current sheet
	# remove labels that result in contradictions with other rulesheets
	# if there are no labels left, return 
	# otherwise, select random index from array
	# add label to menu's label list, set text, add to chosen indices list
	
	# get available labels on this menu
	var indices = _get_available_indices(keys)
	# remove labels that result in contradictions with other rulesheets
	indices = _remove_contradicting_indices(this_rs, keys, indices, data)
	if (indices.size() == 0):
		queue_free()
		return false
	
	# get random index
	var idx = indices[randi_range(0, indices.size() - 1)]
	text = keys[idx]
	menuRef.ChosenIndices[MenuFile].append(idx)
	this_rs.labels.append(keys[idx])
	
	return true




func _init_for_menus(keys : Array, data : Dictionary) -> bool:
	# get a list of labels (indices) available for the current menu
	# if there are no labels left, queue_free and return
	# if not all rulesheets have been initialized, return 
	# otherwise, select random index from array
	# use rulesheets to determine if the label is turkey or not
	# if turkey, increment menu's total turkey counter
	# in any case, set text, add to chosen indices list
	
	# get list of available labels
	var indices = _get_available_indices(keys)
	if (indices.size() == 0):
		queue_free()
		return false
	var rulesheets = _get_rulesheets()
	if (!_rulesheets_all_loaded(rulesheets)):
		return false
	
	# select random index
	var idx = indices[randi_range(0, indices.size()-1)]
	# determine if this index is turkey
	var label = keys[idx]
	IsTurkey = _get_rulesheet_verdict(rulesheets, label, data[label])
	if (IsTurkey):
		menuRef.TotalTurkeys += 1
	text = label
	menuRef.ChosenIndices[MenuFile].append(idx)
	
	return true




func _remove_contradicting_indices(this_rs : RuleSheet, keys : Array, indices : Array, data : Dictionary) -> Array[int]:
	var rulesheets = _get_rulesheets()
	# re-construct array without selected indices
	var arr : Array[int] = []
	
	for idx in indices:
		var label = keys[idx]
		# remove if the  label is ambiguous for the current menu
		# AMBIGUOUS: this rulesheet allows turkey, but label is already non-turkey
		if (this_rs.ruletype == RuleSheet.RuleType.ALLOW):
			if (!data[label]):
				continue
		# AMBIGUOUS: this rulesheet bans non-turkey, but label is already turkey
		elif (this_rs.ruletype == RuleSheet.RuleType.DISALLOW):
			if (data[label]):
				continue
				
		
		# remove if the label is present on any other rulesheet with an opposite ruletype
		var contradiction : bool = false
		for rs in rulesheets:
			if (rs.ruletype != this_rs.ruletype):
				if (rs.HasLabel(label)):
					contradiction = true
					break
		if (contradiction):
			continue
		
		# if we make it here, the index is valid
		arr.append(idx)
	return arr



func _rulesheets_all_loaded(rules : Array[RuleSheet]) -> bool:
	for rs in rules:
		if (!rs.loaded):
			return false
	return true


func _get_available_indices(keys : Array) -> Array[int]:
	if (!menuRef.ChosenIndices.has(MenuFile)):
		menuRef.ChosenIndices.get_or_add(MenuFile, [])
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
