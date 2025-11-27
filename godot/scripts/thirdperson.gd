extends CharacterBody3D

@onready var yaw_node = $CamRoot/CamYaw
@onready var pitch_node = $CamRoot/CamYaw/CamPitch
@onready var camera = $CamRoot/CamYaw/CamPitch/SpringArm3D/Camera3D
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var armature = $MeshRoot/Armature

@export var look_sensitivity: float = .07
@export var walk_speed: float = 10.0
@export var jump_velocity: float = 4.5
@export var animation_blend_speed: float = 15.0

var yaw: float = 0
var pitch: float = 0

var yaw_acceleration: float = 15
var pitch_acceleration: float = 15

var pitch_max = 75
var pitch_min = -55

enum animation_states {IDLE, WALK, JUMP}

var current_anim: animation_states = animation_states.IDLE

var walk_val: float = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_tree.active = true

func _input(event):
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * look_sensitivity
		pitch += -event.relative.y * look_sensitivity
		return
	if not (event is InputEventKey and event.pressed):
		return

	match event.keycode:
		KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		KEY_SPACE:
			_handle_jump()

func _handle_jump():
	if is_on_floor():
		velocity.y = jump_velocity
	

func _handle_animation():
	match current_anim:
		animation_states.IDLE:
			animation_tree.set("parameters/state/transition_request", "idle")
		animation_states.WALK:
			animation_tree.set("parameters/state/transition_request", "walk")
		animation_states.JUMP:
			animation_tree.set("parameters/state/transition_request", "jump")


func _physics_process(delta: float):
	_handle_animation()
	_handle_camera_look(delta)
	_handle_movement(delta)


func _handle_camera_look(delta: float):
	pitch = clamp(pitch, pitch_min, pitch_max)
	yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
	pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x, pitch, pitch_acceleration * delta)

func _handle_movement(delta: float):
	if not is_on_floor():
		current_anim = animation_states.JUMP
		velocity += get_gravity() * delta
		

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var move_direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	move_direction = move_direction.rotated(Vector3.UP, yaw_node.rotation.y)

	if move_direction:
		if is_on_floor():
			current_anim = animation_states.WALK
		velocity.x = move_direction.x * walk_speed
		velocity.z = move_direction.z * walk_speed
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), .1)
	elif not is_on_floor():
		current_anim = animation_states.JUMP
	else:
		current_anim = animation_states.IDLE
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		velocity.z = move_toward(velocity.z, 0, walk_speed)

	move_and_slide()
