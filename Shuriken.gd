# Shuriken
extends KinematicBody2D

export var speed = 500
export var deceleration = 350
export var tracking_speed = 100  # Add this line

var velocity = Vector2()
var is_tracking = false  # Add this line

func _physics_process(delta):
	# If tracking is enabled, find the nearest monster and set the velocity
	if is_tracking:
		var nearest_monster = find_nearest_monster()
		if nearest_monster:
			var direction = (nearest_monster.global_position - global_position).normalized()
			velocity = direction * speed  # Set the velocity to the tracking direction
	# Move the shuriken
	move_and_slide(velocity)
	# Reduce the speed of the shuriken
	speed -= deceleration * delta
	speed = max(speed, 0) # Ensure speed doesn't go negative
	# If the shuriken has stopped, despawn it
	if speed == 0:
		queue_free()

func find_nearest_monster():
	var nearest_monster = null
	var nearest_distance = INF
	for monster in get_tree().get_nodes_in_group("Monsters"):
		print("head")
		var distance = monster.global_position.distance_to(global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_monster = monster

func _on_Shuriken_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10) # Deal 10 damage
		queue_free() # Despawn the shuriken

func _on_Area2D_body_entered(body):
	print("body_entered signal received!") # This line will print a message
	if body.has_method("take_damage"):
		body.take_damage(10)
		queue_free()
