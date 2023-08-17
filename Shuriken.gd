# Shuriken
extends KinematicBody2D

export var speed = 500
export var deceleration = 350
export var tracking_speed = 100

var target_monster = null
var aim_direction = Vector2.ZERO
var velocity = Vector2()
var is_tracking = false
var initial_direction = Vector2.ZERO

func _physics_process(delta):
	# If tracking is enabled, try to find a target using raycasting
	if is_tracking:
		# Use the raycast to find a monster in the direction the player is aiming
		target_monster = find_target_monster(aim_direction)
		if not raycast_in_direction():
			# If no monster is found using raycasting, find the nearest monster
			target_monster = find_nearest_monster()

	# If a target monster is found (either through raycasting or nearest search)
	if target_monster and is_instance_valid(target_monster):
		var direction = (target_monster.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		# If no target monster is found, stop tracking
		stop_tracking()

	velocity = velocity.normalized() * speed  # Update the velocity with the new speed
	move_and_slide(velocity)
	speed -= deceleration * delta
	speed = max(speed, 0)
	if speed == 0:
		queue_free()

func find_nearest_monster():
	if target_monster == null or not is_instance_valid(target_monster):
		stop_tracking()
		var nearest_distance = INF
		for monster in get_tree().get_nodes_in_group("Monsters"):
			var direction_to_monster = (monster.global_position - global_position).normalized()
			var distance = monster.global_position.distance_to(global_position)
			var angle = aim_direction.angle_to(direction_to_monster)
			var biased_distance = distance * (1 + angle * 30)  # Add bias towards monsters in the aim direction
			if biased_distance < nearest_distance:
				nearest_distance = biased_distance
				target_monster = monster
	return target_monster

func fire(direction):
	initial_direction = direction.normalized()
	velocity = initial_direction * speed

func stop_tracking():
	is_tracking = false
	target_monster = null

func _on_Shuriken_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10) # Deal 10 damage
		queue_free() # Despawn the shuriken

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10)
		queue_free()

func find_target_monster(mouse_position):
	aim_direction = (mouse_position - global_position).normalized()
	
	# 1. Shoot a line in the direction of the mouse click
	if raycast_in_direction():
		return

	# 2. Spread out into a cone
	var angle_increment = PI / 4 / 10  # 45 degrees divided by 10 rays on each side
	for i in range(1, 11):  # 10 rays on each side
		# Check in the clockwise direction
		var new_direction = aim_direction.rotated(angle_increment * i)
		if raycast_in_direction():
			return

		# Check in the counter-clockwise direction
		new_direction = aim_direction.rotated(-angle_increment * i)
		if raycast_in_direction():
			return

	# 3. If no monster is found in the desired direction, find the closest monster
	target_monster = find_nearest_monster()

func raycast_in_direction():
	var ray_start = global_position
	var ray_end = ray_start + initial_direction * 500
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(ray_start, ray_end, [], 4)  # Consider only layer 3
	if result and "Monsters" in result.collider.get_groups():
		target_monster = result.collider
		update()
		return true
	update()
	return false

# This function will draw the ray from the shuriken to the target direction.
func draw_raycast(direction):
	var ray_start = global_position
	var ray_end = ray_start + direction * 500  # Arbitrary distance for visualization
	draw_line(ray_start - global_position, ray_end - global_position, Color(1, 0, 0, 0.5), 2)

func _draw():
	if is_tracking:
		draw_raycast(initial_direction)
		var angle_increment = PI / 4 / 10
		for i in range(1, 11):
			var new_direction_clockwise = initial_direction.rotated(angle_increment * i)
			var new_direction_counter_clockwise = initial_direction.rotated(-angle_increment * i)
			draw_raycast(new_direction_clockwise)
			draw_raycast(new_direction_counter_clockwise)
