extends RichTextLabel

@export var playtime : float = 5.0 * 60.0 # five minutes
var _timer : float
var Active : bool = true

@export var gamemode : Gamemode = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_timer = playtime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Active):
		text = MakeClockString()
		if (_timer <= 0.0):
			if (gamemode != null):
				gamemode.EndGame(false)
		else:
			_timer -= delta


func MakeClockString() -> String:
	_timer = max(_timer, 0.0)
	var min : int = floorf(_timer / 60.0)
	var sec : int = floorf(_timer - (60.0 * min))
	
	var minstr = str(min)
	var secstr = str(sec)
	if (min < 10 && min > 0):
		minstr = '0' + minstr
	if (sec < 10):
		secstr = '0' + secstr
	
	return minstr + ':' + secstr
