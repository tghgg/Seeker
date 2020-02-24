extends KinematicBody2D

# Export key variables for easy editing 
export (Color) var color # COLOR OF THE TEXT

export (float, 0.0, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS

export (String, FILE) var interaction_script # A JSON DIALOGUE FILE

# Initialize variables
# Default scale = 35
const SCALE := 35
const ACCELERATION := 200 * SCALE
const MAX_SPEED := 500 * SCALE

onready var motion := Vector2(0, 0)
onready var player_animation := $Sprite
# Store the direction the player's hearding towards to set the animation correctly
onready var current_direction := 0
onready var area := $InteractableArea
onready var UI := $Camera2D/UI
onready var shake_amount := 3.0
# Initializeer
# Connect the interactable area's signals to interaction handlers
func _ready() -> void:
	# Reset the reference to camera for the MSG_Parser 
	MSG.camera = $Camera2D
	# Set camera limit according to level's size
	#$Camera2D.limit_right = get_node("../../BG/Map").get_texture().get_size().x
	#$Camera2D.limit_bottom = get_node("../../BG/Map").get_texture().get_size().y
# warning-ignore:return_value_discarded
	area.connect("area_entered", self, "_on_InteractableArea_entered")
# warning-ignore:return_value_discarded
	area.connect("area_exited", self, "_on_InteractableArea_exited")
# warning-ignore:return_value_discarded
	self.connect("tree_exited", self, "_on_tree_exited")


# Dialogue handler
func talk() -> void:
#	print("talking to " + self.name)
	if interaction_script:
		global.set_can_talk(false)
		MSG.start_dialogue(interaction_script, self)
	else:
		print("No dialogue found for the player")


# Interaction with NPCs and objects handler
func _on_InteractableArea_entered(body: Area2D) -> void:
	global.set_current_body(body)
func _on_InteractableArea_exited(_body: Area2D) -> void:
	global.set_current_body(null)

# Input handler
func _physics_process(delta) -> void:
	# Shake the camera
	if global.shake_camera:
		$Camera2D.set_offset(Vector2( 
			rand_range(-1.0, 1.0) * shake_amount, 
			rand_range(-1.0, 1.0) * shake_amount 
		))
	else:
		$Camera2D.set_offset(Vector2(0, 0))
		
	# Open game settings when ESC is pressed
	if Input.is_action_just_pressed("open_settings"):
		if not UI.get_node("Settings/Popup").visible:
			# Freeze player movement
			if global.get_can_talk():
				global.set_can_talk(false)
				UI.popup_element("Settings")
		else:
			if not global.get_can_talk():
				global.set_can_talk(true, false)
				UI.hide_element("Settings")
	
	# Check whether player is in dialogue
	# If in dialogue then freeze all movement until dialogue is finished
	if global.get_can_talk():
		# Interaction Input
		if Input.is_action_just_pressed("interact") and global.get_current_body() != null:
			if global.get_current_body().get_parent() as KinematicBody2D:
				print("Talk to " + global.get_current_body().get_parent().name)
				# get the parent of the area2d which is the Kinematic2D node and use the talk() method
				global.get_current_body().get_parent().talk()
		# Sideway motion
		if Input.is_action_pressed("ui_right"):
			motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
			player_animation.play("walking_sideways")
			player_animation.flip_h = true
			current_direction = 2
		elif Input.is_action_pressed("ui_left"):
			motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
			player_animation.play("walking_sideways")
			player_animation.flip_h = false
			current_direction = 2
		else:
			# TODO: Fix jittering after stopping
			motion.x = lerp(motion.x, 0.0, 1)
		# check for top-down movement 
		if global.get_top_down(): 
			if Input.is_action_pressed("ui_up"):
				motion.y = max(motion.y - ACCELERATION, -MAX_SPEED)
				player_animation.play("walking_front")
				current_direction = -1
			elif Input.is_action_pressed("ui_down"):
				motion.y = min(motion.y + ACCELERATION, MAX_SPEED)
				player_animation.play("walking_front")
				current_direction = 1
			else:
				#motion.x = lerp(motion.x, 0, 0.2)   adds a bit of inertia when stopped
				motion.y = 0
		# Play idle animation based on current direction if standing still
		# 0 is idle
		# 1 is forward
		# -1 is backward
		# 2 is sideways
		if motion == Vector2(0, 0):
			match(current_direction):
				-1:
					player_animation.play("idle_front")
				0:
					player_animation.play("idle_front")
				1:
					player_animation.play("idle_front")
				2:
					player_animation.play("idle_sideways")
	else:
		motion = Vector2(0, 0)
		match(current_direction):
			-1:
				player_animation.play("idle_front")
			0:
				player_animation.play("idle_front")
			1:
				player_animation.play("idle_front")
			2:
				player_animation.play("idle_sideways")\
		# Advance the dialog when dialogue is happening
		if Input.is_action_just_pressed("dialogue_next"):
			MSG.next()

	# move with 'motion' speed, the up direction is y=1, and stop on slopes
# warning-ignore:return_value_discarded
	move_and_slide(motion * delta)

# Clear signal connections when the scene ends
func _on_tree_exited() -> void:
	area.disconnect("area_entered", self, "_on_InteractableArea_entered")
	area.disconnect("area_exited", self, "_on_InteractableArea_exited")


