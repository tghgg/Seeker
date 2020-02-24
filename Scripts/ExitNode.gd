extends Area2D

export (String, FILE) var exit_scene

# Connect signals 
func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")

# Exit function
func _on_body_entered(body: PhysicsBody2D) -> void:
	if body as KinematicBody2D and body.name == global.current_player_name:
		var current_root := body.get_parent().get_parent()
		# Use the root scene the player is in to change the scene
		global.player_exit_points[current_root.name] = {
			"position": body.position,
			"exit_node": self.get_path()
		}
		current_root.change_scene(exit_scene)
