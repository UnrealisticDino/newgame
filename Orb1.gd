# Orb1.gd
extends Area2D

var speed = 400  # The orb's initial speed
var deceleration = 200  # The rate at which the orb slows down
var direction = Vector2()
var monsters = []
var base_damage = 100  # The orb's base damage
var player = null  # The player

# Declare a new signal
signal hit

func shoot(dir):
	direction = dir.normalized()  # Normalize the direction to ensure consistent speed

func _ready():
	player = get_node("/root/MainScene/Player")  # Get the player node
	connect("body_entered", self, "_on_Orb_body_entered")  # Connect to the body_entered signal
	add_to_group("orbs")  # Add the orb to the "orbs" group

func _physics_process(delta):
	monsters = get_tree().get_nodes_in_group("monsters")  # Update the monsters array

	var closest_monster = null
	var closest_distance = INF

	for monster in monsters:
		var distance = position.distance_to(monster.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_monster = monster

	if closest_monster:
		var target_direction = (closest_monster.position - position).normalized()
		direction = direction.linear_interpolate(target_direction, 0.05)

	# Reduce the speed by the deceleration rate
	speed -= deceleration * delta
	speed = max(speed, 0)  # Ensure the speed doesn't go negative
	position += direction * speed * delta

	# If the speed is 0, remove the orb from the scene
	if speed <= 0:
		queue_free()
		
func _on_Orb_body_entered(body):
	if body.is_in_group("monsters"):
		print("Collided with monster at position: ", body.position)
		if body.has_method("get_name"):
			print("Monster name: ", body.get_name())
		print("Calculated damage: ", base_damage)
		emit_signal("hit", body, base_damage)  # Emit the signal with base damage
		queue_free()  # Remove the orb from the scene after hitting a monster
