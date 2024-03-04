extends CharacterBody3D

const WALK_SPEED = 10.0
const RUN_SPEED = 20.0
const JUMP_VELOCITY = 15
const POUND_VELOCITY = -50

var speed = 20.0
var health = 100
var gravity = 15
var currentWeapon = Global.weapons["pistol"]

@onready var camera = $playerHead
@onready var weaponView = $playerHead/playerCamera/weaponViewCont/weaponView
@onready var weaponCamera = $playerHead/playerCamera/weaponViewCont/weaponView/weaponCamera
@onready var currentWeaponLocation = get_node(currentWeapon.location)
@onready var playerAnimator = $playerAnimator
@onready var playerCollision = $playerCollision

@onready var playerHurt = $audioManager/playerHurt

func playerDeath():
	print("You are dead.")
	playerCollision.disabled = true
	pass

func hit(damage):
	if health <= 0:
		playerDeath()
	else:
		health -= damage
		print(health)
		playerAnimator.play("playerCameraShake")
		playerHurt.play()
		if health <= 0:
			playerDeath()

func _ready():
	weaponView.size = get_viewport().size
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _init():
	RenderingServer.set_debug_generate_wireframes(true)

func _input(event):
	if event is InputEventKey and Input.is_key_pressed(KEY_P):
		var vp = get_viewport()
		vp.debug_draw = (vp.debug_draw + 1 ) % 4
	
	
	if event is InputEventMouseMotion:
		rotate(Vector3.UP, -event.relative.x * Global.mouseSensitivity)
		camera.rotate(Vector3.RIGHT, -event.relative.y * Global.mouseSensitivity)

func _process(delta):
	camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)
	weaponCamera.global_transform = camera.global_transform
	currentWeaponLocation.gunAnimate()

func _physics_process(delta):
	
	if Input.is_action_just_pressed("fire"):
		currentWeaponLocation.shoot()
		playerAnimator.play("playerCameraShake")

	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if(Input.is_action_just_pressed("jump") && is_on_floor()):
		velocity.y = JUMP_VELOCITY
	
	if(Input.is_action_pressed("sprint")):
		speed = RUN_SPEED;
	else:
		speed = WALK_SPEED;
	
	if(Input.is_action_just_pressed("ground_pound")):
		velocity.y = POUND_VELOCITY

	var input_dir = Input.get_vector("strafe_left", "strafe_right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
