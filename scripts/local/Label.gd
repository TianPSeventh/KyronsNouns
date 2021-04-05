extends Label

func _enter_tree() -> void:
	setColor(Color(0, 0, 0, (0.1 if GData.hints else 0.0)))

func setColor(newColor:Color) -> void:
	set("custom_colors/font_color",newColor)
	set("custom_colors/font_outline_modulate",newColor)
	set("custom_colors/font_color_shadow",newColor)

func showFull():
	setColor(Color(0, 0, 0, 1))
