extends CSGCylinder

func _ready():
	$timer.start(rand_range(0.8, 4))
	$timer.connect("timeout", self, "_Death")

func _Death():
	queue_free()
