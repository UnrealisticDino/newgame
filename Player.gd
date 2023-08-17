#Player
extends KinematicBody2D

export var shuriken_scene = preload("res://Shuriken.tscn")
export var speed = 200
export var max_health = 100
export var tracking_speed = 0.05  # Adjust this value as needed

var health = max_health

var velocity = Vector2()
var shuriken
var tracking_power_up
var multi_power_up
var shuriken_instance
var has_tracking_power_up = false  # Add this line
var has_multipowerup = false

func _ready():
	tracking_power_up = get_node("/root/MainGame/TrackingPowerUp")
	# Connect the signal to detect when the player picks up the power-up
	tracking_power_up.connect("area_entered", self, "_on_TrackingPowerUp_area_entered")
	
	multi_power_up = get_node("/root/MainGame/MultiPowerUp")
	multi_power_up.connect("area_entered", self, "_on_MultiPowerUp_area_entered")

func _on_TrackingPowerUp_area_entered(area):
	if area == $Area2D:
		has_tracking_power_up = true  # Set the variable to true when the power-up is picked up
		tracking_power_up.queue_free()

func _on_MultiPowerUp_area_entered(area):
	if area == $Area2D:
		has_multipowerup = true
		multi_power_up.queue_free()

func shoot_shuriken(target_position):
	var direction = target_position - global_position
	shuriken_instance = shuriken_scene.instance()
	shuriken_instance.global_position = global_position
	shuriken_instance.velocity = direction.normalized() * shuriken_instance.speed
	shuriken_instance.initial_direction = direction.normalized()
	if has_tracking_power_up:
		shuriken_instance.is_tracking = true
	get_parent().add_child(shuriken_instance)

	if has_multipowerup:
		var multi_power_up = shuriken_scene.instance()
		multi_power_up.global_position = global_position + Vector2(10, 0) # Adjust this for the desired offset
		multi_power_up.velocity = direction.normalized() * multi_power_up.speed
		multi_power_up.initial_direction = direction.normalized()
		if has_tracking_power_up:
			multi_power_up.is_tracking = true
		get_parent().add_child(multi_power_up)
	
func take_damage(damage):
	health -= damage
	health = clamp(health, 0, max_health)
	print("Player health: ", health) # Print the current health
	if health <= 0:
		die()

func die():
	print("Player has died!") # Print a message when the player dies
	get_tree().quit()

func _process(delta):
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	move_and_slide(velocity)
	if Input.is_action_just_pressed("ui_accept"):
		var mouse_position = get_global_mouse_position()
		shoot_shuriken(mouse_position)
