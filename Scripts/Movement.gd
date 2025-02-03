extends CharacterBody3D

@export_group("Movement Vars")
@export
var speed: float = 5.0
@export
var jumpVelocity: float = 4.5
@export
var sprintMultiplyer: float = 1.5;

enum PossableStates {SPRINT, WALK, CROUCH, CROUCH_WALK, IDLE}

@export
var _State := PossableStates.IDLE

@export_group("Temp Look Vars")
##TODO remove this and make it global
@export_range(0.001, 0.01, 0.001)
var sensitivity : float = 0.005

var rotX : float = 0
var rotY : float = 0

@onready var camera = $Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = jumpVelocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotX += (event.relative.x * sensitivity * -1)
		rotY += event.relative.y * sensitivity * -1
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, 1, 0), rotX) # first rotate in Y
		#rotate_object_local(Vector3(1, 0, 0), rotY) # then rotate in X
		camera.rotation = Vector3(1, 0, 0) * clamp(rotY, -PI/2, PI/2)
