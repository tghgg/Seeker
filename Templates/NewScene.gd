extends Node2D

export (bool) var is_top_down := true

onready var player := $Characters/Seeker
onready var UI := $Characters/Seeker/Camera2D/UI

# Set up the scene
func _ready() -> void:
	# Reset the reference to camera for the MSG_Parser 
	MSG.camera = get_node('Characters/%s/Camera2D' % global.current_player_name)
	# Set global reference variables
	global.set_current_scene(self.name)
	global.set_can_talk(true)
	
	# Disable the tint momentarily
	#$BG/Map/CanvasModulate/AnimationPlayer.play_backwards("set_tint")
	
	# Fade in the scene
	$Transition.visible = true
	$Transition.fade_out()
	
	# Start emitting particles
	if self.has_node("Particles"): 
		$Particles.emit_all()

	# Play the level's theme
	#GlobalMusicPlayer.set_music("res://assets/music/slow_low.ogg")
	
	# Set the position of the player according to the last time 
	# the player was in this scene
	if (global.player_exit_points.has(self.name)):
		player.global_position = global.player_exit_points[self.name].position
		# Disable the exit node the player used previously
		get_node(global.player_exit_points[self.name].exit_node).monitoring = false
		yield(get_tree().create_timer(2.5), "timeout")
		get_node(global.player_exit_points[self.name].exit_node).monitoring = true
	
	# SAVE DATA HANDLING HERE
	# Usually will set up story stuff based on the save data
	var save_data = global.get_save_data()
	if save_data.has(self.name):
		print("Loading from save")
		# Stuff to do
	else: 
		print("Creating new save entry for this level")
		# Update save data and autosave
		UI.popup_element("SaveIndicator", 3)
		global.set_save_data("global", {
			"current_scene": self.filename
		})
		global.set_save_data(self.name, {
			"dialogue_finished": false,
			"current_position": player.get_global_position()
		})
		# Stuff to do

# Method for other nodes to use
# Fade to black and freeze player input and movement
func change_scene(scene: String, time:=1.5, delay_between_scenes:=0) -> void:
	global.set_can_talk(false)
	$Transition.fade_in(time)
	yield(get_tree().create_timer(time+delay_between_scenes), "timeout")
	get_tree().change_scene(scene)
