# monster1.gd
extends Area2D

var health = 100  # The monster's health
var speed = 50  # The speed at which the monster moves
var player = null  # The player

func _ready():
	player = get_node("/root/MainScene/Player")  # Get the player node
	add_to_group("monsters")  # Add this monster to the "monsters" group

	# Connect to the hit signal from all orbs
	for orb in get_tree().get_nodes_in_group("orbs"):
		orb.connect("hit", self, "_on_Monster_hit")

func _physics_process(delta):
	if player:
		var direction = (player.position - position).normalized()  # Get the direction to the player
		position += direction * speed * delta  # Move towards the player

func _on_Monster_hit(_area, damage):
	health -= damage  # Reduce the monster's health by the damage
	if health <= 0:
		queue_free()  # If the monster's health is 0 or less, remove it from the scene
