extends Area2D

var speed = 400
var direction = Vector2()
var monsters = []

# Declare a new signal
signal hit

func shoot(dir):
	direction = dir

func _ready():
	connect("area_entered", self, "_on_Orb_area_entered")

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
		
	position += direction * speed * delta

func _on_Orb_area_entered(area):
	if area.is_in_group("monsters"):
		emit_signal("hit", area)  # Emit the hit signal
		queue_free()
