extends CSGBox

func _ready():
	$timer.start(rand_range(0.8, 4))
	$timer.connect("timeout", self, "_death")

func _death():
	queue_free()

