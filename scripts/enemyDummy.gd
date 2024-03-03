extends CharacterBody3D

@export var player : Node3D
@onready var collision = $collision
@onready var navAgent = $navigation
@onready var musicInit = $music_init
@onready var tf2_theme = $tf2_theme

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
		collision.disabled = true
		
func updateTarget():
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
	musicInit.wait_time = rng.randi_range(0, 10)
	musicInit.start()

func _process(delta):
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
	hitPlayer()

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


func _on_music_init_timeout():
	tf2_theme.play()
