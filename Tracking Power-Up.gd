# Tracking Power-Up
extends Area2D


print("hello test")
func _on_TrackingPowerUp_area_entered(area):
	print("test game")
	if area.is_in_group("Player"):  # Check if the entered area belongs to the player
		print("test game 2")
		area.has_tracking_power_up = true  # Set the player's has_tracking_power_up variable to true
		print("Player picked up the tracking power-up!")  # Output a message
		queue_free()  # Remove the power-up from the scene
