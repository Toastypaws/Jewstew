extends Node3D

@onready var pistolPlayer = $pistolAnimation
@onready var pistolFire = $audioManager/pistolFire
@onready var fireRing = $fireRing
@onready var pistolRay = $pistolRay
@onready var player = get_owner()

var pistolDamage = global.weapons["pistol"].damage
var fireRate = global.weapons["pistol"].fireRate
var fireCountdown = 0

func gunAnimate():
	if(player.velocity.x != 0 || player.velocity.z != 0):
		if !pistolPlayer.current_animation == "fire":
			pistolPlayer.play("move")
	else:
		if !pistolPlayer.current_animation == "fire":
			pistolPlayer.play("idle")
	if(player.velocity.y != 0 && pistolPlayer.current_animation == "fire"):
		pistolPlayer.play("falling")
		rotation.x += player.velocity.y/(100*player.JUMP_VELOCITY)
	else:
		rotation.x = 0


func shoot():
	if fireCountdown != 0:
		pass
	else:
		pistolPlayer.stop()
		pistolPlayer.play("fire")
		pistolFire.playing = true
		fireRing.visible = true
		fireCountdown = fireRate
		if pistolRay.is_colliding():
			if pistolRay.get_collider().has_method("damage"):
				pistolRay.get_collider().damage(pistolDamage)

func _process(delta):
	if fireCountdown >> 0:
		fireCountdown -= 1
