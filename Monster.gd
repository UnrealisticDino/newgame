#Monster
extends KinematicBody2D

export var speed = 100
export var max_health = 50
var health = max_health
var player_in_range = false
var velocity = Vector2()
var player

func _physics_process(delta):
	if player_in_range:
		player.take_damage(20 * delta) # Deal 20 damage per second
	var player = get_node("/root/MainGame/Player") # Adjust the path to your player node
	var direction = player.global_position - global_position
	velocity = direction.normalized() * speed
	move_and_slide(velocity)

func take_damage(damage):
	health -= damage
	health = clamp(health, 0, max_health)
	if health <= 0:
		die()

func die():
	queue_free() # Despawn the monster

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		player_in_range = true

func _on_Area2D_body_exited(body):
	if body.has_method("take_damage"):
		player_in_range = false

func _ready():
	player = get_node("/root/MainGame/Player")
