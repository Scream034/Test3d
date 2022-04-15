extends Control


var pressed: bool
export var cast: Vector3
export var cast_global: Vector3

onready var menu = get_parent().get_node("menu")
onready var menu_button_cube = get_parent().get_node("menu/bg/type_obj/cube")
onready var menu_button_floor = get_parent().get_node("menu/bg/type_obj/floor")
onready var raycast = get_parent().get_node("RayCast")
onready var camera = get_parent()


	# creates
var is_create = false
var name_index = 0

# cube
onready var cube_new = preload("res://cube.tscn")
var CUBE = null
var is_create_cube: bool
# floor
onready var floor_new = preload("res://floor.tscn")
var FLOOR = null
var is_create_floor: bool

export var speed = 0.35
var default_speed

func _physics_process(delta):
	if Input.is_action_just_pressed("create_menu"):
		pressed = true if !pressed else false
	if pressed:
		camera.is_menu = true
		get_parent().get_node("menu").visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		camera.is_menu = false
		get_parent().get_node("menu").visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
		# raycast
	var cast = raycast.cast_to
	raycast.force_raycast_update()
	
	if raycast.get_collider():
		cast_global = raycast.to_global(raycast.get_collision_point())
		cast = raycast.to_local(raycast.get_collision_point())
	else:
		raycast.cast_to.z -= 0.1
	
	raycast.get_node("polygon").polygon[0] = Vector2(-cast.z, 0)
	raycast.get_node("polygon").polygon[1] = Vector2(-cast.z, 0.14)
	
	
		# for create
	if is_create and raycast.get_collider():
			# change property
		if Input.is_action_pressed("position_forward"):
			if is_create_cube:
				CUBE.global_transform.origin.z += speed
			elif is_create_floor:
				FLOOR.global_transform.origin.z += speed
		if Input.is_action_pressed("position_backward"):
			if is_create_cube:
				CUBE.global_transform.origin.z -= speed
			elif is_create_floor:
				FLOOR.global_transform.origin.z -= speed
		if Input.is_action_pressed("position_left"):
			if is_create_cube:
				CUBE.global_transform.origin.x += speed
			elif is_create_floor:
				FLOOR.global_transform.origin.x += speed
		if Input.is_action_pressed("position_right"):
			if is_create_cube:
				CUBE.global_transform.origin.x -= speed
			elif is_create_floor:
				FLOOR.global_transform.origin.x -= speed
		
			# position set
		if Input.is_action_just_pressed("ui_select"):
			if is_create_floor:
				FLOOR.transform.origin = raycast.get_collision_point()
			elif is_create_cube:
				CUBE.transform.origin = raycast.get_collision_point()
			# if exit from create
		elif Input.is_action_just_pressed("ui_exit"):
			name_index += 1
			if is_create_cube:
				is_create_cube = false
			if is_create_floor:
				is_create_floor = false
			is_create = false
			print(name_index)
		# check
		if !is_create_cube and CUBE != null:
			CUBE.use_collision = true
			CUBE.name = str(name_index)
		elif !is_create_floor and FLOOR != null:
			FLOOR.use_collision = true
			FLOOR.name = str(name_index)
		
	# for speed to positon
	if Input.is_action_pressed("speed_slow"):
		speed = 0.05
	elif Input.is_action_pressed("speed_fast"):
		speed = 1
	else:
		speed = default_speed
	
	
						# TEXT #
	
	$check/check2.text = 'true' if is_create else 'false'
	if is_create:
		$check/check2.add_color_override("font_color", ColorN('red', 1.0))
	else:
		$check/check2.add_color_override("font_color", ColorN('blue', 1.0))



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	default_speed = speed
	
	# signals
	menu_button_cube.connect("button_down", self, "set_cube")
	menu_button_floor.connect("button_down", self, "set_floor")


func set_cube():
	CUBE = cube_new.instance()
	pressed = false
	is_create_floor = false
	is_create_cube = true
	is_create = true
	get_node("/root").add_child(CUBE)


func set_floor():
	FLOOR = floor_new.instance()
	pressed = false
	is_create_cube = false
	is_create_floor = true
	is_create = true
	get_node("/root").add_child(FLOOR)

