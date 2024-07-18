extends CanvasModulate

var time = 0.0
var dayNightCycleDuration = 600.0 # 10 minutes in seconds
var dayDuration = 300.0 # 5 minutes in seconds
var nightDuration = 300.0 # 5 minutes in seconds

func _ready():
	time = 300.0 # Set the initial time to the start of the day

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	var cycleTime = fmod(time, dayNightCycleDuration) # Calculate current time within the day-night cycle
	var value = 0.0
	
	if cycleTime < dayDuration: # Daytime
		value = cycleTime / dayDuration
	else: # Nighttime
		value = 1.0 - ((cycleTime - dayDuration) / nightDuration)
	
	self.modulate = Color(0, 0, 0, 1).lerp(Color(1, 1, 1, 1), value)











