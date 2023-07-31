#Orb1
extends Area2D

var speed = 400
var direction = Vector2()
var monsters = []
var base_damage = 10  # The orb's base damage
var player = null  # The player
var health = 50

# Declare a new signal
signal hit

func shoot(dir):
	direction = dir

func _ready():
	player = get_node("/root/MainScene/Player")  # Get the player node
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
		var damage = min(health, 10)  # Calculate the damage, it should not exceed the orb's health
		health -= damage  # Decrease the orb's health
		emit_signal("hit", area, damage, base_damage, player.damage_multiplier)
		if health <= 0:
			queue_free()  # If the orb's health is 0 or less, remove it from the scene
