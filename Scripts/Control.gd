extends CanvasLayer

onready var settings := $Settings

func _ready() -> void:
# warning-ignore:return_value_discarded
	settings.get_node("Popup/NinePatchRect/Button").connect("pressed", self, "_on_Button_pressed")

func popup_element(menu: String, time_until_hidden:= 0) -> void:
	get_node("%s/Popup" % menu).popup()
	if time_until_hidden != 0:
		yield(get_tree().create_timer(time_until_hidden), "timeout")
		get_node("%s/Popup" % menu).hide()

func hide_element(menu: String) -> void:
	get_node("%s/Popup" % menu).hide()

# Hide the settings menu and unfreeze player movement
# Quit to Title
func _on_Button_pressed() -> void:
	settings.hide()
	global.set_can_talk(true, false)
	get_tree().change_scene("res://src/Scenes/Title.tscn")
