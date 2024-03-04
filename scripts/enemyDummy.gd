extends CharacterBody3D

@export var player : Node3D
@onready var collision = $collision
@onready var navAgent = $navigation
@onready var explosion = $explosion
@onready var playerDetector = $playerDetector
@onready var mesh = $mesh
@onready var animator = $animator

var rng = RandomNumberGenerator.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var zombieHealth = 20
var hitCountdown = 0
var first = true

const zombieDamage = 10
const zombieSpeed = 10
const hitRadius = 2
const hitCoolDown = 30

func damage(val):
	zombieHealth -= val
	print("ow ", zombieHealth)
	if zombieHealth <= 0:
		explosion.emitting = true
		collision.disabled = true
		queue_free()
		
func updateTarget():
	if(playerDetector.is_colliding()):
		if(playerDetector.get_collider().is_in_group("player")):
			navAgent.target_position = player.global_position

func hitPlayer():
	if global_position.distance_to(player.global_position) <= hitRadius:
		hitCountdown -= 1
		if(hitCountdown <= 0):
			hitCountdown = hitCoolDown
			if(!first):
				player.hit(zombieDamage)
			first = false
	else:
		first = true
		

func _ready():
	animator.current_animation = "idle"

func _process(delta):
	playerDetector.target_position = to_local(player.global_position)
	playerDetector.target_position.y -= 2
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
	hitPlayer()
	
	if(velocity.x != 0 || velocity.z != 0):
		animator.current_animation = "run"
	else:
		animator.current_animation = "idle"

func _physics_process(delta):
	var currentPosition = global_position
	var nextPosition = navAgent.get_next_path_position()
	var moveTo = (nextPosition - currentPosition).normalized()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity = moveTo * zombieSpeed
	
	move_and_slide()


func _on_nav_cooldown_timeout():
	updateTarget()
