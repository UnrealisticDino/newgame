extends KinematicBody2D

export var speed = 500
export var deceleration = 350

var velocity = Vector2()

func _physics_process(delta):
	# Move the shuriken
	move_and_slide(velocity)

	# Reduce the speed of the shuriken
	speed -= deceleration * delta
	speed = max(speed, 0) # Ensure speed doesn't go negative

	# Update the velocity to the new speed
	velocity = velocity.normalized() * speed

	# If the shuriken has stopped, despawn it
	if speed == 0:
		queue_free()
		
func _on_Shuriken_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10) # Deal 10 damage
		queue_free() # Despawn the shuriken


func _on_Area2D_body_entered(body):
	print("body_entered signal received!") # This line will print a message
	if body.has_method("take_damage"):
		body.take_damage(10)
		queue_free()
