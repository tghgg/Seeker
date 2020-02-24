extends Node2D

# Auto-hide the bubble
func _ready() -> void:
	self.modulate.a = 0

func play_animation(anim := "default", play_sfx := true) -> void:
	get_node("AnimationPlayer").play("create_bubble")
	get_node("AnimatedSprite").play(anim)
	if play_sfx:
		get_node("AudioStreamPlayer2D").play()
	
func stop_animation() -> void:
	get_node("AnimationPlayer").play_backwards("create_bubble")
	get_node("AnimatedSprite").stop()
