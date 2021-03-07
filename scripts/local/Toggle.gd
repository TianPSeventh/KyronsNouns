extends Button


func _on_Toggle_toggled(button_pressed):
	text = "%s" % ("On" if button_pressed else "Off")
