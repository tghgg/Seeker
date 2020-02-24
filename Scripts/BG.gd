extends Node2D

# Fade out a child sprite
# Default to a black sprite if there's no argument
func fade_out(time:=1.5, scene:='BlackScreen') -> void:
	get_node("FadeOut").interpolate_property(get_node(scene), "modulate:a", 1.0, 0.0, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	get_node("FadeOut").start()

# Fade in a child sprite
# Default to a black sprite if there's no argument
func fade_in(time:=1.5, scene:='BlackScreen') -> void:
	if (scene != null):
		get_node(scene).z_index = 100
		get_node(scene).set_visible(true)
		get_node("FadeIn").interpolate_property(get_node(scene), "modulate:a", 0.0, 1.0, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
		get_node("FadeIn").start()
