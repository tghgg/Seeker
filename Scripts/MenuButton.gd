extends MenuButton

onready var popup: PopupMenu

func _ready() -> void:
	popup = get_popup()
	get_popup().connect("id_pressed", self, "_on_item_pressed")

# Open game window size menu
func _on_item_pressed(ID: int) -> void:
	print(popup.get_item_text(ID), " pressed")
#	sfx_handler.play("button")
	if (ID == 0):
		get_popup().set_item_checked(ID, true)
		get_popup().set_item_checked(1, false)
		OS.window_fullscreen = true
	elif (ID == 1):
		get_popup().set_item_checked(ID, true)
		get_popup().set_item_checked(0, false)
		OS.window_fullscreen = false

#func _on_MenuButton_about_to_show():
#	sfx_handler.play("button")
