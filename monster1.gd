extends KinematicBody2D

var health = 100  # The monster's health
var speed = 50  # The speed at which the monster moves
var player = null  # The player

func _ready():
	player = get_node("/root/MainScene/Player")  # Get the player node
	connect("body_shape_entered", self, "_on_Monster_body_shape_entered")  # Connect the body_shape_entered signal

# This function is called when the monster is hit by an orb
func _physics_process(delta):
	if player:
		var direction = (player.position - position).normalized()  # Get the direction to the player
		position += direction * speed * delta  # Move towards the player

func _on_Monster_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.is_in_group("orbs"):
		health -= 10  # Reduce the monster's health by 10
		if health <= 0:
			queue_free()  # If the monster's health is 0 or less, remove it from the scene
