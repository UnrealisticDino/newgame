extends Area2D

var experience = 0  # The player's experience points
var speed = 200  # Speed of the player
var Orb = preload("res://orb1.tscn")  # Load the orb scene
var level = 1  # The player's level
var health = 100  # The player's health

func _ready():
	position = get_viewport_rect().size / 2
	connect("area_entered", self, "_on_Player_area_entered")  # Connect the area_entered signal

func _physics_process(delta):
	var velocity = Vector2()  # The player's movement vector

	# Input mapping
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1

	velocity = velocity.normalized() * speed  # Normalize the vector for consistent speed

	position += velocity * delta  # Move the player

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		var orb = Orb.instance()  # Create a new orb
		get_parent().add_child(orb)  # Add the orb to the scene
		orb.position = position  # Set the orb's position to the player's position
		var direction = get_global_mouse_position() - position  # Get the direction to the mouse
		orb.shoot(direction.normalized())  # Shoot the orb in the direction of the mouse

		# Connect the hit signal from the orb to all monsters
		for monster in get_tree().get_nodes_in_group("monsters"):
			orb.connect("hit", monster, "_on_Monster_hit")

func gain_experience(amount):
	experience += amount
	if experience >= 20:
		level_up()  # Level up the player

# This function is called when the player levels up
func level_up():
	level += 1
	experience = 0  # Reset the experience points
	print("Leveled up! Current level: " + str(level))

func _on_Player_area_entered(area):
	if area.is_in_group("monsters"):
		health -= 10  # Reduce the player's health by 10
		if health <= 0:
			print("Game over!")  # If the player's health is 0 or less, end the game
			get_tree().quit()  # Stop the game
