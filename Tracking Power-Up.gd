#Tracking Power-Up
extends Area2D

var tracking_speed = 100
var scene_node

func apply(shuriken):
	scene_node = shuriken
	shuriken.connect("physics_process", self, "_on_Shuriken_physics_process")
	print("Connected physics_process signal") # Debugging

func _on_Shuriken_physics_process(delta, shuriken):
	print("Scene node:", scene_node) # Debugging
	var nearest_monster = find_nearest_monster() # Removed the argument here
	if nearest_monster:
		var direction = (nearest_monster.global_position - scene_node.global_position).normalized()
		scene_node.velocity += direction * tracking_speed * delta
		scene_node.move_and_slide(scene_node.velocity)

func find_nearest_monster():
	var nearest_monster = null
	var nearest_distance = INF
	for monster in scene_node.get_tree().get_nodes_in_group("Monsters"):
		var distance = monster.global_position.distance_to(scene_node.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_monster = monster

	return nearest_monster
