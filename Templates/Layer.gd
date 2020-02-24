extends Area2D

onready var parent := self.get_parent()

# light mask 1 is for light from objects
# light mask 2 is for ambient lighting

# Automatic setup
func _ready() -> void: 
	print(parent.get_light_mask())
	# Signals to detect player body
	self.connect("body_entered", self, "_on_LayerSystem_body_entered")
	self.connect("body_exited", self, "_on_LayerSystem_body_exited")
	# Set Z index based on whether parent object is a StaticBody or a KinematicBody
	if parent as StaticBody2D:
		parent.z_index = 0
	elif parent as KinematicBody2D:
		parent.z_index = 2
	parent.z_as_relative = false
	# Set light mask 
	parent.set_light_mask(3)
func _on_LayerSystem_body_entered(body: PhysicsBody2D) -> void:
	if body as KinematicBody2D:
		if body.name == global.current_player_name:
			# Hide the player behind this node
			parent.z_index = 1
			parent.set_light_mask(2)
			#parent.get_node("Sprite").set_light_mask(2)
			#parent.get_node("LightOccluder2D").set_occluder_light_mask(1)
			body.z_index = 0
			(body.get_node("Light2D") as Light2D).z_index = -5

func _on_LayerSystem_body_exited(body: PhysicsBody2D) -> void:
	if body as KinematicBody2D:
		if body.name == global.current_player_name:
			# Reset Z index
			if parent as StaticBody2D:
				parent.z_index = 0
			elif parent as KinematicBody2D:
				parent.z_index = 2
			parent.set_light_mask(3)
			#parent.get_node("Sprite").set_light_mask(3)
			#parent.get_node("LightOccluder2D").set_occluder_light_mask(0)
			body.z_index = 3
			(body.get_node("Light2D") as Light2D).z_index = -3
