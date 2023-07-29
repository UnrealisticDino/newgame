extends Node2D

var Player = preload("res://Player.tscn")  # Load the player scene
var Monster = preload("res://monster1.tscn")  # Load the monster scene

func _ready():
	var timer = Timer.new()  # Create a new Timer node
	timer.wait_time = 5  # Set the timer's wait time to 5 seconds
	timer.one_shot = false  # The timer will not stop after it finishes counting down
	timer.autostart = true  # The timer will start automatically when the game starts
	add_child(timer)  # Add the timer to the scene
	timer.connect("timeout", self, "_on_Timer_timeout")  # Connect the timer's timeout signal to a function

	var player = Player.instance()  # Create a new player
	add_child(player)  # Add the player to the scene
	player.position = get_viewport_rect().size / 2  # Set the player's position to the middle of the screen

func _on_Timer_timeout():
	var monster = Monster.instance()  # Create a new monster
	add_child(monster)  # Add the monster to the scene
	monster.position = Vector2(rand_range(0, get_viewport_rect().size.x), rand_range(0, get_viewport_rect().size.y))  # Set the monster's position to a random position in the viewport
