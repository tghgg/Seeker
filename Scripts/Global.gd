extends Node

# signal to handle dialogue events
# just like the old SMRT times
signal dialogue_finished 

# global variables
# now with static typing
onready var _can_talk := true setget set_can_talk, get_can_talk
onready var _current_scene: String setget set_current_scene, get_current_scene
onready var _current_body: Area2D setget set_current_body, get_current_body
onready var top_down := true setget set_top_down, get_top_down
onready var shake_camera := false
onready var current_player_name := "Seeker"
# Stores the player's various exit points
onready var player_exit_points := {}
# Dev environment
onready var env := "prod"
# Top-down movement check getters and setters
func set_top_down(value: bool) -> void:
	top_down = value
func get_top_down() -> bool:
	return top_down

# Shake the camera
func set_shake_camera(val: bool, end_time := 2.0) -> void:
	if val:
		shake_camera = val
		if end_time != 0.0:
			yield(get_tree().create_timer(end_time), "timeout")
			shake_camera = false
	else:
		shake_camera = val

# Dialogue check getters and setters
func set_can_talk(value: bool, emit_signal := true) -> void:
	if value and emit_signal:
		# Signal emits whenever a dialogue is finished
		# Used for creating events involving dialogues
		emit_signal("dialogue_finished")
	_can_talk = value
func get_can_talk() -> bool:
	return _can_talk

# Current scene check getters and setters 
func set_current_scene(value: String) -> void:
	_current_scene = value
func get_current_scene() -> String:
	return _current_scene

# Current body the player is interacting with check getters and setters 
func set_current_body(value: Area2D) -> void:
	_current_body = value
func get_current_body() -> Area2D:
	return _current_body

# Get the player from anywhere in the codebase
func get_player():
	if _current_scene:
		if get_tree().get_root().has_node("%s/Characters/" % _current_scene+ "%s" % current_player_name):
			return get_tree().get_root().get_node("%s/Characters/"  % _current_scene + "%s" % current_player_name) as Node
	return null

# SAVE SYSTEM

# Create a save file if one doesn't exist
func _ready() -> void:
	if get_save_data() and env != "dev":
		return
	var save_file := File.new()
	save_file.open("user://.seeker.save", File.WRITE)
	save_file.store_line(to_json({
	"global": {
		"current_scene": null
	}}))
	save_file.close()

# Set a key in the save file
func set_save_data(key: String, val: Dictionary) -> void:
	var save_file: File = File.new()
	# Stop if the save file doesn't exist
	if not save_file.file_exists("user://.seeker.save"):
		return
	save_file.open("user://.seeker.save", File.READ_WRITE)
	var data: Dictionary = parse_json(save_file.get_as_text())
	data[key] = val
	save_file.store_line(to_json(data))
	save_file.close()

# Load the save file 
func get_save_data() -> Dictionary:
	var save_file: File = File.new()
	# Stop if the save file doesn't exist
	if not save_file.file_exists("user://.seeker.save"):
		return {}
	save_file.open("user://.seeker.save", File.READ)
	var data: Dictionary = parse_json(save_file.get_as_text())
	save_file.close() 
	return data
