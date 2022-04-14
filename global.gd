extends Node

const gravity = 14.2
const acceleration = 2.25

export var gravity_strenglth = 0

func _custom_physics(object, bullet, player, weight, DELTA, output):
	# enable - true and false
	# object - it node
	# bullet - if is bullet, aber?
	# player - understand
	# weight - do easy
	# DELTA - delta
	
	var SELF = object
	gravity_strenglth += ((weight * 2) / (PI + PI)) * (DELTA / 2)
	if bullet:
		SELF.translation += -SELF.global_transform.basis.z * SELF.speed * DELTA
		SELF.translation.y -= (weight * DELTA) / (gravity + gravity_strenglth + SELF.speed) * DELTA / 3
		if output:
			print((weight * gravity / gravity_strenglth) * DELTA)
		if SELF.transform.origin.y < -1.1567:
			SELF.queue_free()
	if !bullet and !SELF.is_on_floor():
		if player: 
			SELF.vel.y -= (gravity_strenglth + gravity) * DELTA
		else:
			SELF.transform.origin.y -= (gravity_strenglth + gravity) * DELTA
	else:
		gravity_strenglth = 0
