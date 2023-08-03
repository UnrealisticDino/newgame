extends KinematicBody2D

export var shuriken_scene = preload("res://Shuriken.tscn")
export var speed = 200
export var max_health = 100
var health = max_health

var velocity = Vector2()

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

func shoot_shuriken(target_position):
	var direction = target_position - global_position
	var shuriken = shuriken_scene.instance()
	shuriken.global_position = global_position
	shuriken.velocity = direction.normalized() * shuriken.speed
	get_parent().add_child(shuriken)

func take_damage(damage):
	health -= damage
	health = clamp(health, 0, max_health)
	print("Player health: ", health) # Print the current health
	if health <= 0:
		die()
		
func die():
	print("Player has died!") # Print a message when the player dies
	get_tree().quit()
