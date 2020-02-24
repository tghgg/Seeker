extends KinematicBody2D

export (Color) var color # COLOR OF THE TEXT

export (float, 0.0, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS

export (String, FILE) var interaction_script # A JSON DIALOGUE FILE

onready var animation := $Sprite






