extends Control


var pressed = false
export var cast: Vector3
export var cast_global: Vector3

onready var menu = get_parent().get_node("menu")
onready var menu_button_cube = get_parent().get_node("menu/bg/type_obj/cube")
onready var menu_button_floor = get_parent().get_node("menu/bg/type_obj/floor")
onready var raycast = get_parent().get_node("RayCast")


# cube
onready var cube_new = MeshInstance.new()

func _physics_process(delta):
	if Input.is_action_just_pressed("create_menu"):
		pressed = true if !pressed else false
	if pressed:
		get_parent().get_node("menu").visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
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
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# signals
	menu_button_cube.connect("button_down", self, "set_cube")


func set_cube():
	var cube = menu_button_cube
	pressed = false
	get_parent().get_parent().add_child(cube_new)
	if raycast.get_collider():
		get_parent().get_parent().get_node("cube").transform.origin = cast_global
	

