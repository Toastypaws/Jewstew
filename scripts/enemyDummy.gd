extends CharacterBody3D

@onready var collision = $collision
@onready var player = get_tree().get_first_node_in_group("player")
@onready var detectPlayer = $detectPlayer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var zombieHealth = 20
var toPlayer = 0
var hitCountdown = 0
var first = true

const zombieDamage = 10
const zombieSpeed = 2
const hitRadius = 2
const hitCoolDown = 30

func damage(val):
	zombieHealth -= val
	print("ow ", zombieHealth)
	if zombieHealth <= 0:
		collision.disabled = true

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
		

func _process(delta):
	self.look_at(Vector3(player.global_position.x, 0, player.global_position.z))
	hitPlayer()

func _physics_process(delta):
	toPlayer = (player.global_position - global_position).normalized()
	toPlayer.y = 0
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity = toPlayer * zombieSpeed
	
	move_and_slide()
