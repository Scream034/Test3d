extends Control


var pressed: bool
# cube
var is_create_cube: bool
var cube = null
export var cast: Vector3
export var cast_global: Vector3

onready var menu = get_parent().get_node("menu")
onready var menu_button_cube = get_parent().get_node("menu/bg/type_obj/cube")
onready var menu_button_floor = get_parent().get_node("menu/bg/type_obj/floor")
onready var raycast = get_parent().get_node("RayCast")
onready var camera = get_parent()


# cube
onready var cube_new = preload("res://cube.tscn")



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
		raycast.cast_to.z += 2.5
	
	raycast.get_node("polygon").polygon[0] = Vector2(-cast.z, 0)
	raycast.get_node("polygon").polygon[1] = Vector2(-cast.z, 0.14)
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	# for create
	if is_create_cube:
		if Input.is_action_just_pressed("ui_select") and raycast.get_collider():
			cube.transform.origin = camera.cast
			print(cube)
		elif Input.is_action_just_pressed("ui_exit"):
			is_create_cube = false
	
	$check/check2.text = 'true' if is_create_cube else 'false'
	if is_create_cube:
		$check/check2.add_color_override("font_color", ColorN('red', 1.0))
	else:
		$check/check2.add_color_override("font_color", ColorN('blue', 1.0))
		


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# signals
	menu_button_cube.connect("button_down", self, "set_cube")


func set_cube():
	cube = cube_new.instance()
	pressed = false
	is_create_cube = true
	get_node("/root").add_child(cube)
	
	

