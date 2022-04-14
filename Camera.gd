extends Camera

export var mouse_position: Vector2
export var dir: Vector3
export var mouse_position_recoil: float
export var mouse_position_recoil_switch: int

onready var sensivity = 2.53
onready var speed = 6.5
onready var acceleration = 2.5
onready var move_type = false

onready var raycast = $RayCast
onready var timer_fire = $timer
onready var timer_recoil = $timer2
onready var timer_recoil_switch = $timer2/timer
onready var timer_recoil_switch_2 = $timer2/timer2
onready var model = preload("res://Scenes/mod.tscn")

# 2 move
onready var move = KinematicBody.new()
export var move_vel: Vector3



func _process(delta):
	# rotate
	mouse_position.y = clamp(mouse_position.y, -1150, 1150)
	# fire
	if Input.is_action_pressed("ui_select"):
		if timer_recoil.is_stopped():
			timer_recoil.start(0.24)
		mouse_position = lerp(mouse_position, Vector2(mouse_position.x + mouse_position_recoil, mouse_position.y - 4.5), 0.23)
		if raycast.get_collider():
			if timer_fire.is_stopped():
				timer_fire.start(rand_range(0.07, 0.13))
	else:
		mouse_position_recoil_switch = 0
		mouse_position_recoil = 0
	if mouse_position_recoil_switch == 1:
		mouse_position_recoil = 1.25
	elif mouse_position_recoil_switch == 2:
		mouse_position_recoil = -1.65


func _physics_process(delta):
	# rotate a camera
	transform.basis = Basis(Vector3(mouse_position.y * (sensivity / -1850), mouse_position.x * (sensivity / -1850), 0))
	
	# movement
	dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	dir = transform.basis.xform(dir)
	
	if Input.is_action_just_pressed("move_switch"):
		move_type = false if move_type else true

	if !move_type:
		translation += dir * speed * delta
		move.transform.origin = transform.origin
	else:
		get_parent().add_child(move)
		
		if dir.length() > 0.94:
			dir /= dir.length()
		
		move_vel = move_vel.linear_interpolate(dir * speed, acceleration * delta)
		transform.origin = move.transform.origin
		move.move_and_slide(move_vel, Vector3.UP)
	
	$Control/Label.text = str(dir) + " - dir\n" + str(move_vel) + " - formula"


func _ready():
	timer_fire.connect("timeout", self, "set_position_bullet")
	timer_recoil.connect("timeout", self, "set_recoil")
	timer_recoil_switch.connect("timeout", self, "set_mouse_switch_position", [1])
	timer_recoil_switch_2.connect("timeout", self, "set_mouse_switch_position", [2])


func _input(event):
	if event is InputEventMouseMotion:
		mouse_position += event.relative
		mouse_position.y = clamp(mouse_position.y, -1150, 1150)


func set_position_at_camera():
	move.transform.origin = transform.origin


func set_position_bullet():
	var bullet = model.instance()
	get_node("/root").add_child(bullet)
	bullet.transform.origin = raycast.get_collision_point()

func set_recoil():
	if mouse_position_recoil_switch == 0:
		if timer_recoil_switch.is_stopped():
			timer_recoil_switch.start(0.1)
	elif mouse_position_recoil_switch == 1:
		if timer_recoil_switch_2.is_stopped():
			timer_recoil_switch_2.start(0.3)

func set_mouse_switch_position(pos):
	mouse_position_recoil_switch = pos
	print(pos)

